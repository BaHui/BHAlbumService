//
//  BHExampleViewController.m
//  BHAlbumService
//
//  Created by QiaoBaHui on 2018/9/17.
//  Copyright © 2018年 QiaoBaHui. All rights reserved.
//

#import "BHExampleViewController.h"
#import "BHAlbumService.h"

@interface BHExampleViewController ()

@end

@implementation BHExampleViewController

+ (instancetype)create {
  UIStoryboard *exampleStoryboard = [UIStoryboard storyboardWithName:@"ExampleViews" bundle:nil];
  return [exampleStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([BHExampleViewController class])];
}

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - IBAction Methods

// 保存图片到默认系统相册
- (IBAction)saveToDefaultAlbumClicked:(id)sender {
  [BHAlbumService checkPermissionWithCompletion:^(BOOL isAllowed) {
    if (isAllowed) {
      [BHAlbumService saveToDefaultAlbumWithImage:[self savedImageInfo] completion:^(BOOL isSucceed, NSError *error) {
        if (isSucceed) {
          [self resultLabelAnimationWithTip:@"保存照片成功!!!"];
        } else {
          [self resultLabelAnimationWithTip:@"保存照片失败!!!"];
        }
      }];
    } else {
       [self resultLabelAnimationWithTip:@"请开启相册权限!!!"];
    }
  }];
}

// 保存图片到自定义相册
- (IBAction)saveToCustomAlbumClicked:(id)sender {
  [BHAlbumService checkPermissionWithCompletion:^(BOOL isAllowed) {
    if (isAllowed) {
      [BHAlbumService saveToCustomAlbum:@"CustomAlbum" image:[self savedImageInfo] completion:^(BOOL isSucceed, NSError *error) {
        if (isSucceed) {
          [self resultLabelAnimationWithTip:@"保存照片成功!!!"];
        } else {
          [self resultLabelAnimationWithTip:@"保存照片失败!!!"];
        }
      }];
    } else {
      [self resultLabelAnimationWithTip:@"请开启相册权限!!!"];
    }
  }];
}

#pragma mark - Private Methods

- (UIImage *)savedImageInfo {
  return [UIImage imageNamed:@"bh_example_saved"];
}

- (void)resultLabelAnimationWithTip:(NSString *)tip {
  self.resultLabel.alpha = 1;
  self.resultLabel.text = tip;

  [UIView animateWithDuration:1.5 animations:^{
    self.resultLabel.alpha = 0;
  }];
}

@end
