# MHPhotoBrowser

###此项目 主要针对图片浏览 选择

设计思路是
通过点击选择 弹出Actionsheet（通过UITableView,UICollectionView）
点击不同按钮进入不同的事件
**图片选择**
首先进入图库列表(UITableview) 然后push到本地图库的所有图片缩略图(UICollectionView)
**图片浏览**
创建水平方向的UICollectionView，每个cell添加UIScrollview进行缩放操作。
大体思路如上，其中添加各种小的方法。使用方法项目有介绍。










参照项目 [ZLPhotoBrowser](https://github.com/longitachi/ZLPhotoBrowser) 对其进行了封装和优化，使其变得更切合实际项目使用。但主体思路是一样的。
