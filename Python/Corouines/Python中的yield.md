# yield from

## 动机

Python生成器是协程的一种形式，但是有一个限制，它只能`yield`给它的直接调用者。这意味着包含`yiled`的一段代码不能被分解出来，并放入一个函数中。如果这样做，这样会导致调用函数变成一个生成器。

## 解决

在Python3.3中，提出了yield from这种新语法。

```py
yield from <expr>
```

其中`<expr>`是对迭代器求值的表达式。 迭代器运行到耗尽，在此期间它`yiled`和`receive`包含表达式`yield from`的生成器(delegating generator)的值。

此外，当迭代器是另一个生成器时，允许子生成器执行return语句返回值，并且该值变为yield from 表达式的值。

- 迭代器`yiled`的任何值都会直接返回给调用者。
- 使用`send()`发送给委托生成器的任何值都直接传递给迭代器。如果`send()`的值为`None`，则调用迭代器的`__next__()`方法。如果发送的值不是`None`，则调用迭代器的`send()`方法。
- 除了`GeneratorExit`异常之外，其他抛出到委托生成器的异常都是通过迭代器的`throw()`方法抛出。如果子生成器调用产生`StopIteration`异常，委托生成器会继续执行`yield from`后面的语句，而其他异常则会传播到委托生成器中。
- 如果`GeneratorExit`异常被抛出到委托生成器中，或者调用委托生成器的`close()`方法，如果委托生成器有`close()`方法的话，会被调用。如果此调用会导致异常的话，则将其传递到其委托生成器中。否则，`GeneratorExit`异常会在委托生成器中引发，并传送到子生成器中。
- `yield from`表达式的值的结果是当迭代器结束时抛出`StopIteration`的第一个参数。
- 在生成器中，`return <expr>`表达式会引发`StopIteration(<expr>)`异常，，所以子生成器中`return`的值会成为其委托生成器中`yield from`表达式的返回值。(因此你可以使用`StopIteration`来返回值)。

## StopIteration

为了方便起见，StopIteration异常将被赋予一个保存其第一个参数的值属性，如果没有参数，则为None。

## yiled from是什么

回到来，`yiled from`究竟是什么。

关于`yield from`，[PEP 380](https://www.python.org/dev/peps/pep-0380/)里面有这样一句话。

> A syntax is proposed for a generator to delegate part of its operations to another generator.  This allows a section of code containing 'yield' to be factored out and placed in another generator. Additionally, the subgenerator is allowed to return with a value, and the value is made available to the delegating generator. 

提出了一种语法，用于将生成器的部分操作委托给另一个生成器。这允许包含’yiled'的代码段被分解出来放到另一个生成器中。此外，允许子生成器(subgenerator)返回一个值，该值可以用于委托的生成器(delegating generator)。

## yield from的用法

虽然`yield from`主要设计用来向子生成器委派操作任务，但`yield from`可以向任意的迭代器委派操作；对于简单的迭代器，`yield from iterable`本质上等于`for item in iterable: yield item`的缩写版，如下所示： 

```PY
def reader():
    """A generator that fakes a read from a file, socket, etc."""
    for i in range(4):
        yield '<< %s' % i

def reader_wrapper(g):
    # Manually iterate over data produced by reader
    for v in g:
        yield v

wrap = reader_wrapper(reader())
for i in wrap:
    print(i)

# Result
<< 0
<< 1
<< 2
<< 3

# Instead of manually iterating over reader(), we can just yield from it.
def reader_wrapper(g):
    yield from g
```



假设有这样一个subgenerator

```py
class SubGeneratorException(Exception):
    pass

def SubGenerator():
    coef = 1
    total = 0
    while True:
        try:
            input_val = yield total
            total = total + coef * input_val
            print(total)
        except SubGeneratorException:
            print('* * *')
```

如果有这样一个delegating generator，它将subgenerator封装起来，提供一样的接口。由于`subgenerator()`利用了generator的若干特性，所以`outer()`也必须做到：

- delegatin\_generator()必须生成一个generator；
- 在每一步的迭代中，delegatin\_generator()要帮助inner()返回迭代值；
- 在每一步的迭代中，delegatin\_generator()要帮助inner()接收外部发送的数据；
- 在每一步的迭代中，delegatin\_generator()要处理inner()接收和抛出所有异常；
- 在outer()被close的时候，inner()也要被正确地close掉。

```py
def DelegatinGenerator():
    print("Before")
    i_gen = SubGenerator()
    input_val = None
    ret_val = i_gen.send(input_val)
    while True:
        try:
            input_val = yield ret_val
            ret_val = i_gen.send(input_val)
        except StopIteration:
            break
    print("After")

if __name__ == '__main__':
    wrap = DelegatinGenerator()
    wrap.send(None)  # "prime" the coroutine
    for i in [0, 1, 2, 4]:
        if i == 'spam':
            wrap.throw(SubGeneratorException)
        else:
            wrap.send(i)
# Result
0
1
3
7
```

刚刚那是不需要处理异常的情况，下面我们看看需要处理异常的情况。

```py
if __name__ == '__main__':
    wrap = DelegatinGenerator()
    wrap.send(None)  # "prime" the coroutine
    for i in [0, 1, 'spam', 2, 4]:
        if i == 'spam':
            wrap.throw(SubGeneratorException)
        else:
            wrap.send(i)
            
# Expected Result
0
1
3
7

# Actual Result
0
1
  File ... in <module>
    wrap.throw(SubGeneratorException)
  File ... in DelegatinGenerator
    input_val = yield ret_val
__main__.SubGeneratorException
```

这行不通，因为`input_val = yield ret_val`只是抛出异常并且使得程序奔溃。我们可以手动处理这个异常，把这个异常发送到子生成器。

```py
def DelegatinGenerator():
    i_gen = SubGenerator()
    input_val = None
    ret_val = i_gen.send(input_val)
    while True:
        try:
            input_val = yield ret_val
        except StopIteration:
            break
        except Exception as e:
            i_gen.throw(e)
        else:
            ret_val = i_gen.send(input_val)

# Result
0
1
* * *
2
4
```

当我们使用`yield from`之后

```py
def DelegatinGenerator():
    i_gen = SubGenerator()
    yield from i_gen
```
