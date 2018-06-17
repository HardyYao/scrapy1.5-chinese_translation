.. _docs-topics-logging:

=======
Logging
=======

.. note::
    :mod:`scrapy.log` 已经被弃用，并且支持显示调用 Python 标准日志。继续阅读以了解更多关于新日志系统的信息。

Scrapy 使用`Python 内置的日志系统 <https://docs.python.org/3/library/logging.html>`_ 来进行事件日志记录。我们将提供一些简单的示例来帮助您开始，但对于更高级的用例，强烈建议您仔细阅读其文档。

日志功能可以被直接调用，并且可以在一定程度上使用 Scrapy 设置进行配置 :ref:`topics-logging-settings`。

Scrapy 调用 :func:`scrapy.utils.log.configure_logging` 来设置一些合理的默认值，并在命令行运行的时候，在 :ref:`topics-logging-settings` 中处理那些设置，因此建议在运行时手动调用它，来自脚本的 Scrapy 描述如下： :ref:`run-from-script`。

.. _docs-topics-logging-levels:

Log levels
==========

Python 的内置日志记录定义了5层不同的级别，用于指示给定日志信息的严重级别。以下是各类标准，按照递减顺序排出：

1. ``logging.CRITICAL`` - 严重错误 (最严重的)
2. ``logging.ERROR`` - 一般错误
3. ``logging.WARNING`` - 警告信息
4. ``logging.INFO`` - 一般信息
5. ``logging.DEBUG`` - 调试信息 (最低严重性)

如何记录信息(log messages)
==========================

以下是如何使用 ``logging.WARNING`` 级别来记录一条信息的简单示例::

    import logging
    logging.warning("This is a warning")

发布任何属于5级标准内的日志信息都有一个快捷的方式，还有一个通用的 ``logging.log`` 方法，它将给定的级别作为参数。如果有需要，上面的示例可以被重写为::

    import logging
    logging.log(logging.WARNING, "This is a warning")

最重要的是，你可以创建一个不同的 "记录器(loggers)" 来封装信息。(举个例子，通常的做法是为每个模块创建不同的记录器(loggers))。这些记录器可以单独配置，并且允许分层结构。

前面的例子在后台使用 root 记录器，这是所有消息传播到的顶级记录器(除非另有说明)。使用 ``logging`` 帮助器只是显式获取 root 记录器的快捷方式，所以这也是上文那个示例的等价物::

    import logging
    logger = logging.getLogger()
    logger.warning("This is a warning")

你可以通过使用 ``logging.getLogger`` 函数获取其名称来使用其它记录器::

    import logging
    logger = logging.getLogger('mycustomlogger')
    logger.warning("This is a warning")

最后，你可以通过使用 ``__name__`` 变量确保为你正在使用的任意模块创建一个自定义记录器，该变量填充当前模块的路径::

    import logging
    logger = logging.getLogger(__name__)
    logger.warning("This is a warning")

.. seealso::

    Module logging, `HowTo <https://docs.python.org/2/howto/logging.html>`_
        基本记录(logging)教程

    Module logging, `Loggers <https://docs.python.org/2/library/logging.html#logger-objects>`_
        有关记录器(loggers)的更多文件

.. _docs-topics-logging-from-spiders:

在Spider中添加log(Logging from Spiders)
=======================================

Scrapy 在每个 Spider 实例中提供一个 :data:`~scrapy.spiders.Spider.logger`，可以这样访问和使用它::

    import scrapy

    class MySpider(scrapy.Spider):

        name = 'myspider'
        start_urls = ['https://scrapinghub.com']

        def parse(self, response):
            self.logger.info('Parse function called on %s', response.url)

该记录器(logger)是使用 Spider 的名字创建的，但是你可以使用任意你想要的自定义 Python记录器。举个例子::

    import logging
    import scrapy

    logger = logging.getLogger('mycustomlogger')

    class MySpider(scrapy.Spider):

        name = 'myspider'
        start_urls = ['https://scrapinghub.com']

        def parse(self, response):
            logger.info('Parse function called on %s', response.url)

.. _docs-topics-logging-configuration:

Logging 设置
=====================

记录器(loggers)本身并不管理如何显示通过它们发送的消息。对于这项任务，可以将不同的"处理程序"附加到任何记录程序实例，并将这些消息重定向到合适的目标，例如标准输出，文件，电子邮件等。

默认情况下，Scrapy 根据以下的设置为 root 记录器设置和配置处理程序。

.. _docs-topics-logging-settings:

Logging 设置
----------------

这些设置可用于配置logging(日志记录):

* :setting:`LOG_FILE`
* :setting:`LOG_ENABLED`
* :setting:`LOG_ENCODING`
* :setting:`LOG_LEVEL`
* :setting:`LOG_FORMAT`
* :setting:`LOG_DATEFORMAT`
* :setting:`LOG_STDOUT`
* :setting:`LOG_SHORT_NAMES`

