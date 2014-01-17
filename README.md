##JLOSChina-iPhone
为开源中国重做一个新的客户端，目标易维护，结构简单，KISS！希望年前能及时发布，作为给各位OSCers的马年礼物 :)

目前应该会有很多潜在的bug，功能还有些待完善，欢迎各位试用，反馈bug！

**热烈欢迎fork&pull request，由于api接口还是较多，所以感兴趣的同学可以一起加入构建和完善。**

## 开发环境
XCode5 iOS7.x & iOS6.x

## 越狱手机测试
![](http://api.qrserver.com/v1/create-qr-code/?size=120x120&data=http%3A%2F%2Ffirapp.duapp.com%2FIa0)

扫描二维码，直接在线安装，仅支持越狱手机，非越狱手机请参考下面选择下载完整项目编译或fork后配置依赖库再安装
fir发布的安装地址：http://firapp.duapp.com/Ia0
感谢[@TraWor](http://www.weibo.com/p/1005051642587442)提供这么方便的在线安装工具

## 编译安装
1、下载附件[beta测试版本](http://git.oschina.net/jimneylee/JLOSChina-iPhone/attach_files)，直接编译即可安装。

2、fork后clone到本地，手工添加依赖库安装方法
* 1、submodule更新

``` bash
$ git submodule init 
$ git submodule update
```
注：`git submodule update`无法更新依赖库时，请按如下重新添加：
``` bash
$ git submodule add https://github.com/jimneylee/JLNimbusTimeline.git vendor/JLNimbusTimeline
```
* 2、[CocoaPods](http://cocoapods.org)更新

``` bash   
$ pod install
```   
注：如需要添加其他依赖库，请修改Podfile

* 3、替换pod添加的依赖库
   用工程`vendor`目录下的`Nimbus_fixbug`和`JSONKit_fixerror`中的文件，替换pod添加的对应文件。
   `Nimbus_fixbug`是为了解决帖子列表高亮名字或链接无法点击。
   `JSONKit_fixerror`为了解决编译引起的错误和警告。

>其实这个JSONKit是无用的，但是由于JSONKit是Nimbus的submodule递归依赖引入，所以在Nimbus没有发布新的版本，暂时只能这样处理。之前考虑过'git submodule add'依赖nimbus，去掉这个JSONKit库，但是会是工程膨胀，得不偿失。
>有问题，请添加到issue中！

4、通过'JLRubyChina.xcworkspace'打开项目，也可以[自定义xopen命令](http://jimneylee.github.io/2014/01/09/add-xopen-command-to-open-xcode-workspace/)便捷打开

![image](https://github.com/jimneylee/JLRubyChina-iPhone/raw/master/Resource/Screenshots/ErrorResolve/open_xcworkspace.jpg)

# ERROR解决方法参考
[JLRubyChina-iPhone](https://github.com/jimneylee/JLRubyChina-iPhone)

####BUG
1、新闻详细会无法下滑的问题

####TODO
~~1、回复他人的评论~~

2、我的主页显示

3、发送失败保存草稿箱

####DONE
1、登录功能和自动登录功能

2、综合资讯中最新资讯、最新博客和推荐博客列表显示

3、社区问答中问答互动、技术分享、灌水综合、职业规划、站务反馈列表显示

4、支持资讯、博客、社区帖子的评论列表查看和回复功能

5、社区动弹中最新动弹、热门动弹、我的动弹列表显示

6、发布动弹，支持拍照、@好友、表情选择功能，异步发帖功能

7、动弹的回复列表查看和回复功能

8、回复他人的评论

## LICENSE
本项目基于MIT协议发布
MIT: [http://rem.mit-license.org](http://rem.mit-license.org)

# Screenshots
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_1.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_2.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_3.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_4.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_5.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_6.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_7.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_8.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_9.png)
