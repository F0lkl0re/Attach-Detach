#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFSerialize.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <assert.h>
#include <sys/param.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

// based on MobileStorageMounter

@interface DIBaseParams : NSObject <NSSecureCoding, NSCoding>
+(BOOL)supportsSecureCoding;
-(void)invalidate;
-(id)initWithCoder:(id)arg1 ;
-(NSURL *)inputURL;
-(void)encodeWithCoder:(id)arg1 ;
-(id)description;
-(BOOL)RAMdisk;
-(id)initWithURL:(id)arg1 fileOpenMode:(unsigned short)arg2 error:(id*)arg3 ;
-(BOOL)hasCryptoBackend;
-(long long)logsForwarding;
-(BOOL)getPassphraseFromUserWithXpcHandler:(id)arg1 error:(id*)arg2 ;
-(BOOL)allowStoringInKeychain;
-(long long)debugLevel;
-(unsigned long long)readPassphraseFlags;
-(BOOL)setPassphrase:(const char*)arg1 error:(id*)arg2 ;
-(BOOL)getPassphraseFromConsoleWithUseStdin:(BOOL)arg1 error:(id*)arg2 ;
-(void)setDebugLevel:(long long)arg1 ;
-(void)setLogsForwarding:(long long)arg1 ;
-(id)copyEncryptionUUID;
-(id)copyInstanceID;
-(unsigned long long)rawBlockSize;
-(void)setRawBlockSize:(unsigned long long)arg1 ;
-(void)setReadPassphraseFlags:(unsigned long long)arg1 ;
-(void)setAllowStoringInKeychain:(BOOL)arg1 ;
@end


@interface DIAttachParams : DIBaseParams {

	BOOL _autoMount;
	BOOL _handleRefCount;
	long long _fileMode;
	unsigned long long _concurrency;
	unsigned long long _commandSize;
	unsigned long long _regEntryID;
	NSURL* _inputMountedOnURL;
}
@property (assign,nonatomic) unsigned long long concurrency;               //@synthesize concurrency=_concurrency - In the implementation block
@property (assign,nonatomic) unsigned long long commandSize;               //@synthesize commandSize=_commandSize - In the implementation block
@property (assign,nonatomic) unsigned long long regEntryID;                //@synthesize regEntryID=_regEntryID - In the implementation block
@property (assign,nonatomic) BOOL handleRefCount;                          //@synthesize handleRefCount=_handleRefCount - In the implementation block
@property (nonatomic,retain) NSURL * inputMountedOnURL;                    //@synthesize inputMountedOnURL=_inputMountedOnURL - In the implementation block
@property (assign) BOOL autoMount;                                         //@synthesize autoMount=_autoMount - In the implementation block
@property (assign,nonatomic) long long fileMode;                           //@synthesize fileMode=_fileMode - In the implementation block
@property (assign,nonatomic) unsigned long long rawBlockSize; 
+(BOOL)supportsSecureCoding;
-(id)initWithURL:(id)arg1 error:(id*)arg2 ;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(void)setHandleRefCount:(BOOL)arg1 ;
-(id)newAttachWithError:(id*)arg1 ;
-(unsigned long long)regEntryID;
-(BOOL)handleRefCount;
-(BOOL)autoMount;
-(unsigned long long)concurrency;
-(unsigned long long)commandSize;
-(NSURL *)inputMountedOnURL;
-(long long)fileMode;
-(void)setFileMode:(long long)arg1 ;
-(BOOL)reOpenIfWritableWithError:(id*)arg1 ;
-(void)setAutoMount:(BOOL)arg1 ;
-(void)setConcurrency:(unsigned long long)arg1 ;
-(void)setCommandSize:(unsigned long long)arg1 ;
-(void)setRegEntryID:(unsigned long long)arg1 ;
-(void)setInputMountedOnURL:(NSURL *)arg1 ;
@end

@interface DIDeviceHandle : NSObject
+(BOOL)supportsSecureCoding;
+(unsigned)copyIOMediaWithService:(unsigned)arg1 error:(id*)arg2 ;
+(id)copyBSDNameWithService:(unsigned)arg1 error:(id*)arg2 ;
-(NSString *)BSDName;
-(void)setIoMedia:(unsigned)arg1 ;
-(unsigned)ioMedia;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(id)description;
-(void)dealloc;
-(void)setHandleRefCount:(BOOL)arg1 ;
-(id)initWithRegEntryID:(unsigned long long)arg1 xpcEndpoint:(id)arg2 ;
-(unsigned long long)regEntryID;
-(unsigned)copyKernelServiceWithError:(id*)arg1 ;
-(void)setBSDName:(NSString *)arg1 ;
-(void)waitForQuietWithService:(unsigned)arg1 ;
-(BOOL)updateBSDNameWithError:(id*)arg1 ;
-(BOOL)addToRefCountWithError:(id*)arg1 ;
-(BOOL)handleRefCount;
-(id)initWithRegEntryID:(unsigned long long)arg1 ;
-(BOOL)waitForDeviceWithError:(id*)arg1 ;
@end

@interface DiskImages2 : NSObject

+(void)attachWithParams:(DIAttachParams *)param handle:(DIDeviceHandle **)h error:(NSError **)err;

@end

int main(int argc, char **argv) {
    if(!argv[1]) {
        fprintf(stderr, "Usage: attach file.dmg\n");
        return 1;
    }

    char *abspath = realpath(argv[1], NULL);
    if(!abspath) {
        fprintf(stderr, "couldn't resolve file: %s\n", strerror(errno));
        return 1;
    }

    NSString *absStr = [NSString stringWithUTF8String:abspath];

    NSURL *absPathUrl = [NSURL fileURLWithPath:absStr];

    NSError *err;
    DIAttachParams *attachParam = [[DIAttachParams alloc] initWithURL:absPathUrl error:&err];
    if (err) {
        NSLog(@"%@", err);
        return 1;
    }
    [attachParam setAutoMount:NO];
    [attachParam setFileMode:3];

    DIDeviceHandle *handle;
    [DiskImages2 attachWithParams:attachParam handle:&handle error:&err];
    if (err) {
        NSLog(@"%@", err);
        return 1;
    }
    printf("%s\n", [[handle BSDName] UTF8String]);
    return 0;
}
