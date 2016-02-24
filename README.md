# JMRoundedCorner
告别消耗性能的layer.cornerRadius,让tableView顺滑起来

当我们需要给一个View添加圆角的时候，一般会这样写
	
	 _label.layer.cornerRadius = 10;
  	 _label.layer.masksToBounds = YES;
  	 
这种写法导致了离屏渲染，下图中黄色的部分就是离屏渲染的地方。

![](https://github.com/raozhizhen/JMRoundedCorner/blob/master/IMG_2574.PNG?raw=true)

####离屏渲染是什么？

简单来说，就是本该由GPU干的活，交给CPU干了。又因为，cpu不太擅长干CPU的活，所以往往会拖慢UI层的FPS。
我们需要尽量避免这种情况。

####如何解决？

圆角使用UIImageView来处理。
底层铺一个UIImageView,然后用GraphicsContext生成一张带圆角的图。

####JMRoundedCorner就是生成这个带圆角的图


	platform :ios, '7.0'
	
	pod 'JMRoundedCorner', '~> 0.0.1'


生成一张长宽为100，30，圆角为10的圆角矩形

[UIImage jm_imageWithRoundedCornersAndSize:CGSizeMake(100, 30) andCornerRadius:10 andColor:[UIColor redColor]];


底层铺一个UIImageView,

    UIImageView *labelRoundedCornerView = [[UIImageView alloc] initWithFrame:_label.frame];
    labelRoundedCornerView.image = [UIImage jm_imageWithRoundedCornersAndSize:CGSizeMake(100, 30) andCornerRadius:10 andColor:[UIColor redColor]];
    [self.contentView addSubview:labelRoundedCornerView];
    [self.contentView addSubview:_label];


这样，就可以避免在大量cell离屏渲染的时候拖慢fps

![](https://github.com/raozhizhen/JMRoundedCorner/blob/master/IMG_2573.PNG?raw=true)

可以将Demo下下来，比较一下使用JMRoundedCorner带来的顺滑提升，你会想使用它的。


####联系我

- QQ:337519524
- 邮箱：raozhizhen@gmail.com

####感谢

- [reviewcode.cn](http://www.reviewcode.cn/article.html?reviewId=7)

