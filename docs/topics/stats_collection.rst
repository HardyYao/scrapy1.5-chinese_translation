.. _docs-topics-stats:

==========================
数据收集(Stats Collection)
==========================

Scrapy 提供了方便的收集数据的机制。数据以 key/values 方式存储，值大多是计数值。该机制叫做数据收集器(Stats Collector)，可以通过 :ref:`topics-api-crawler` 的属性 :attr:`~scrapy.crawler.Crawler.stats` 来使用。在下面的章节 :ref:`topics-stats-usecases` 将给出例子来说明。

然而，无论数据收集(stats collection)开启或者关闭，数据收集器永远都是可用的。所以你可以将它导入你的模块并使用其API(增加值或设置新的统计键(stat keys))。如果它被禁用了，API 依然会工作，但是不会收集任何东西。该做法是为了简化数据收集的方法：你不应该使用超过一行代码来收集你的 spider，Scrapy 扩展或任何你使用数据收集器代码里头的数据。

数据收集器(Stats Collector)的另一个特性是(在启用状态下)很高效，(在关闭状态下)极度高效(几乎无法被注意到)。

数据收集器(Stats Collector)对每个spider都保持一个数据表。当spider启动时，该表自动打开，当 spider 关闭时，自动关闭。

.. _topics-stats-usecases:

常见数据收集器使用方法
===========================

通过 :attr:`~scrapy.crawler.Crawler.stats` 来使用数据收集器。下面是在扩展中使用数据(stats)的例子。

    class ExtensionThatAccessStats(object):

        def __init__(self, stats):
            self.stats = stats

        @classmethod
        def from_crawler(cls, crawler):
            return cls(crawler.stats)

设置数据值::

    stats.set_value('hostname', socket.gethostname())

增加数据值::

    stats.inc_value('custom_count')

当新的值比原来的值大时设置数据::

    stats.max_value('max_items_scraped', value)

当新的值比原来的值小时设置数据::

    stats.min_value('min_free_memory_percent', value)

获取数据::

    >>> stats.get_value('custom_count')
    1

获取所有数据::

    >>> stats.get_stats()
    {'custom_count': 1, 'start_time': datetime.datetime(2009, 7, 14, 21, 47, 28, 977139)}

可用的数据收集器
==========================

除了基本的 :class:`StatsCollector`，Scrapy 也提供了基于 :class:`StatsCollector` 的数据收集器。你可以通过 :setting:`STATS_CLASS` 设置来选择。默认使用的是 :class:`MemoryStatsCollector`。

.. module:: scrapy.statscollectors
   :synopsis: Stats Collectors

MemoryStatsCollector
--------------------

.. class:: MemoryStatsCollector

    一个简单的数据收集器。其在 spider 运行完毕后将其数据保存在内存中。数据可以通过 :attr:`spider_stats` 属性访问。该属性是一个以 spider 名字为键(key)的字典。

    这是Scrapy的默认选择。

    .. attribute:: spider_stats

       保存了每个 spider 最近一次爬取的数据的字典(dict)。该字典以spider名字为键，值也是字典。

DummyStatsCollector
-------------------

.. class:: DummyStatsCollector

    该数据收集器并不做任何事情但非常高效(因为什么都不做)。 您可以通过设置 STATS_CLASS 启用这个收集器，来关闭数据收集，提高效率。不过，数据收集的性能负担相较于Scrapy其他的处理(例如分析页面)来说是非常小的。
