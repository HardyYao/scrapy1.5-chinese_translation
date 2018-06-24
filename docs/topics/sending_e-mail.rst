.. _docs-topics-email:

==============
发送e-mail
==============

.. module:: scrapy.mail
   :synopsis: Email sending facility

虽然Python通过 `smtplib`_ 库使得发送邮件变得相对简单，Scrapy 仍然提供了自己的实现机制，该功能十分易用，同时由于采用了 `Twisted non-blocking IO`_，其避免了对爬虫的非阻塞式IO的影响。另外，其也提供了简单的API来发送邮件。通过一些 :ref:`settings <topics-email-settings>` 设置，你很容易就可以进行配置。

.. _smtplib: https://docs.python.org/2/library/smtplib.html
.. _Twisted non-blocking IO: https://twistedmatrix.com/documents/current/core/howto/defer-intro.html

简单例子
=============

有两种方法可以实例化邮件发送器(mail sender)。你可以使用标准构造器(standard constructor)来进行实例化::

    from scrapy.mail import MailSender
    mailer = MailSender()

或者你可以传递一个 Scrapy 设置对象来实例化，其会参考 :ref:`settings <topics-email-settings>`::

    mailer = MailSender.from_settings(settings)

以下是教你如何发送一封邮件(不包括附件)::

    mailer.send(to=["someone@example.com"], subject="Some subject", body="Some body", cc=["another@example.com"])

MailSender 类参考手册
==========================

MailSender是用于从Scrapy发送电子邮件的首选类，因为它使用了 `Twisted non-blocking IO`_，就像框架的其它部分一样。

.. class:: MailSender(smtphost=None, mailfrom=None, smtpuser=None, smtppass=None, smtpport=None)

    :param smtphost: 用于发送电子邮件的SMTP主机。如果省略，将使用 :setting:`MAIL_HOST` 设置
    :type smtphost: str

    :param mailfrom: 用于发送电子邮件的SMTP地址(在 ``From:`` 标题中)。如果省略，将使用 :setting:`MAIL_FROM` 设置
    :type mailfrom: str

    :param smtpuser: SMTP用户。如果省略，将使用 :setting:`MAIL_USER` 设置。如果没有给出，则不会执行SMTP认证。
    :type smtphost: str or bytes

    :param smtppass: SMTP通行证进行身份验证。
    :type smtppass: str or bytes

    :param smtpport: 要连接到的SMTP端口
    :type smtpport: int

    :param smtptls: 使用SMTP STARTTLS强制执行
    :type smtptls: boolean

    :param smtpssl: 使用安全的SSL连接强制执行
    :type smtpssl: boolean

    .. classmethod:: from_settings(settings)

        Instantiate using a Scrapy settings object, which will respect
        :ref:`these Scrapy settings <topics-email-settings>`.

        :param settings: 电子邮件收件人
        :type settings: :class:`scrapy.settings.Settings` object

    .. method:: send(to, subject, body, cc=None, attachs=(), mimetype='text/plain', charset=None)

        发送电子邮件给指定的收件人。

        :param to: 邮件接收者
        :type to: str or list of str

        :param subject: 邮件内容
        :type subject: str

        :param cc: 抄送的人
        :type cc: str or list of str

        :param body: 邮件的内容
        :type body: str

        :param attachs: 可迭代的元组 ``(attach_name, mimetype, file_object)``。``attach_name`` 是一个在email的附件中显示的名字的字符串， ``mimetype`` 是附件的mime类型，``file_object`` 是包含附件内容的可读的文件对象
        :type attachs: iterable

        :param mimetype: 邮件的mime类型
        :type mimetype: str

        :param charset: 用于电子邮件内容的字符编码
        :type charset: str

.. _docs-topics-email-settings:

Mail设置
=============

这些设置定义了 :class:`MailSender` 类的默认构造器值，并且可以用来在你的项目中配置电子邮件通知，而无需编写任何代码(对于那些使用 :class:`MailSender` 的扩展和代码)。

.. setting:: MAIL_FROM

MAIL_FROM
---------

默认值: ``'scrapy@localhost'``

用于发送email的地址(address)(填入``From:``标题中)。

.. setting:: MAIL_HOST

MAIL_HOST
---------

默认值: ``'localhost'``

发送邮件的SMTP主机(host)。

.. setting:: MAIL_PORT

MAIL_PORT
---------

默认值: ``25``

发用邮件的SMTP端口。

.. setting:: MAIL_USER

MAIL_USER
---------

默认值: ``None``

用户用于SMTP验证。如果禁用，则不会执行SMTP验证。

.. setting:: MAIL_PASS

MAIL_PASS
---------

默认值: ``None``

用于SMTP验证，与 :setting:`MAIL_USER` 配套的密码。

.. setting:: MAIL_TLS

MAIL_TLS
--------

默认值: ``False``

强制使用STARTTLS。STARTTLS是一种采取现有不安全连接的方式，并使用SSL/TLS将其升级到安全连接。

.. setting:: MAIL_SSL

MAIL_SSL
--------

默认值: ``False``

强制使用SSL加密连接。