//
//  VoiceConverter.m
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation VoiceConverter

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath{
    
    if (! DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0;
    
    return 1;
}

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath{
    
    if (EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return 0;
    
    return 1;
}

+ (BOOL)convertAmrToWav:(NSString*)amrPath wavSavePath:(NSString*)savePath
{
    const char *amrCString = [amrPath cStringUsingEncoding:NSASCIIStringEncoding];
    const char *savePathCString = [savePath cStringUsingEncoding:NSASCIIStringEncoding];
    int decode = DecodeAMRFileToWAVEFile(amrCString, savePathCString);
    return (BOOL)!decode;
}

+ (BOOL)convertWavToAmr:(NSString*)wavPath amrSavePath:(NSString*)savePath
{
    const char *wavCString = [wavPath cStringUsingEncoding:NSASCIIStringEncoding];
    const char *savePathCString = [savePath cStringUsingEncoding:NSASCIIStringEncoding];
    int encode = EncodeWAVEFileToAMRFile(wavCString, savePathCString, 1, 16);
    return (BOOL)encode;
}

    
    
@end
