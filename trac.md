1、创建trac项目目录
    $ mkdir -p /var/trac/projects
    $ trac-admin /var/trac/projects/zgol initenv
 按照提示填入项目名称和数据库连接字符串
请输入您项目的名称。
此名称将在页面标题和描述中使用。
项目名称

请指定所用数据库的连接字符串。缺省情况下，
将在环境目录中创建一个本地SQLite数据库。
也可以使用一个已存在的PostgreSQL数据库
(具体的连接字符串语法请查看Trac文档)。
数据库连接字符串 [sqlite:db/trac.db]> mysql://tracuser:password@localhost/trac

2、启动Trac 

   tracd --port 8000 /home/ybq-2/www/trac/projects/note

3、trac用户管理和身份验证 

下面介绍如何为项目设置用户、分配密码和权限。
1. 创建用户，分配权限
 首先启动trac项目：

    $ tracd --port 8000 /home/wang/Documents/trac/first-trac

 用trac-admin命令
先看一下命令说明：

    wang@wang-Lenovo-B460:~$ trac-admin
    trac-admin - Trac管理控制台 0.13dev-r10602

    用法: trac-admin </path/to/projenv> [command [subcommand] [option ...]]

    不带命令调用trac-admin将启动交互模式。

    help Show documentation
    initenv Create and initialize a new environment

先进入交互模式：

    wang@wang-Lenovo-B460:~$ trac-admin /home/wang/Documents/trac/first-trac

    Welcome to trac-admin 0.13dev-r10602
    Interactive Trac administration console.
    Copyright (C) 2003-2011 Edgewall Software

    Type: '?' or 'help' for help on commands.

    Trac [/home/wang/Documents/trac/first-trac]>

输入help可以看到其中有：

    permission    add Add a new permission rule

这样一个命令，我们用的就是他，看下他的用法

    Trac [/home/wang/Documents/trac/first-trac]> help permission
    permission add <user> <action> [action] [...]

        Add a new permission rule

    permission list [user]

        List permission rules

    permission remove <user> <action> [action] [...]

        Remove a permission rule
    Trac [/home/wang/Documents/trac/first-trac]>

有permission list查看当前的用户和动作：
Trac [/home/wang/Documents/trac/first-trac]> permission list

用户             动作            
------------------------------
anonymous      BROWSER_VIEW  
anonymous      CHANGESET_VIEW
anonymous      FILE_VIEW     
anonymous      LOG_VIEW      
anonymous      MILESTONE_VIEW
anonymous      REPORT_SQL_VIEW
anonymous      REPORT_VIEW   
anonymous      ROADMAP_VIEW  
anonymous      SEARCH_VIEW   
anonymous      TICKET_VIEW   
anonymous      TIMELINE_VIEW 
anonymous      WIKI_VIEW     
authenticated  TICKET_CREATE 
authenticated  TICKET_MODIFY 
authenticated  WIKI_CREATE   
authenticated  WIKI_MODIFY   


可选动作:
 BROWSER_VIEW, CHANGESET_VIEW, CONFIG_VIEW, EMAIL_VIEW, FILE_VIEW,
 LOG_VIEW, MILESTONE_ADMIN, MILESTONE_CREATE, MILESTONE_DELETE,
 MILESTONE_MODIFY, MILESTONE_VIEW, PERMISSION_ADMIN, PERMISSION_GRANT,
 PERMISSION_REVOKE, REPORT_ADMIN, REPORT_CREATE, REPORT_DELETE,
 REPORT_MODIFY, REPORT_SQL_VIEW, REPORT_VIEW, ROADMAP_ADMIN, ROADMAP_VIEW,
 SEARCH_VIEW, TICKET_ADMIN, TICKET_APPEND, TICKET_CHGPROP, TICKET_CREATE,
 TICKET_EDIT_CC, TICKET_EDIT_COMMENT, TICKET_EDIT_DESCRIPTION,
 TICKET_MODIFY, TICKET_VIEW, TIMELINE_VIEW, TRAC_ADMIN,
 VERSIONCONTROL_ADMIN, WIKI_ADMIN, WIKI_CREATE, WIKI_DELETE, WIKI_MODIFY,
 WIKI_RENAME, WIKI_VIEW


可以看到匿名用户的权限，当然可应用 permission remove 来移除某些权限。

