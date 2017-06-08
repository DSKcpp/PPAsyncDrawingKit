//
//  NSData+Gzip.m
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/5/29.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "NSData+Gzip.h"
#import "zlib.h"

@implementation NSData (Gzip)
- (NSData *)uncompressZipped
{
    if ([self length] == 0) return self;
    
    unsigned long full_length = [self length];
    
    
    unsigned long half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    
    BOOL done = NO;
    
    int status;
    
    z_stream strm;
    
    strm.next_in = (Bytef *)[self bytes];
    
    strm.avail_in = (uInt)[self length];
    
    strm.total_out = 0;
    
    strm.zalloc = Z_NULL;
    
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    
    while (!done) {
        
        // Make sure we have enough room and reset the lengths.
        
        if (strm.total_out >= [decompressed length]) {
            
            [decompressed increaseLengthBy: half_length];
        }
        
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        
        status = inflate (&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) {
            
            done = YES;
            
        } else if (status != Z_OK) {
            
            break;
        }
        
    }
    
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    
    if (done) {
        
        [decompressed setLength: strm.total_out];
        
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}

@end
