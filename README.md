#2种自定义数字键盘
######随机数键盘借鉴了[WAMaker/SelfDefineKeyboard](https://github.com/WAMaker/SelfDefineKeyboard)的demo。
效果如下

![1.gif](http://upload-images.jianshu.io/upload_images/810907-b705398a11431209.gif?imageMogr2/auto-orient/strip)

使用TTTextField或者TTTextView即可支持。

```objc
// 数字键盘
self.tdNum.keyboardViewType = KeyboardViewNum; // 默认值
self.tdNum.dotvalue = 3; // 默认2位小数
// 随机数键盘
self.tdRanNum.keyboardViewType = KeyboardViewRandomNum;
self.tdRanNum.PWDlength = 6; // 默认不限制
```

[详细介绍戳](http://www.jianshu.com/p/d911c644e4a1)