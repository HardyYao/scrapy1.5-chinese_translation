.. _docs-faq:

常见问题（Frequently Asked Questions，FAQ）
=========================================

.. _faq-scrapy-bs-cmp:

Scrapy相比起BeautifulSoup或lxml，如何呢?
-------------------------------------------------

`BeautifulSoup`_ 和 `lxml`_ 是用于解析HTML和XML的库。Scrapy则是一个编写网络爬虫，爬取网页并获取数据的应用框架(application framework)。

Scrapy提供了内置的机制来提取数据(叫做 :ref:`选择器 <topics-selectors>`)。但是如果你觉得使用 `BeautifulSoup`_(或 `lxml`_) 更为方便，你也可以使用它们。毕竟，它们仅仅是分析库，可以在任何Python代码中被导入及使用。

换句话说，拿Scrapy和`BeautifulSoup`_ (或 `lxml`_) 比较就像是拿`jinja2`_和`Django`_相比。

.. _BeautifulSoup: https://www.crummy.com/software/BeautifulSoup/
.. _lxml: http://lxml.de/
.. _jinja2: http://jinja.pocoo.org/
.. _Django: https://www.djangoproject.com/

我可以在BeautifulSoup上使用Scrapy吗？
------------------------------------

当然，你可以。
如上所述，:ref:`above <faq-scrapy-bs-cmp>`，`BeautifulSoup`_可用于解析Scrapy回调中的HTML响应。你只需要将响应的正文反馈到``BeautifulSoup``对象，并从中提取所需要的任何数据。

以下是一个使用BeautifulSoup API的爬虫示例，使用``lxml``作为HTML解析器::


    from bs4 import BeautifulSoup
    import scrapy


    class ExampleSpider(scrapy.Spider):
        name = "example"
        allowed_domains = ["example.com"]
        start_urls = (
            'http://www.example.com/',
        )

        def parse(self, response):
            # use lxml to get decent HTML parsing speed
            soup = BeautifulSoup(response.text, 'lxml')
            yield {
                "url": response.url,
                "title": soup.h1.string
            }

.. note::

    ``BeautifulSoup`` 支持几种HTML/XML解析器。
    请参阅 `BeautifulSoup's official documentation`_，看看哪些是可用的。

.. _BeautifulSoup's 官方文档: https://www.crummy.com/software/BeautifulSoup/bs4/doc/#specifying-the-parser-to-use

.. _faq-python-versions:

Scrapy支持哪些Python版本？
--------------------------

在CPython（默认Python实现）和PyPy（从PyPy 5.9开始）下，Scrapy支持Python 2.7和Python 3.4以上的版本。Python 2.6的支持从Scrapy 0.20开始被删除了。Scrapy 1.1中添加了Python 3支持。Scrapy 1.4中添加了PyPy支持，在Scrapy 1.5中添加了PyPy3支持。

.. note::
    对于Windows上的Python 3支持，建议使用Anaconda/Miniconda作为:ref:`outlined in the installation guide <intro-install-windows>`。

Scrapy是否从Django中”剽窃”了X呢？
---------------------------------

也许吧，不过我们不喜欢这个词。我们认为 Django_ 是一个很好的开源项目，同时也是一个很好的参考对象，所以我们把其作为Scrapy的启发对象。

我们坚信，如果有些事情已经做得很好了，那就没必要再重复制造轮子。这个想法，作为开源项目及免费软件的基石之一，不仅仅针对软件，也包括文档，过程，政策等等。所以，与其自行解决每个问题，我们选择从其他已经很好地解决问题的项目中复制想法(copy idea) ，并把注意力放在真正需要解决的问题上。

如果Scrapy能启发其他的项目，我们将为此而自豪。欢迎来抄(steal)我们！

Scrapy支持HTTP代理吗?
-----------------------

是的。(从Scrapy 0.8开始)通过HTTP代理下载中间件对HTTP代理提供了支持。参考 :class:`~scrapy.downloadermiddlewares.httpproxy.HttpProxyMiddleware`。

