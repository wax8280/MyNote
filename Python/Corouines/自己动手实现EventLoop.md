### 一个原始的EventLoop

两种事件类型：stdin的事件和定时器事件，允许用户添加任意数量的事件处理函数。

对于定时器事件，我们维护一个按时间排序的事件列表，最近需要运行的定时器在最前面。

`self._selector`注册了`sys.stdin`。

`run_forever`函数在每一个循环里面执行`self._stdin_handlers`的callback，并监视`self._timers`，若时间到，则调用该callback。

```py
from bisect import insort
from fib import timed_fib
from time import time
import selectors
import sys


class EventLoop(object):
    """
    Implements a callback based single-threaded event loop as a simple
    demonstration.
    """
    def __init__(self, *tasks):
        self._running = False
        self._stdin_handlers = []
        self._timers = []
        self._selector = selectors.DefaultSelector()
        self._selector.register(sys.stdin, selectors.EVENT_READ)

    def run_forever(self):
        self._running = True
        while self._running:
            # First check for available IO input
            for key, mask in self._selector.select(0):
                line = key.fileobj.readline().strip()
                for callback in self._stdin_handlers:
                    callback(line)

            # Handle timer events
            while self._timers and self._timers[0][0] < time():
                handler = self._timers[0][1]
                del self._timers[0]
                handler()

    def add_stdin_handler(self, callback):
        self._stdin_handlers.append(callback)

    def add_timer(self, wait_time, callback):
        insort(self._timers, (time() + wait_time, callback))

    def stop(self):
        self._running = False


def main():
    loop = EventLoop()

    def on_stdin_input(line):
        if line == 'exit':
            loop.stop()
            return
        n = int(line)
        print("fib({}) = {}".format(n, timed_fib(n)))

    def print_hello():
        print("{} - Hello world!".format(int(time())))
        loop.add_timer(3, print_hello)

    def f(x):
        def g():
            print(x)
        return g

    loop.add_stdin_handler(on_stdin_input)
    loop.add_timer(0, print_hello)
    loop.run_forever()


if __name__ == '__main__':
    main()
```

### 处理协程的EventLoop

在一个loop里面：

1. 检查可用的IO输入
2. 遍历`self._tasks_waiting_on_stdin`里面，执行调度，将coroutine用偏函数包装成task的形式，并将其append进`self._tasks`里面
3. `self._tasks`出队，调用。
4. 执行到点的` self._timers`里面的task

对于这个例子：

1. 创建`hello_task`与`fib_task`两个task
2. 在Loop里面，call这两个task，在`resume_task`方法里面：`hello_task`它yiled了一个`sleep_for_secodes`出来，将其重新调度；`fib_task`它yield了一个`sys.stdin`，将其放入`self._tasks_waiting_on_stdin`里面。一旦`self._selector`注册的`sys.stdin`检测到有东西，进入到for里面，`self._tasks_waiting_on_stdin`里面的全部被调度器调度；一旦时间一到`while self._timers and self._timers[0][0] < time():`满足条件，task执行并重新被调度。

在`while self._running:`语句里面，程序不断在`for key, mask in self._selector.select(0):`与`if self._tasks:`和`while self._timers and self._timers[0][0] < time():`语句之间循环，`sys.stdin`激活第二个循环，定时任务激活最后一个循环。

```py
from bisect import insort
from collections import deque
from fib import timed_fib
from functools import partial
from time import time
import selectors
import sys
import types


class sleep_for_seconds(object):
    """
    Yield an object of this type from a coroutine to have it "sleep" for the
    given number of seconds.
    """
    def __init__(self, wait_time):
        self._wait_time = wait_time


class EventLoop(object):
    """
    Implements a simplified coroutine-based event loop as a demonstration.
    Very similar to the "Trampoline" example in PEP 342, with exception
    handling taken out for simplicity, and selectors added to handle file IO
    """
    def __init__(self, *tasks):
        self._running = False
        self._selector = selectors.DefaultSelector()

        # Queue of functions scheduled to run
        self._tasks = deque(tasks)

        # (coroutine, stack) pair of tasks waiting for input from stdin
        self._tasks_waiting_on_stdin = []

        # List of (time_to_run, task) pairs, in sorted order
        self._timers = []

        # Register for polling stdin for input to read
        self._selector.register(sys.stdin, selectors.EVENT_READ)

    def resume_task(self, coroutine, value=None, stack=()):
        result = coroutine.send(value)
        if isinstance(result, types.GeneratorType):
            self.schedule(result, None, (coroutine, stack))
        elif isinstance(result, sleep_for_seconds):
            self.schedule(coroutine, None, stack, time() + result._wait_time)
        elif result is sys.stdin:
            self._tasks_waiting_on_stdin.append((coroutine, stack))
        elif stack:
            self.schedule(stack[0], result, stack[1])

    def schedule(self, coroutine, value=None, stack=(), when=None):
        """
        Schedule a coroutine task to be run, with value to be sent to it, and
        stack containing the coroutines that are waiting for the value yielded
        by this coroutine.
        """
        # Bind the parameters to a function to be scheduled as a function with
        # no parameters.
        task = partial(self.resume_task, coroutine, value, stack)
        if when:
            insort(self._timers, (when, task))
        else:
            self._tasks.append(task)

    def stop(self):
        self._running = False

    def do_on_next_tick(self, func, *args, **kwargs):
        self._tasks.appendleft(partial(func, *args, **kwargs))

    def run_forever(self):
        self._running = True
        while self._running:
            # First check for available IO input
            for key, mask in self._selector.select(0):
                line = key.fileobj.readline().strip()
                for task, stack in self._tasks_waiting_on_stdin:
                    self.schedule(task, line, stack)
                self._tasks_waiting_on_stdin.clear()

            # Next, run the next task
            if self._tasks:
                task = self._tasks.popleft()
                task()

            # Finally run time scheduled tasks
            while self._timers and self._timers[0][0] < time():
                task = self._timers[0][1]
                del self._timers[0]
                task()

        self._running = False



def print_every(message, interval):
    """
    Coroutine task to repeatedly print the message at the given interval
    (in seconds)
    """
    while True:
        print("{} - {}".format(int(time()), message))
        yield sleep_for_seconds(interval)


def read_input(loop):
    """
    Coroutine task to repeatedly read new lines of input from stdin, treat
    the input as a number n, and calculate and display fib(n).
    """
    while True:
        line = yield sys.stdin
        if line == 'exit':
            loop.do_on_next_tick(loop.stop)
            continue
        n = int(line)
        print("fib({}) = {}".format(n, timed_fib(n)))


def main():
    loop = EventLoop()
    hello_task = print_every('Hello world!', 3)
    fib_task = read_input(loop)
    loop.schedule(hello_task)
    loop.schedule(fib_task)
    loop.run_forever()


if __name__ == '__main__':
    main()
```