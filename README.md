# GitStatus

![图标][0]


如果你在维护多个使用git的项目，并且经常需要在几个项目之间切换，你可能会遇到忘记某一个repo当前在哪个branch；
或者一天工作结束后可能会忘记commit一些修改。
实际上，上面的问题是我最近工作中常遇到的，所以尝试编写这个App来解决。

它可以同时监控多个repo的状况，然后在菜单栏中提示你。
*  是否有repo的代码未提交
*  是否有repo当前分支是stable分支而不是dev分支(比如master,release)


使用：

* 运行时菜单栏会显示 `SC` `S` 代表 safe，即所有的repo都处于非stable分支; `C` 代表 clean，即所有的repo的代码都已提交。
任意一个repo 处于stable分支 `S`会显示红色，任意一个repo 处于unclean状态 `C`会显示红色。

![菜单][1]

* 点击菜单栏进入repo添加界面，这里可以添加多个repo

![添加repo][2]

* 点击repo列表右下角的分支可以进入stable分支设置页面，手动设置repo的stable分支(比如master,release等不应该长期停留的分支)

![添加stable分支][3]

  [0]: https://github.com/github-xiaogang/GitStatus/blob/master/readme/icon.png
  [1]: https://github.com/github-xiaogang/GitStatus/blob/master/readme/menubar.png
  [2]: https://github.com/github-xiaogang/GitStatus/blob/master/readme/repo.png
  [3]: https://github.com/github-xiaogang/GitStatus/blob/master/readme/stable.png
