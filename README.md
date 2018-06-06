# Sagit
IOS Develop Framework（Sagittarius 射手座：IOS下的一套基础快速开发框架）

入门教程：http://www.cnblogs.com/cyq1162/category/1130357.html

IOS Sagit框架 ：QQ群：702724292

<hr />

<h1>一：创造Sagit开发框架的起因：</h1>
<p>记得IT连创业刚进行时，招了个IOS的女生做开发，然后：</p>
<p>----------女生的事故就此开始了-----------</p>
<p>1：面试时候：有作品，态度也不错，感觉应该能做点事。</p>
<p>2：刚招进来：发现每天都在看文章，但迟迟不见有点东西。</p>
<p>3：过程问答：现在在整些什么？回答在搭框架。</p>
<p>4：发现危机：不小心看到她用单手指敲键盘，感觉不妙。</p>
<p>5：处理危机：速学IOS，一个星期后，看完她代码，谈话Over！</p>
<p>----------女生的事故就到此结束了----------</p>
<p>在速学IOS时，快速扫了不少培训的视频教程，发现套路都是很原始。</p>
<p>这些原始的套路了解可以，但若这些过来搬到项目来，就祸害无穷了。</p>
<p>按照当时创业的成本考虑，很大概率招来的人是以下三种：</p>
<p>1： 刚从培训班出来的；</p>
<p>2：刚看完培训视频过来；</p>
<p>3：刚用培训视频的套路祸害完一个项目后跳过来的。</p>
<p>为了对下一个开发人员有所约束：</p>
<p>让一个有3-4年开发经验的朋友帮忙整一下框架。</p>
<p>看完他整的框架，发现只是常规性的工具类分文件夹。</p>
<p>给他提了一个要求，把其中一个网络请求重新封装一下。</p>
<p>回头再看，虽有所改进，但还是不尽我意。</p>
<p>也许可以指导继续改进，但时不以我，也不以他。</p>
<p>于是自己动手了：框架大体完成60%时，招了个男开发人员。</p>
<p>----------男生的事故就此开始了-----------</p>
<p>为了赶项目，让新人在框架的基础上动工了。</p>
<p>鉴于新人开发人员能弄点东西，加上有框架的辅助，就撒手了。</p>
<p>由于框架的不完善，以及对框架的不理解，遇到点小坑就吐槽。</p>
<p>吐槽多了，也只能同意他混着其它的框架一起整了。</p>
<p>再后来，多的数不清的坑和闪退事故。</p>
<p>早期关注IT连及用IT连App的童学，就清楚了。</p>
<p>或者在我之前的IT连创业系列文章里应该可以感知了。</p>
<p>现在，他也Over了！</p>
<p>----------男生的事故就到此结束了-----------</p>
<p>重新接手回IOS后，发现代码逻辑也是一团槽，好在之前有一部份还是按框架走。</p>
<p>最近花了一周多的时候，理解，并开始重构整个项目的代码。</p>
<p>同时对框架之前已有的依赖关系也进行了抽离，并重新重构了一下框架。</p>
<p>目前对框架的重构的工作已经进行了70%-80%，还有一些功能想了还没加上。</p>
<p>但整体并不影响基础功能，所以是时候把Sagit的框架和大伙分享了！</p>
<h1>二：关于框架起名：</h1>
<p>自从：CYQ.Data 框架这名字被大伙吐槽之后，后续的框架命名，就显的格外用心了。</p>
<p>在研究了行星、星座、水果、植物、动物、颜色、形状等英文名称之后。</p>
<p>终于有了：白羊（Areis.DevFramework For DotNet）、</p>
<p>再也有了：金牛（Taurus.MVC For DotNet）</p>
<p>之后没了：双子（Gemini.workflow For DotNet) 工作流引擎目前难产中（写了开头，后来没空折腾）。</p>
<p>因此，凑齐黄金十二宫，召换雅典娜，就成了我来地球最神秘的任务了！</p>
<p>这次越级选了：Sagittarius （射手）</p>
<p>一来是ST的前缀简写刚好对应的现在创业公司的名字：随天。</p>
<p>二来取前半部做框架名，简写：Sagit（发音：射日，很和谐发现有木有）</p>
<p><img src="http://images2017.cnblogs.com/blog/17408/201712/17408-20171212213123644-406027394.jpg" alt="" width="641" height="453" /></p>
<h1>三：框架的适用场景：</h1>
<h2>1：研究学习：</h2>
<p>A：工作几年之后，开发功能已不是问题，需要有点新思维来突破受限的瓶颈。</p>
<p>看懂框架代码不难，主要是学习思维，多思考，并多训练自己怎么写。</p>
<p>B：对于在培训行业的教师，可以在培训结束前用框架的思维引导一下新人，再放他们出来。</p>
<h2>2：项目开发：</h2>
<p>A：开发人员没有框架的概念。</p>
<p>B：目前没有其它可选择的框架。</p>
<p>一般的说，除了游戏，其它常规性的项目都适合。&nbsp;</p>
<p>&nbsp;</p>
<p>下面对框架进行简单的介绍，也只能是简单介绍：</p>
<h1>Sagit 创新一：简洁的相对布局语法</h1>
<h2>1：统一标准参数，自适配手机屏幕，实现AutoLayout。</h2>
<p>A：框架默认以IPhone6的像素为标准参考体系：750*1334。</p>
<p>B：开发时，都以标准的像素单位为参数。</p>
<p>C：运行时，会自动适配成对应比例的参数。</p>
<p>（PS ：如果需要修改标准，可在STDefineUI.h文件中修改定义）</p>
<p>看着UI给的参数标注图，轻松布局：</p>
<p><img src="http://images2017.cnblogs.com/blog/17408/201712/17408-20171212232120035-160733888.png" alt="" /></p>
<h2>2： 简洁的相对布局语法，一行看尽</h2>
<p>以上图片为例，做布局</p>
<p>A：相对父元素的布局 Logo：</p>
<div class="cnblogs_code">
<pre>[[[[self addImageView:<span style="color: #800000;">@"</span><span style="color: #800000;">login_logo</span><span style="color: #800000;">"</span>] width:<span style="color: #800080;">170</span> height:<span style="color: #800080;">170</span>] relate:Top v:<span style="color: #800080;">288</span>] toCenter:X];</pre>
</div>
<p>B：相对固定元素的布局，下面这行代码是引用其它地方的：</p>
<div class="cnblogs_code">
<pre>[[[[self addImageView:<span style="color: #800000;">@"</span><span style="color: #800000;">icon_verify</span><span style="color: #800000;">"</span>] width:<span style="color: #800080;">48</span> height:<span style="color: #800080;">48</span>] onBottom:pwdIcon y:26] toCenter:X];</pre>
</div>
<h2>3：可局部刷新的布局</h2>
<p>以下这行代码，会对批定的视图的子视图重新进一次相对布局。</p>
<div class="cnblogs_code">
<pre>[self refleshLayout];</pre>
</div>
<p>&nbsp;</p>
<h1>Sagit 创新二：彻底分离的View与Controller</h1>
<p>记得很早以前，我写过一篇文章：<a id="cb_post_title_url" class="postTitle2" href="http://www.cnblogs.com/cyq1162/p/6843564.html">Objective-C iOS纯代码布局 一堆代码可以放这里！</a></p>
<p>那时候只是研究的前奏，并没有实现完整分离，当然现在是解决了。</p>
<p>举个例如：一个文本框一个按钮，点击按钮弹出文字框的内容。</p>
<p>之前的做法，你都会在Controller里写一堆UI相关的创建方法，或者需要将某些UI定义为全局变量，以便后续再去获取UI的值。</p>
<p>最差也是我之前未完成时留下的那点手尾：（下面红色的，在Controller中需要定义一个具体的LoginView变量）</p>
<p><img src="http://images2017.cnblogs.com/blog/17408/201712/17408-20171213053436113-1676527774.png" alt="" /></p>
<h2><span style="color: #ff0000;">好了，现在这个问题已经被我彻底解决了，0入侵已经成为了事实，下面看示例代码：</span></h2>
<p>LoginView 的代码：创建了一个文本框和一个点击按钮</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">@interface</span> LoginView : STView <span style="color: #008000;">//</span><span style="color: #008000;">这是LoginView.h</span>

<span style="color: #0000ff;">@end</span>

<span style="color: #0000ff;">@implementation</span> LoginView    <span style="color: #008000;">//</span><span style="color: #008000;">这是LoginView.m</span>

-(<span style="color: #0000ff;">void</span><span style="color: #000000;">)initUI
{
    [[self addTextField:</span><span style="color: #800000;">@"</span><span style="color: #800000;">userName</span><span style="color: #800000;">"</span> placeholder:<span style="color: #800000;">@"</span><span style="color: #800000;">输入手机号</span><span style="color: #800000;">"</span>] x:<span style="color: #800080;">0</span> y:<span style="color: #800080;">0</span> width:<span style="color: #800080;">100</span> height:<span style="color: #800080;">100</span><span style="color: #000000;">];
    [[self addButton:</span><span style="color: #800000;">@"</span><span style="color: #800000;">btnLogin</span><span style="color: #800000;">"</span> title:<span style="color: #800000;">@"登录"</span>] onRight:self.lastSubView.PreView x:<span style="color: #800080;">10</span><span style="color: #000000;">];
}
</span><span style="color: #0000ff;">@end</span></pre>
</div>
<p>LoginController 的代码：有一个按钮事件，获取手机号用户名然后弹出来提示</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">@interface LoginController : STController // 这是LoginController.h

@end

@implementation LoginController            //这是LoginController.m

-(void)btnLoginClick
{
    NSString* userName=[self uiValue:@"userName"];
    [self.box prompt:userName];
}
</pre>
</div>
<h3>调用：</h3>
<div class="cnblogs_code">
<pre>self.window.rootViewController = [LoginController <span style="color: #0000ff;">new</span>];</pre>
</div>
<h3>效果：（为了截图，特意新建了个demo...）</h3>
<p><img src="http://images2017.cnblogs.com/blog/17408/201712/17408-20171213064104894-1961216972.png" alt="" /></p>
<h3>解析：</h3>
<p>LoginView和LoginController两个文件代码里，并没有互相引用的地方。</p>
<p>但是UI和事件却补神奇的关联起来了，这是怎么做到的呢？</p>
<p>秘密就在STView和STController文件的源码中。</p>
<h1>Sagit 创新三：表单的自动提交与回显</h1>
<p>如果你需要提交一个表单的数据，你只需要这样：</p>
<div class="cnblogs_code">
<pre>-(<span style="color: #0000ff;">void</span><span style="color: #000000;">)btnLoginClick
{
</span><span style="color: #008000;">//</span><span style="color: #008000;">    NSString* userName=[self uiValue:@"userName"];
</span><span style="color: #008000;">//</span><span style="color: #008000;">    [self.box prompt:userName];</span>
<span style="color: #000000;">    
    [self.http post:</span><span style="color: #800000;">@"</span><span style="color: #800000;">/Login</span><span style="color: #800000;">"</span> paras:self.formData success:^(STModel *<span style="color: #000000;">result) {
        </span><span style="color: #0000ff;">if</span>(result.success)<span style="color: #008000;">//</span><span style="color: #008000;">如果：提交成功</span>
<span style="color: #000000;">        {
            [self.stView loadData:result.msg];</span><span style="color: #008000;">//</span><span style="color: #008000;">将返回的数据回显到控件</span>
<span style="color: #000000;">        }
    }];
}</span></pre>
</div>
<p>解析：</p>
<p>self.formData可以自动收集UI表单的内容。</p>
<p>self.stView loadData 可以自动将字典的数据写回UI中。</p>
<p>一切就是这么Easy，在这种常规的提交中，批量来批量去，不需要有Model的存在。</p>
<p>这里暂就不提供Demo了，后续文章再跟进。</p>
<h1>Sagit 其它功能一：月下无限连的属性语法：</h1>
<div class="cnblogs_code">
<pre>    UITextField *userName= [[[self addTextField:<span style="color: #800000;">@"</span><span style="color: #800000;">UserName</span><span style="color: #800000;">"</span> placeholder:<span style="color: #800000;">@"</span><span style="color: #800000;">手机号码</span><span style="color: #800000;">"</span>] width:<span style="color: #800080;">372</span> height:<span style="color: #800080;">68</span>] onRight:mobileIcon x:<span style="color: #800080;">30</span> y:-<span style="color: #800080;">10</span><span style="color: #000000;">];
    [[userName maxLength:</span><span style="color: #800080;">11</span>] keyboardType:UIKeyboardTypeNumberPad];</pre>
</div>
<p>&nbsp;不用再去这样写的憔碎了：</p>
<div class="cnblogs_code">
<pre> mobileTF.keyboardType                = UIKeyboardTypeNumberPad;<span style="color: #008000;">//</span><span style="color: #008000;"> UIKeyboardTypeNamePhonePad;</span>
 mobileTF.MaxLength=<span style="color: #800080;">11</span>;<span style="color: #008000;">//</span><span style="color: #008000;">                    = (id)self.Controller;</span></pre>
</div>
<h1>Sagit 其它功能二：封装了适合C#玩家的简洁语法</h1>
<p>OC的命名总是很长，做为了一名C#的大神，有义务把C#简洁的语法带过来。</p>
<p>例如：</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">@interface</span><span style="color: #000000;"> NSString(ST)

</span>-(NSString*<span style="color: #000000;">)reverse;
</span>-<span style="color: #000000;">(BOOL)isInt;
</span>-<span style="color: #000000;">(BOOL)isFloat;
</span>-(NSString*)append:(NSString*)<span style="color: #0000ff;">string</span><span style="color: #000000;">;
</span>-(NSString*)replace:(NSString*)a with:(NSString*<span style="color: #000000;">)b;
</span>-(NSString *)replace:(NSString *)a with:(NSString *<span style="color: #000000;">)b isCase:(BOOL)isCase;
</span>-(NSArray&lt;NSString*&gt;*)split:(NSString*<span style="color: #000000;">)separator;
</span>-(NSString*<span style="color: #000000;">)toUpper;
</span>-(NSString*<span style="color: #000000;">)toLower;
</span>-(BOOL)startWith:(NSString*<span style="color: #000000;">)value;
</span>-(BOOL)endWith:(NSString*<span style="color: #000000;">)value;
</span>-(BOOL)contains:(NSString*<span style="color: #000000;">)value;
</span>-(BOOL)contains:(NSString*<span style="color: #000000;">)value isCase:(BOOL)isCase;
</span>-<span style="color: #000000;">(BOOL)isEmpty;
</span>+(BOOL)isNilOrEmpty:(NSString*<span style="color: #000000;">)value;
</span>+(NSString*)toString:(<span style="color: #0000ff;">id</span><span style="color: #000000;">)value;
</span>-(NSString*)trim;</pre>
</div>
<h1>Sagit 其它功能...</h1>
<p>1：网络的请求只有三个：</p>
<div class="cnblogs_code">
<pre>[self.http <span style="color: #0000ff;">get</span><span style="color: #000000;"> ...]
[self.http post ...]
[self.http upload ...]</span></pre>
</div>
<p>2：消息提示框：</p>
<div class="cnblogs_code">
<pre><span style="color: #000000;">[self.box prompt...]
[self.box alert..]
[self.box confirm...]</span></pre>
</div>
<p>其它等。。。就不在这里介绍了，后续会慢慢写文介绍。</p>
<h1>Sagit 开源地址：</h1>
<p>GitHub：<a title="Sagit.Framework" href="https://github.com/cyq1162/Sagit" target="_blank">https://github.com/cyq1162/Sagit</a></p>
<p>目前以源码方式提供，并未打包成类库。</p>
<p>新开的：<a href="https://github.com/cyq1162/Sagit" target="_blank">IOS Sagit框架</a>&nbsp;：QQ群：702724292</p>
<h1>总结：</h1>
<p>1 ：框架刚开源，预示着在未来的日子里，升级与变动是少不了的。</p>
<p>2：框架只是个基础，完整的项目架构，还需要根据不同的业务搭配不同的第三方类库。</p>
<p>3：后续会将IT连和IT恋两个App的源码，做为示例教程，和大伙分享。</p>
<p>4：最后，依然感谢大伙关注我正在进行的IT连创业项目！</p>
