# BioMetricAuthenticator

>一行代码实现TouchID FaceID验证用户身份。

## 注意

适配iOS11：iPhoneX有FaceID我们需要在Info.plist加入NSFaceIDUsageDescription键值，不加可能导致程序Crash。

```swift
<key>NSFaceIDUsageDescription</key>
<string>面容ID用于保证您的数据安全</string>
```


## 文章
[LocalAuthentication 浅析](http://www.jianshu.com/p/95a144bbdbf9)
