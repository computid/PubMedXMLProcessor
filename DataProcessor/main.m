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
        
        FileProcessor *Processor = [[FileProcessor alloc] init];
        
        
        
        
        [Processor ProcessXMLFile:@"/Users/AdamBradley/Desktop/PubMed/ftp.ncbi.nlm.nih.gov/pubmed/baseline/medline16n0006.xml"];
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}