如何爬取属性在不同页面的item呢？
---------------------------------

参考 :ref:`topics-request-response-ref-request-callback-arguments`.

Scrapy退出，ImportError: Nomodule named win32api
----------------------------------------------------------

这是个`this Twisted bug`_，你需要安装`pywin32`_ because of.

.. _pywin32: https://sourceforge.net/projects/pywin32/
.. _this Twisted bug: https://twistedmatrix.com/trac/ticket/3707

我要如何在spider里模拟用户登录呢？
-----------------------------------

参考 :ref:`topics-request-response-ref-request-userlogin`.

.. _faq-bfo-dfo:

Scrapy是以广度优先还是深度优先进行爬取的呢？
------------------------------------------

默认情况下，Scrapy使用`LIFO`_队列来存储等待的请求。简单来说，就是`深度优先顺序`_。深度优先对大多数情况下是更为方便的。如果你想以`广度优先顺序`_进行爬取，你可以设置以下的设定::

    DEPTH_PRIORITY = 1
    SCHEDULER_DISK_QUEUE = 'scrapy.squeues.PickleFifoDiskQueue'
    SCHEDULER_MEMORY_QUEUE = 'scrapy.squeues.FifoMemoryQueue'

我的Scrapy爬虫有内存泄露，怎么办?
---------------------------------

参考 :ref:`topics-leaks`.

另外，Python自己也有内存泄漏，在:ref:`topics-leaks-without-leaks`中有所描述。

我该如何让Scrapy减少内存消耗？
---------------------------------

参考上一个问题。

我能在spider中使用基本HTTP认证么？
-----------------------------------------

可以, 参考 :class:`~scrapy.downloadermiddlewares.httpauth.HttpAuthMiddleware`.

为什么Scrapy下载了英文的页面，而不是我的本国语言？
------------------------------------------------------

尝试通过覆盖 :setting:`DEFAULT_REQUEST_HEADERS` 设置来修改默认的 `Accept-Language`_ 请求头。

.. _Accept-Language: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4

我能在哪里找到Scrapy项目的例子？
------------------------------------------

参考 :ref:`intro-examples`.

我能在不创建Scrapy项目的情况下运行一个爬虫(spider)么？
-----------------------------------------------------

是的。你可以使用 :command:`runspider` 命令。例如，你有个spider写在``my_spider.py``文件中，你可以运行::

    scrapy runspider my_spider.py

详情请参考 :command:`runspider` 命令。

我收到了 ``Filtered offsite reques`` 消息。如何修复？
-----------------------------------------------------

这些消息(以 ``DEBUG`` 所记录)并不意味着有问题，所以你可以不修复它们。

这些消息由Offsite Spider中间件（Middleware）所抛出。该（默认启用的）中间件筛选出了不属于当前spider的站点请求。

更多详情请参见: :class:`~scrapy.spidermiddlewares.offsite.OffsiteMiddleware`.

发布Scrapy爬虫到生产环境的推荐方式是什么？
---------------------------------------------

参考 :ref:`topics-deploy`.

我能对大数据(large exports)使用JSON么？
-----------------------------------------

这取决于你的数据有多大。参考 :class:`~scrapy.exporters.JsonItemExporter` 文档中的 :ref:`this warning <json-with-large-data>`。

我能在信号处理器(signal handler)中返回(Twisted)引用么？
------------------------------------------------------
有些信号支持从处理器中返回引用，有些不行。参考 :ref:`topics-signals-ref` 来了解详情。

reponse返回的状态值999代表了什么?
------------------------------------

999是雅虎用来控制请求量所定义的返回值。试着减慢爬取速度，将spider的下载延迟改为``2``或更高::

    class MySpider(CrawlSpider):

        name = 'myspider'

        download_delay = 2

        # [ ... rest of the spider code ... ]

或者在:setting:`DOWNLOAD_DELAY`中设置项目的全局下载延迟。

