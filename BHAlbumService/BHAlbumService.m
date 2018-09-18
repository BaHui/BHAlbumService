//
//  BHAlbumService.m
//  BHAlbumService
//
//  Created by QiaoBaHui on 2018/9/17.
//  Copyright © 2018年 QiaoBaHui. All rights reserved.
//

#import "BHAlbumService.h"
#import <Photos/Photos.h>

typedef void(^SaveDefaultCompletionBlock)(BOOL isSucceed, NSError *error);
typedef void(^SaveCustomCompletionBlock)(BOOL isSucceed, NSError *error);

@implementation BHAlbumService

static SaveDefaultCompletionBlock saveDefaultCompletionBlock = nil;
static SaveCustomCompletionBlock saveCustomCompletionBlock = nil;

#pragma mark - Check Permission

+ (void)checkPermissionWithCompletion:(void(^)(BOOL isAllowed))completion {
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    dispatch_async(dispatch_get_main_queue(), ^{
      BOOL allowed = (status == PHAuthorizationStatusAuthorized || PHAuthorizationStatusNotDetermined);

      if (completion) {
        completion(allowed);
      }
    });
  }];
}

#pragma mark - Save To Default Album

+ (void)saveToDefaultAlbumWithImage:(UIImage *)image completion:(void(^)(BOOL isSucceed, NSError *error))completion {
  saveDefaultCompletionBlock = completion;

  [BHAlbumService checkPermissionWithCompletion:^(BOOL isAllowed) {
    if (isAllowed) {
      UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
      NSLog(@"检测到您未开启相册权限!!!");
    }
  }];
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  if (saveDefaultCompletionBlock) {
    saveDefaultCompletionBlock(error == nil, error);
  }
}

#pragma mark - Save To Custom Album

+ (void)saveToCustomAlbum:(NSString *)albumName image:(UIImage *)image completion:(void(^)(BOOL isSucceed, NSError *error))completion {
  saveCustomCompletionBlock = completion;

  [BHAlbumService checkPermissionWithCompletion:^(BOOL isAllowed) {
    if (isAllowed) {
      PHFetchResult<PHAsset *> *asset = [self createdAssetWithImage:image];
      PHAssetCollection *assetCollection = [self foundOrCreateCustomAssetCollectionWithAlbumName:albumName];

      NSError *error = nil;
      [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [request insertAssets:asset atIndexes:[NSIndexSet indexSetWithIndex:0]];
      } error:&error];

      if (completion) {
        completion(error == nil, error);
      }
    } else {
      NSLog(@"检测到您未开启相册权限!!!");
    }
  }];
}

#pragma mark - Private Methods

+ (PHFetchResult<PHAsset *> *)createdAssetWithImage:(UIImage *)image {
  PHFetchResult *fetchResult = nil;
  __block NSString *assetID = nil;

  NSError *error = nil;
  [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
    assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
  } error:&error];

  if (!error) {
    fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
  }

  return fetchResult;
}

+ (PHAssetCollection *)foundOrCreateCustomAssetCollectionWithAlbumName:(NSString *)albumName {
  PHAssetCollection *customAssetCollection = nil;

  PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
  for (PHAssetCollection *assetCollection in assetCollections) {
    if ([assetCollection.localizedTitle isEqualToString:albumName]) {
      customAssetCollection = assetCollection;
      break;
    }
  }

  if (!customAssetCollection) {
    NSError *error = nil;
    __block NSString *createdCollectionID = nil;

    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
      createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (!error) {
      customAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
    }
  }

  return customAssetCollection;
}

@end