第一对设置定义了日志消息的目标。如果设置 :setting:`LOG_FILE`，则通过根记录器发送的消息会被重定向到名为 :setting:`LOG_FILE` 的文件，编码为 :setting:`LOG_ENCODING`。如果未设置， :setting:`LOG_ENABLED` 为 ``True``，则日志消息会显示在标准错误上。最后，如果 :setting:`LOG_ENABLED` 为 ``False``，那么将不会有任何可见的日志输出。

:setting:`LOG_LEVEL` 确定要显示的最低严重级别，严重程度较低的消息将被过滤掉。它通过以下列出的可能级别进行排列 :ref:`topics-logging-levels`

:setting:`LOG_FORMAT` 和 :setting:`LOG_DATEFORMAT` 指定用作所有消息布局的格式化字符串。这些字符串可以包含任何在占位符，分别为 `日志记录的 logrecord 属性文档<https://docs.python.org/2/library/logging.html#logrecord-attributes>`_ 和 `datetime 的 strftime 和 strptime 指令<https://docs.python.org/2/library/datetime.html#strftime-and-strptime-behavior>`_

如果 :setting:`LOG_SHORT_NAMES` 已设置，则日志将不会显示打印日志的 scrapy 组件。它在默认情况下是未设置的，因此日志包含负责该日志输出的 scrapy 组件。

命令行选项
--------------------

有一些命令行参数可用于所有命令，你可以使用它们来重写(Overrides)有关日志记录的一些 Scrapy 设置。

* ``--logfile FILE``
    Overrides :setting:`LOG_FILE`
* ``--loglevel/-L LEVEL``
    Overrides :setting:`LOG_LEVEL`
* ``--nolog``
    Sets :setting:`LOG_ENABLED` to ``False``

.. seealso::

    Module `logging.handlers <https://docs.python.org/2/library/logging.handlers.html>`_
        有关可用处理程序的更多文档

高级定制
----------------------

由于 Scrapy 使用 stdlib 日志记录模块，因此你可以使用 stdlib 日志记录的所有功能自定义日志记录。

举个例子，假设你正在抓取返回许多 HTTP 404 和 500 响应的网站，而且你希望隐藏所有这样的消息::

    2016-12-16 22:00:06 [scrapy.spidermiddlewares.httperror] INFO: Ignoring
    response <500 http://quotes.toscrape.com/page/1-34/>: HTTP status code
    is not handled or not allowed

首先要注意的是一个记录器名称 - 它在括号中：``[scrapy.spidermiddlewares.httperror]``。如果你只是 ``[scrapy]``，那么，:setting:`LOG_SHORT_NAMES` 可能被设置为 True；将其设置为 False 并重新运行爬虫。

接下来，我们可以看到该消息具有 INFO 级别。为了隐藏它，我们应该为高于 INFO 的 ``scrapy.spidermiddlewares.httperror`` 设置日志级别；INFO 之后的下一个级别是 WARNING。它可以在 spider's ``__init__`` 方法中被完成，例如::

    import logging
    import scrapy


    class MySpider(scrapy.Spider):
        # ...
        def __init__(self, *args, **kwargs):
            logger = logging.getLogger('scrapy.spidermiddlewares.httperror')
            logger.setLevel(logging.WARNING)
            super().__init__(*args, **kwargs)

如果你再次运行这个爬虫，那么来自 ``scrapy.spidermiddlewares.httperror`` 记录器的 INFO 消息将会消息。

scrapy.utils.log module
=======================

.. module:: scrapy.utils.log
   :synopsis: Logging utils

.. autofunction:: configure_logging

    ``configure_logging`` is automatically called when using Scrapy commands,
    but needs to be called explicitly when running custom scripts. In that
    case, its usage is not required but it's recommended.
    使用 Scrapy 命令行时会自动调用 ``configure_logging``，但是在运行自定义脚本时需要显式调用 ``configure_logging``。在这种情况下，它的使用不是必须的，但是建议使用。

    如果你计划自己配置处理程序，建议你调用此函数，并传递 `install_root_handler=False`。请记住，在这种情况下，默认是不会设置任何日志输出的。

    为了让你开始手动配置日志记录的输出，你可以使用 `logging.basicConfig()`_ 来设置一个基本的根处理程序。这是个教你如何将 ``INFO`` 或更高级的消息重定向到文件的例子::

        import logging
        from scrapy.utils.log import configure_logging

        configure_logging(install_root_handler=False)
        logging.basicConfig(
            filename='log.txt',
            format='%(levelname)s: %(message)s',
            level=logging.INFO
        )

    参考 :ref:`run-from-script` 来获得更多关于如何使用 Scrapy 的细节。

.. _logging.basicConfig(): https://docs.python.org/2/library/logging.html#logging.basicConfig