我能在spider中调用 ``pdb.set_trace()`` 来调试么？
------------------------------------------------

可以，但你也可以使用Scrapy终端。这能让你快速分析(甚至修改)spider处理返回的响应(response)。通常来说，比老旧的``pdb.set_trace()``有用多了。

更多详情请参考 :ref:`topics-shell-inspect-response`.

将所有爬取到的item转存(dump)到 ``JSON/CSV/XML`` 文件的最简单的方法？
-------------------------------------------------------------------

dump到JSON文件::

    scrapy crawl myspider -o items.json

dump到CSV文件::

    scrapy crawl myspider -o items.csv

dump到XML文件::

    scrapy crawl myspider -o items.xml

更多详情请参考 :ref:`topics-feed-exports`

在某些表单中巨大神秘的 ``__VIEWSTATE`` 参数是什么？
--------------------------------------------------


``__VIEWSTATE`` 参数存在于ASP.NET/VB.NET建立的站点中。关于这个参数的作用请参考 `this page`_。这里有一个爬取这种站点的 `example spider`_
which scrapes one of these sites.

.. _this page: http://search.cpan.org/~ecarroll/HTML-TreeBuilderX-ASP_NET-0.09/lib/HTML/TreeBuilderX/ASP_NET.pm
.. _example spider: https://github.com/AmbientLighter/rpn-fas/blob/master/fas/spiders/rnp.py

分析大 XML/CSV 数据源的最好方法是?
-----------------------------------

使用XPath选择器来分析大数据源可能会有问题。选择器需要在内存中对数据建立完整的DOM树，这个过程速度很慢且消耗大量内存。

为了避免一次性读取整个数据源，您可以使用 ``scrapy.utils.iterators`` 中的 ``xmliter`` 和 ``csviter`` 方法。实际上，这也是feed spiders（参考 :ref:`topics-spiders`）中的处理方法。

Scrapy自动管理cookies么？
----------------------------

是的，Scrapy接收并保持服务器返回来的cookies，在之后的请求会发送回去，就像正常的网页浏览器做的那样。

更多详情请参考 :ref:`topics-request-response` 和 :ref:`cookies-mw`.

如何才能看到Scrapy发出及接收到的cookies呢？
--------------------------------------------

启用 :setting:`COOKIES_DEBUG` 选项。

要怎么停止爬虫呢?
--------------------

Raise the :exc:`~scrapy.exceptions.CloseSpider` exception from a callback. For
more info see: :exc:`~scrapy.exceptions.CloseSpider`.

如何避免我的Scrapy机器人(bot)被禁止(ban)呢？
---------------------------------------------

参考 :ref:`bans`.

我应该使用spider参数(arguments)还是设置(settings)来配置spider呢？
-----------------------------------------------------------------

:ref:`spider 参数 <spiderargs>` 及 :ref:`设置 <topics-settings>` 都可以用来配置你的spider。没有什么强制的规则来限定要使用哪个，但设置(settings)更适合那些一旦设置就不怎么会修改的参数，而spider参数则意味着修改更为频繁，在每次spider运行都有修改，甚至是spider运行所必须的元素 (例如，设置spider的起始url)。

这里以例子来说明这个问题。假设你有一个spider需要登录某个网站来 爬取数据，并且仅仅想爬取特定网站的特定部分(每次都不一定相同)。在这个情况下，认证的信息将写在设置中，而爬取的特定部分的url将是spider参数。

我爬取了一个XML文档但是XPath选择器不返回任何的item
----------------------------------------------------

也许您需要移除命名空间(namespace)。参考 :ref:`removing-namespaces`.

.. _user agents: https://en.wikipedia.org/wiki/User_agent
.. _LIFO: https://en.wikipedia.org/wiki/Stack_(abstract_data_type)
.. _DFO order: https://en.wikipedia.org/wiki/Depth-first_search
.. _BFO order: https://en.wikipedia.org/wiki/Breadth-first_search