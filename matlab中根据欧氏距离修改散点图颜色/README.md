matlab 中 散点图之 根据权重或者欧氏距离调整颜色
=
# 0、前言
写这篇博客的原由，主要是自己在`matlab`上画散点图时，觉得图的颜色有点问题，具体是每块图从边缘到中心的颜色变化趋势不明显，所以才想办法进行更改！然后本篇博客将从一开始没有颜色变换的原图开始，对自己解决问题的过程及逆行一波叙述！


# 1、主要内容
先看一下原图以及对应的画图代码
![在这里插入图片描述](https://img-blog.csdnimg.cn/2fc7d501d6f2454ea399bec4fbeba5e0.png)
此时画图的代码为


	figure;
	c = linspace(1,10,length(ofdm_x)); 
	scatter(x,y,10,c,'filled');% x,y是图中散点的坐标
	% shading interp;
	colormap default
	axis square
	xlim([-1,1]);ylim([-1,1]);
	set(gca,'XTick',[],'YTick',[]);% 隐藏坐标轴


很明显可看出这个图中 9个区域中的颜色基本是杂乱的，没有明显体现出越到中心权重越大或颜色越鲜艳的样式，为此对上图做了如下修改：

1. 先确定出每个区域的中心点坐标；


2. 求每个散点到各自中心点的欧氏距离；


3. 将求出的欧氏距离结果赋给上述程序的 `c` 用来确定每个点的颜色！



修改后的结果如图
![在这里插入图片描述](https://img-blog.csdnimg.cn/32156a1b8e0548f89f8f35e0c42c890c.png)
这个图就可实现越到中心权重越大或颜色越鲜艳的目标，若想换其他颜色，可以根据 `colormap` 颜色图的种类自由选择，具体选项如图
![在这里插入图片描述](https://img-blog.csdnimg.cn/78afefa470c84352960a5d96f80f6c08.png)
*注：此图来源于matlab官方解释，侵权删~*
选择了 `winter` 颜色图出来的图为
![在这里插入图片描述](https://img-blog.csdnimg.cn/e70a0b8f54ec4f838e64006f6b31579c.png)
这个效果更不明显，但当将该winter 颜色图中颜色翻转后图就可以清晰的显示目标功能，相关代码如下


	figure;
	scatter(x,y,10,c,'filled');% x,y是图中散点的坐标
	% shading interp;
	colormap(flipud(winter))
	axis square
	xlim([-1,1]);ylim([-1,1]);
	set(gca,'XTick',[],'YTick',[]);% 隐藏坐标轴

其中，`flipud()` 作用是 **上下翻转目标阵列**，具体函数解释可看官方文档，或看下图
![在这里插入图片描述](https://img-blog.csdnimg.cn/7c9f3857d88749e88bf992a154bc18ef.png)

运行出来的图为
![在这里插入图片描述](https://img-blog.csdnimg.cn/548ef149cf1e408dacc9603f8a14b913.png)

此时的效果就比一开始的更好看一点，具体颜色啥的读者可自己尝试，找出自己喜欢的即可~

*侵权删~*