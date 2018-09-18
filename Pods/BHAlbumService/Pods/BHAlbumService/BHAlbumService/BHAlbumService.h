//
//  BHAlbumService.h
//  BHAlbumService
//
//  Created by QiaoBaHui on 2018/9/17.
//  Copyright © 2018年 QiaoBaHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHAlbumService : NSObject

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

@end
