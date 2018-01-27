//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STFile.h"
#import "STDictionary.h"

@interface STFile()
@property (nonatomic,assign)NSSearchPathDirectory directory;
@property (nonatomic,retain)NSMutableDictionary *cacheDic;
@property (nonatomic,copy) NSString* STBigFileFoler;
@end

@implementation STFile

+ (instancetype)share
{
    static STFile *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[STFile alloc] init];
        _share.directory=NSCachesDirectory;
    });
    return _share; 
}
-(STFile *)Home
{
    if(!_Home)
    {
        _Home=[STFile new];
        _Home.directory=NSUserDirectory;
    }
    return _Home;
}
-(STFile *)Document
{
    if(!_Document)
    {
        _Document=[STFile new];
        _Document.directory=NSDocumentDirectory;
    }
    return _Document;
}
-(STFile *)Libaray
{
    if(!_Libaray)
    {
        _Libaray=[STFile new];
        _Libaray.directory=NSLibraryDirectory;
    }
    return _Libaray;
}
-(STFile *)Temp
{
    if(!_Temp)
    {
        _Temp=[STFile new];
        _Temp.directory=NSDemoApplicationDirectory;
    }
    return _Temp;
}
-(NSString *)fileName
{
    return @"stfile.plist";
}
-(CGFloat)size
{
    CGFloat folderSize = 0.0f;
    //获取路径
    NSString *cachePath = [self folderPath];
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
    NSString *cachePath=self.folderPath;
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
    _cacheDic=nil;
    _STBigFileFoler=nil;//需要重新创建文件夹。
    if(block!=nil){block(result);}
    
}
-(void)set:(NSString *)key value:(id)value
{
    if(key==nil || value==nil){return;}
    @try
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        if(data)
        {
            if(data.length>4*1024) // >4K转存独立文件
            {
                NSString *fileName=[[@"STBigFile_" append:[@([key hash]) stringValue]] append:@".dat"];
                [data writeToFile:[self.STBigFileFoler append:fileName] atomically:YES];
                [self.cacheDic set:key value:fileName];
            }
            else
            {
                [self.cacheDic set:key value:data];
            }
            [self writeToFile];
        }
    }
    @catch(NSException * e)
    {}
}
-(id)get:(NSString *)key
{
    if(key==nil){return nil;}
    @try
    {
        if(self.cacheDic.count>0)
        {
            id data = [self.cacheDic get:key];
            if(data)
            {
                if([data isKindOfClass:[NSString class]] && [((NSString*)data) startWith:@"STBigFile_"])
                {
                    NSString *path=[self.STBigFileFoler append:(NSString*)data];
                    data=[[NSData alloc] initWithContentsOfFile:path];
                }
                if(data)
                {
                    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
                }
            }
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
        [self.cacheDic remove:key];
        [self writeToFile];
    }
    @catch(NSException * e)
    {}
}
-(NSMutableDictionary *)cacheDic
{
    if(!_cacheDic)
    {
        _cacheDic=[self readFromFile];
    }
    return _cacheDic;
}
-(void)writeToFile
{
     [self.cacheDic writeToFile:self.filePath atomically:YES];
}

- (NSMutableDictionary *)readFromFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *fileDic;
    if ([fileManager fileExistsAtPath:self.filePath])
    {
        fileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
    }
    else
    {
        fileDic = [NSMutableDictionary new];
    }
    return fileDic;
}
-(NSString*)filePath
{
    return [self.folderPath stringByAppendingPathComponent:self.fileName];
}
-(NSString*)folderPath
{
    NSString *folder=nil;
    switch (self.directory) {
        case NSUserDirectory:
            folder=NSHomeDirectory();
            break;
        case NSDemoApplicationDirectory:
            folder=NSTemporaryDirectory();
            break;
        default:
            folder=NSSearchPathForDirectoriesInDomains(self.directory, NSUserDomainMask, YES).lastObject;
            break;
    }
    return folder;
}
-(NSString *)STBigFileFoler
{
    if(!_STBigFileFoler)
    {
        _STBigFileFoler=[[self folderPath] append:@"/STBigFile/"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:_STBigFileFoler])
        {
            [fileManager createDirectoryAtPath:_STBigFileFoler withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _STBigFileFoler;
}
@end
