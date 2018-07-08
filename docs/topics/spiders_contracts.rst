.. _docs-topics-contracts:

=================
Spiders Contracts
=================

.. versionadded:: 0.15

.. note:: 这是一个新引入(Scrapy0.15)的特性，在后续的功能/API更新中可能会有所改变。查看 :ref:`release notes <news>` 以获得更新通知。

测试spider是一件挺烦人的事情，虽然没有什么能阻止你编写单元测试(unit test)，但任务很快就会变得很麻烦。Scrapy通过contracts的方式来提供测试spider的集成方法。

你可以通过对样例url进行硬编码(hardcoding)来测试spider中的每个回调函数，并检查回调函数如何处理响应(response)的各种约束。每个contract都以 ``@`` 为前缀，并包含在文档字符串(docstring)中，请参阅以下示例::

    def parse(self, response):
        """ This function parses a sample response. Some contracts are mingled
        with this docstring.

        @url http://www.amazon.com/s?field-keywords=selfish+gene
        @returns items 1 16
        @returns requests 0 0
        @scrapes Title Author Year Price
        """

该回调函数使用了三个内置的contract来测试:

.. module:: scrapy.contracts.default

.. class:: UrlContract

    该contract(``@url``)设置了用于检查spider的其它contract状态的样例url。该contract是必须的，所有缺失该contract的回调函数在测试时将会被忽略::

    @url url

.. class:: ReturnsContract

    该contract(``@returns``)设置了spider返回的items和requests的上限和下限。上限是可选的::

    @returns item(s)|request(s) [min [max]]

.. class:: ScrapesContract

    该contract(``@scrapes``)检查回调函数返回的所有item是否含有特定的字段(fields)::

    @scrapes field_1 field_2 ...

使用 :command:`check` 命令来运行contract检查。

自定义Contracts
================

如果你想要比内置scrapy contract更为强大的功能，可以在你的项目里创建并设置你自己的contract，并使用 :setting:`SPIDER_CONTRACTS` 设置来加载::

    SPIDER_CONTRACTS = {
        'myproject.contracts.ResponseCheck': 10,
        'myproject.contracts.ItemValidate': 10,
    }

每个contract必须继承 :class:`scrapy.contracts.Contract` 并覆盖以下三个方法:

.. module:: scrapy.contracts

.. class:: Contract(method, \*args)

    :param method: contract所关联的回调函数
    :type method: function

    :param args: list of arguments passed into the docstring (whitespace
        separated)
    :type args: list

    .. method:: Contract.adjust_request_args(args)

        接收一个 ``字典(dict)`` 作为参数。该参数包含了所有 :class:`~scrapy.http.Request` 对象参数的默认值。该方法必须返回相同或修改过的字典。

    .. method:: Contract.pre_process(response)

        该函数在样例request接收到response后，传送给回调函数前被调用，运行测试。

    .. method:: Contract.post_process(output)

        该函数处理回调函数的输出。迭代器(Iterators)在传输给该函数前会被列表化(listified)。

该样例contract在response接收时检查了是否有自定义header。在失败时抛出 :class:`scrapy.exceptions.ContractFail` 来展现错误:

    from scrapy.contracts import Contract
    from scrapy.exceptions import ContractFail

    class HasHeaderContract(Contract):
        """ Demo contract which checks the presence of a custom header
            @has_header X-CustomHeader
        """

        name = 'has_header'

        def pre_process(self, response):
            for header in self.args:
                if header not in response.headers:
                    raise ContractFail('X-CustomHeader not present')
