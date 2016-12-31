//
//  ImageDownloader.m
//  ecommerce
//
//  Created by Huu Tran on 12/26/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import "ImageDownloader.h"
//--------------------------------
@interface ImageDownloader () <NSURLSessionDelegate>


@end

//--------------------------------
@implementation ImageDownloader
//--------------------------------
+ (instancetype) sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageDownloader alloc] init];
    });
    
    return sharedInstance;
    
}

- (instancetype) init {
    if(self=[super init]){
        
    }
    return self;
}

#pragma mark - image download methods
- (void)downloadImageForCell:(UITableViewCell *)cell withURL:(NSURL*)url completionHandler:(void(^)())completionBlock {
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            UIImage * img = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = img;
                if (completionBlock) {
                    completionBlock();
                }
            });
        }else{
            NSLog(@"[ERROR] [downloadImageForCell:(UITableViewCell *)cell withURL:(NSURL*)url completionHandler:(void(^)())completionBlock] reason: %@", error);
        }
    }];
    
    [task resume];
}

@end
