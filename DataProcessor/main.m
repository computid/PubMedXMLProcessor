//
//  main.m
//  DataProcessor
//
//  Created by Adam Bradley on 06/10/2016.
//  Copyright © 2016 Naguna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileProcessor.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        

       /* for(int i=0;i<sizeof(argv);i++)
        {
            NSLog(@"Arg: %s", argv[i]);
        }*/
        
        NSLog(@"Arg1: %s", argv[1]);
        NSLog(@"Arg2: %s", argv[2]);
        NSLog(@"Arg3: %s", argv[3]);
        
        NSString * RunNumArg = [NSString stringWithFormat:@"%s", argv[1]];
        NSString * InputDIR = [NSString stringWithFormat:@"%s", argv[2]];
        NSString * OutputDIR = [NSString stringWithFormat:@"%s", argv[3]];
        
        //-(void)ProcessXMLFile:(NSString *)RunNumber :(NSString *)InputDirectory :(NSString*)OutputDirectory
        FileProcessor *Processor = [[FileProcessor alloc] init];
        
        
        [Processor ProcessXMLFile:RunNumArg :InputDIR :OutputDIR];
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}

  //-(void)ProcessXMLFile:(NSString *)RunNumber :(NSString *)InputDirectory :(NSString*)OutputDirectory
