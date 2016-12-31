//
//  ImageDownloader.h
//  ecommerce
//
//  Created by Huu Tran on 12/26/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// ----------------------------------

/**
 @brief return save the image
 */
@interface ImageDownloader : NSObject

+ (instancetype) sharedInstance;

- (void)downloadImageForCell:(UITableViewCell *)cell withURL:(NSURL*)url completionHandler:(void(^)())completionBlock;

@end
