//
//  amrFileCodec.h
//  amrDemoForiOS
//
//  Created by Tang Xiaoping on 9/27/11.
//  Copyright 2011 test. All rights reserved.
//
#ifndef amrFileCodec_h
#define amrFileCodec_h
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "interf_dec.h"
#include "interf_enc.h"

#define AMR_MAGIC_NUMBER "#!AMR\n"
#define MP3_MAGIC_NUMBER "ID3"

#define PCM_FRAME_SIZE 160 // 8khz 8000*0.02=160
#define MAX_AMR_FRAME_SIZE 32
#define AMR_FRAME_COUNT_PER_SECOND 50

typedef struct
{
	char chChunkID[4];
	int nChunkSize;
}XCHUNKHEADER;

typedef struct
{
	short nFormatTag;
	short nChannels;
	int nSamplesPerSec;
	int nAvgBytesPerSec;
	short nBlockAlign;
	short nBitsPerSample;
}WAVEFORMAT;

typedef struct
{
	short nFormatTag;
	short nChannels;
	int nSamplesPerSec;
	int nAvgBytesPerSec;
	short nBlockAlign;
	short nBitsPerSample;
	short nExSize;
}WAVEFORMATX;

typedef struct
{
	char chRiffID[4];
	int nRiffSize;
	char chRiffFormat[4];
}RIFFHEADER;

typedef struct
{
	char chFmtID[4];
	int nFmtSize;
	WAVEFORMAT wf;
}FMTBLOCK;

// WAVE音频采样频率是8khz 
// 音频样本单元数 = 8000*0.02 = 160 (由采样频率决定)
// 声道数 1 : 160
//        2 : 160*2 = 320
// bps决定样本(sample)大小
// bps = 8 --> 8位 unsigned char
//       16 --> 16位 unsigned short

//http://stackoverflow.com/questions/10099135/xcode-4-3-2-linking-error-but-the-arch-does-exist-why

#ifdef __cplusplus
extern "C" {
#endif
    int EncodeWAVEFileToAMRFile(const char* pchWAVEFilename, const char* pchAMRFileName, int nChannels, int nBitsPerSample);
#ifdef __cplusplus
}
#endif


// 将AMR文件解码成WAVE文件
#ifdef __cplusplus
extern "C" {
#endif
    int DecodeAMRFileToWAVEFile(const char* pchAMRFileName, const char* pchWAVEFilename);
#ifdef __cplusplus
}
#endif

// 是否是 amr 文件
#ifdef __cplusplus
extern "C" {
#endif
    int isAMRFile(const char *filePath);
#ifdef __cplusplus
}
#endif


//是否是 mp3 文件
#ifdef __cplusplus
extern "C" {
#endif
    int isMP3File(const char *filePath);
#ifdef __cplusplus
}
#endif




#endif





