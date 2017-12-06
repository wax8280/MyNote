### 协程
```PY
async def read_data(db):
    pass
```

- async def函数必定是协程，即使里面不含有await语句。
- 如果在async函数里面使用yield或yield from语句，会引发SyntaxError异常。
- 调用一个普通生成器，返回一个生成器对象（generator object）；相应的，调用一个协程返回一个协程对象（coroutine object）。
- 协程不再抛出StopIteration异常，因为抛出的StopIteration异常会被包装（wrap）成一个RuntimeError异常。（在Python 3.5，对于普通生成器要想这样需要进行future import，见PEP 479）。
- 如果一个协程从未await等待就被垃圾收集器销毁了，会引发一个RuntimeWarning异常（见“调试特性”）。

## types.coroutine()

types模块添加了一个新函数coroutine(fn)，使用它，“生成器实现的协程”和“原生协程”之间可以进行互操作。 这是个装饰器，能把现有代码的“用生成器实现的协程”转化为与“原生协程”兼容的形式。

```py
@types.coroutine
def process_data(db):
    data = yield from read_data(db)
    ...
```

## await表达式

新的await表达式用于获得协程执行的结果：

 await和yield from类似，它挂起read_data的执行，直到db.fetch执行完毕并返回结果。


