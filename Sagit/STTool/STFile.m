//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STFile.h"

@implementation STFile

+ (instancetype)share {
    static STFile *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[STFile alloc] init];
        _share.FileName=@"stFile.plist";
    });
    return _share; 
}
-(CGFloat)size
{
    CGFloat folderSize = 0.0f;
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    //    NSLog(@"文件数：%ld",files.count);
    for(NSString *path in files) {
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        //累加
        folderSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = (CGFloat)(folderSize /1024.0/1024.0);
    
    return sizeM;
}

- (void)clear:(void(^)(BOOL success))block {
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    BOOL result=YES;
    for(NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    if(block!=nil){block(result);}
    
}
-(void)set:(NSString *)key value:(id)value
{
    if(key==nil || value==nil){return;}
    @try
    {
        NSMutableDictionary *dic = [self file:self.FileName];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        [dic setObject:data forKey:key];
        [dic writeToFile:[self filePath:self.FileName] atomically:YES];
    }
    @catch(NSException * e)
    {}
}
-(id)get:(NSString *)key
{
    if(key==nil){return nil;}
    @try
    {
        NSMutableDictionary *dic = [self file:self.FileName];
        if(dic!=nil && dic.allKeys.count>0)
        {
            NSData *data = [dic objectForKey:key];
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    @catch(NSException * e)
    {}
    return nil;
}
-(void)remove:(NSString *)key
{
    if(key==nil){return;}
    @try
    {
        NSMutableDictionary *dic = [self file:self.FileName];
        [dic remove:key];
        [dic writeToFile:[self filePath:self.FileName] atomically:YES];
    }
    @catch(NSException * e)
    {}
}
#pragma mark --- 私有方法
- (NSString *)filePath:(NSString *)fileName {
    NSString *dicPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filedicPath = [dicPath  stringByAppendingPathComponent:fileName];
    return filedicPath;
}

- (NSMutableDictionary *)file:(NSString *)fileName {
    NSString *filedicPath = [self filePath:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *fileDic;
    if ([fileManager fileExistsAtPath:filedicPath]) {
        fileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filedicPath];
    } else {
        fileDic = [NSMutableDictionary dictionary];
    }
    return fileDic;
}

@end
