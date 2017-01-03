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

@property (strong, nonatomic) NSCache * imageToCache;

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
- (void)downloadImageForCellwithURL:(NSURL*)url completionHandler:(void(^)(UIImage * image))completionBlock {
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            UIImage * img = [UIImage imageWithData:data];
            
                if (completionBlock) {
                    completionBlock(img);
                }
        }else{
            NSLog(@"[ERROR] [downloadImageForCell:(UITableViewCell *)cell withURL:(NSURL*)url completionHandler:(void(^)())completionBlock] reason: %@", error);
        }
    }];
    
    [task resume];
}


/*
	Input value is a StringURL, and when get the image will return it by CompletionHandler. In this function it will handle the " " and replace to "%20"
 */
-(void)fetchImage:(NSString *)stringUrl completionHandler:(void (^)(NSData *))completionHandler {
    
    NSString *nonSpace = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [ NSURL URLWithString: nonSpace];
    
    NSData *imageFromCache = [self.imageToCache objectForKey:url];
    NSString *urlString = [NSString stringWithFormat:@"%@", url];
    NSString *imageUrlString = urlString;
    if (imageFromCache != nil) {
        completionHandler(imageFromCache);
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration] ;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(data)
            {
                [self.imageToCache setObject:data forKey:url];
                NSLog(@"%@", [NSString stringWithFormat:@"%@", url]);
                if ([imageUrlString isEqualToString:urlString]) {
                    completionHandler([self.imageToCache objectForKey:url]);
                }
            }
        }];
        [task resume];
    }
}

@end
