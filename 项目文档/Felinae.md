# Felinae

# 原理简析

Felinae由`downloader`，`parser`和`resulter`三部分组成。它们之间的使用队列传递消息。`downloader`从队列中获取一个任务，请求成功之后将任务发送给`parser`解析，解析成功之后再将任务发送给`resulter`保存。

# 快速入门

## 编写脚本

一个典型的爬虫脚本如下

```python
from queue import Queue, PriorityQueue
from bs4 import BeautifulSoup

from felinae import Task, Crawler

def parser_list(task):
    new_tasks = []
    response = task['response']
    soup = BeautifulSoup(response.text, 'lxml')

    for each_soup in soup.select('a[href^="http"]'):
        url = each_soup.href

        new_task = Task.make_task({
            'url': url,
            'method': 'GET',
            'parser': parser_content,
            'resulter': resulter_content,
            'priority': task['priority'] + 1,
        })
        new_tasks.append(new_task)
    return None, new_tasks


def parser_content(task):
    return task, None


def resulter_content(task):
    # 保存在数据库
    pass


if __name__ == '__main__':
    PARSER_WORKER = 1
    DOWNLOADER_WORKER = 1
    RESULTER_WORKER = 1

    iq = PriorityQueue()
    oq = PriorityQueue()
    result_q = Queue()
    crawler = Crawler(iq, oq, result_q, PARSER_WORKER, DOWNLOADER_WORKER, RESULTER_WORKER)

    iq.put(Task.make_task({
        'url': 'http://scrapy.org/',
        'method': 'GET',
        'parser': parser_list,
        'priority': 0,
    }))
    
    crawler.start()
```

**脚本分析**：

* 先从`main`开始。实例化`Crawler`需要三个队列，以及启动`parser`，`downloader`，`resulter`的数量。
* 第43行。调用`Task.make_task`制作一个任务（task），并将其放入队列里面。这个任务指明了其解析函数为`parser_list`，即指定了这个任务的解析器回调函数为`parser_list`，也就是说，当请求成功之后，将会调用这个函数。我们可以在这个解析函数里面解析出结构化数据。
* 在`parser_list`里面，我们解析出所有有效的链接，然后生成新的任务。在`parser_content`里面，我们未做任何处理，仅仅返回task。
* 每个解析函数需要返回两个变量，第一个变量是一个要发送给`resulter`的任务，如例子中的`parser_content`，它将一个任务发送给`resulter_content`；第二个变量是新生成的任务，可以是一个任务也可以是任务构成的列表。

# 任务（Task）

在Felinae里面最基本的一个单元。

