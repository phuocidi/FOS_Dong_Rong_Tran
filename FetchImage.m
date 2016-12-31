
// Header file
-(void)fetchImage: (NSURL *) url completionHandler: (void (^) (NSData *image)) completionHandler;


/*	
	Input value is a StringURL, and when get the image will return it by CompletionHandler. In this function it will handle the " " and replace to "%20"
*/
-(void)fetchImage:(NSString *)stringUrl completionHandler:(void (^)(NSData *))completionHandler {
	NSString *non-space = [stringUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL *url = [ NSURL URLWithString: non-space];
    NSData *imageFromCache = [self.imageToCache objectForKey:url];
    NSString *urlString = [NSString stringWithFormat:@"%@", url];
    NSString *imageUrlString = urlString;
    if (imageFromCache != nil) {
        completionHandler(imageFromCache);
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration] ;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(data)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.imageToCache setObject:data forKey:url];
                    NSLog(@"%@", [NSString stringWithFormat:@"%@", url]);
                    if ([imageUrlString isEqualToString:urlString]) {
                        completionHandler([self.imageToCache objectForKey:url]);
                    }
                });
            }
        }];
        [task resume];
    }
}