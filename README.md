# BHAlbumService

## 简介
>   **Album Service方便的将图片存储于手机相册中,  支持存储到默认的相册和自定义的相册中.** 

#### 使用Pod集成
pod 'BHLogFactory', '~> 1.1.1'

#### 使用说明:
#import "BHAlbumService.h"

#### 支持系统:  iOS8+

## 相册权限配置:
>  **iOS11以前:** 
>>`NSPhotoLibraryUsageDescription` // 访问相册和存储照片到相册（读写），需要用户授权

>    **iOS11以后:**
>> `NSPhotoLibraryUsageDescription`  // 无需添加。默认开启访问相册权限（读），无需用户授权
`NSPhotoLibraryAddUsageDescription`  // 添加内容到相册（写），需要用户授权`


> 因此, 需要在项目的plist文件中新增两个key和对应的描述信息, 分别为:
>* **`NSPhotoLibraryUsageDescription`**
>* **`NSPhotoLibraryAddUsageDescription`**

## 方法调用:
```
/**
* 校验是否有权限打开相册;
**/
+ (void)checkPermissionWithCompletion:(void(^)(BOOL isAllowed))completion;

/**
* 图片保存到系统默认的相册;
**/
+ (void)saveToDefaultAlbumWithImage:(UIImage *)image completion:(void(^)(BOOL isSucceed, NSError *error))completion;

/**
* 图片保存至自定义相册(相册名: albumName);
**/
+ (void)saveToCustomAlbum:(NSString *)albumName image:(UIImage *)image completion:(void(^)(BOOL isSucceed, NSError *error))completion;

```
> 建议: 在调用存储方法时, 建议先调用相册权限校验, 来实现一些自定义的无权限提示操作.

-------------------


## 交流与建议
- GitHub：<https://github.com/BaHui>
- 邮  箱：<qiaobahuiyouxiang@163.com>