现在创建一个管理员用户，赋予他trac_admin的权限：

    Trac [/home/wang/Documents/trac/first-trac]> permission add admin TRAC_ADMIN


2. 现在创建密码
tracd 支持Basic和Digest两种身份验证方式，默认使用Digest，这种方式来源与Apache的用户管理和身份验证。
Digest方式需要一个特定格式的密码文件，可以用Apache的htdigest命令来生成密码文件。
使用htpasswd命令：

    wang@wang-Lenovo-B460:~/Documents/trac/first-trac/passwd$ htpasswd -c ./trac.htpasswd admin
    New password:
    Re-type new password:
    Adding password for user admin

这样就在目录下生成了一个密码文件。看下文件内容：

    $ cat trac.htpasswd
    admin:35ttomzPLkie6

继续为用户wang创建密码，因为用同一个密码文件，命令中的 -c 选项就不要了：

    wang@wang-Lenovo-B460:~/Documents/trac/first-trac/passwd$ htpasswd ./trac.htpasswd wang
    New password:
    Re-type new password:
    Adding password for user wang

继续为用户root创建密码，因为用同一个密码文件，命令中的 -c 选项就不要了：

    [root@localhost AJS]# htpasswd -c ./trac.htpasswd root
    New password:
    Re-type new password:
    Adding password for user root

3. 下面用呆验证的方式来启动trac
命令不懂，先看trac的帮助：

    wang@wang-Lenovo-B460:~$ tracd --port 8000 /home/wang/Documents/trac/first-trac --help
    Usage: tracd [options] [projenv] ...

    Options:
      --version             show program's version number and exit
      -h, --help            show this help message and exit
      -a DIGESTAUTH, --auth=DIGESTAUTH
                            [projectdir],[htdigest_file],[realm]
      --basic-auth=BASICAUTH
                            [projectdir],[htpasswd_file],[realm]
      -p PORT, --port=PORT  the port number to bind to
      -b HOSTNAME, --hostname=HOSTNAME
                            the host name or IP address to bind to
      --protocol=PROTOCOL   http|scgi|ajp|fcgi
      -q, --unquote         unquote PATH_INFO (may be needed when using ajp)
      --http10              use HTTP/1.0 protocol version instead of HTTP/1.1
      --http11              use HTTP/1.1 protocol version (default)
      -e PARENTDIR, --env-parent-dir=PARENTDIR
                            parent directory of the project environments
      --base-path=BASE_PATH
                            the initial portion of the request URL's "path"
      -r, --auto-reload     restart automatically when sources are modified
      -s, --single-env      only serve a single project without the project list
      -d, --daemonize       run in the background as a daemon
      --pidfile=PIDFILE     when daemonizing, file to which to write pid
      --umask=MASK          when daemonizing, file mode creation mask to use, in
                            octal notation (default 022)
      --group=GROUP         the group to run as
      --user=USER           the user to run as
    wang@wang-Lenovo-B460:~$

使用 --basic-auth 参数，启动服务器

    wang@wang-Lenovo-B460:~$ tracd --port 8000 --basic-auth="*,/home/wang/Documents/trac/first-trac/passwd/trac.htpasswd," /home/wang/Documents/trac/first-trac
    Server starting in PID 12060.
    Serving on 0.0.0.0:8000 view at http://127.0.0.1:8000/
    Using HTTP/1.1 protocol version
    127.0.0.1 - - [26/Feb/2011 13:00:49] "GET /first-trac/wiki HTTP/1.1" 200 -
    127.0.0.1 - - [26/Feb/2011 13:00:49] "GET /first-trac/chrome/site/your_project_logo.png HTTP/1.1" 404 -
    127.0.0.1 - - [26/Feb/2011 13:00:51] "GET /first-trac/login HTTP/1.1" 401 -
    127.0.0.1 - - [26/Feb/2011 13:00:56] "GET /first-trac/login HTTP/1.1" 302 -
    127.0.0.1 - - [26/Feb/2011 13:00:56] "GET /first-trac/wiki HTTP/1.1" 200 -
    127.0.0.1 - - [26/Feb/2011 13:00:56] "GET /first-trac/chrome/site/your_project_logo.png HTTP/1.1" 404 -

好了，现在访问trac，点击login，输入刚才设置的用户名密码，
登录成功，以后就可以用webadmin插件来管理了。
