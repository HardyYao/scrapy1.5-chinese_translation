.. _docs-topics-telnetconsole:

==========================
远程登录终端(Telnet Console)
==========================

.. module:: scrapy.extensions.telnet
   :synopsis: The Telnet Console

Scrapy提供了内置的远程登录终端(Telnet Console)，以供检查和控制Scrapy运行的进程。telnet仅仅是一个运行在Scrapy进程中的普通python终端。因此你可以在其中做任何事。

telnet终端是一个自带的 :ref:`自带的Scrapy扩展 <topics-extensions-ref>`，该扩展默认是启用的，不过你也可以禁用它。关于扩展的更多信息请参考 :ref:`topics-extensions-ref-telnetconsole`。

.. highlight:: none

如何访问telnet终端
==================

telnet终端监听设置 :setting:`TELNETCONSOLE_PORT` 中定义的TCP端口，默认为 ``6023``，访问telnet请输入::

    telnet localhost 6023
    >>>

Windows及大多数Linux发行版都自带了所需的telnet程序。

telnet终端中可用的变量
=======================

telnet终端就像是一个运行在Scrapy进程中的普通python终端。因此你可以在其中做任何事，包括导入新模块，等等。

telnet终端为了方便提供了一些默认定义的变量:

+----------------+-------------------------------------------------------------------+
| 快捷名称        |   描述                                                            |
+================+===================================================================+
| ``crawler``    | the Scrapy Crawler (:class:`scrapy.crawler.Crawler` object)       |
+----------------+-------------------------------------------------------------------+
| ``engine``     | Crawler.engine 属性                                               |
+----------------+-------------------------------------------------------------------+
| ``spider``     | 当前激活的爬虫(spider)                                             |
+----------------+-------------------------------------------------------------------+
| ``slot``       | the engine slot                                                   |
+----------------+-------------------------------------------------------------------+
| ``extensions`` | 扩展管理器(manager) (Crawler.extensions属性)                       |
+----------------+-------------------------------------------------------------------+
| ``stats``      | 数据收集器 (Crawler.stats属性)                                     |
+----------------+-------------------------------------------------------------------+
| ``settings``   | Scrapy设置(setting)对象 (Crawler.settings属性)                     |
+----------------+-------------------------------------------------------------------+
| ``est``        | 打印引擎状态的报告                                                 |
+----------------+-------------------------------------------------------------------+
| ``prefs``      | 针对内存调试 (参考 :ref:`topics-leaks`)                            |
+----------------+-------------------------------------------------------------------+
| ``p``          | `pprint.pprint`_ 函数的简写                                        |
+----------------+-------------------------------------------------------------------+
| ``hpy``        | 针对内存调试 (参考 :ref:`topics-leaks`)                            |
+----------------+-------------------------------------------------------------------+

.. _pprint.pprint: https://docs.python.org/library/pprint.html#pprint.pprint

Telnet console usage examples
=============================

下面是使用telnet终端的一些例子:

查看引擎状态
----------------

在终端中你可以使用Scrapy引擎的 ``est()`` 方法来快速查看状态::

    telnet localhost 6023
    >>> est()
    Execution engine status

    time()-engine.start_time                        : 8.62972998619
    engine.has_capacity()                           : False
    len(engine.downloader.active)                   : 16
    engine.scraper.is_idle()                        : False
    engine.spider.name                              : followall
    engine.spider_is_idle(engine.spider)            : False
    engine.slot.closing                             : False
    len(engine.slot.inprogress)                     : 16
    len(engine.slot.scheduler.dqs or [])            : 0
    len(engine.slot.scheduler.mqs)                  : 92
    len(engine.scraper.slot.queue)                  : 0
    len(engine.scraper.slot.active)                 : 0
    engine.scraper.slot.active_size                 : 0
    engine.scraper.slot.itemproc_size               : 0
    engine.scraper.slot.needs_backout()             : False


暂停，恢复和停止Scrapy引擎
--------------------------

暂停::

    telnet localhost 6023
    >>> engine.pause()
    >>>

恢复::

    telnet localhost 6023
    >>> engine.unpause()
    >>>

停止::

    telnet localhost 6023
    >>> engine.stop()
    Connection closed by foreign host.

Telnet终端信号
================

.. signal:: update_telnet_vars
.. function:: update_telnet_vars(telnet_vars)

    在telnet终端开启前发送该信号。你可以挂载(hook up)该信号来添加，移除或更新telnet本地命名空间可用的变量。你可以通过在你的处理函数(handler)中更新 ``telnet_vars`` 字典来实现该修改。

    :param telnet_vars: telnet变量的字典
    :type telnet_vars: dict

Telnet设定
===============

以下是telnet终端的一些设定:

.. setting:: TELNETCONSOLE_PORT

TELNETCONSOLE_PORT
------------------

默认: ``[6023, 6073]``

telnet终端使用的端口范围。如果设为 ``None`` 或 ``0``， 则动态分配端口。


.. setting:: TELNETCONSOLE_HOST

TELNETCONSOLE_HOST
------------------

默认: ``'127.0.0.1'``

telnet终端监听的接口(interface)。
