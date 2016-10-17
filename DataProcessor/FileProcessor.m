//
//  FileProcessor.m
//  DataProcessor
//
//  Created by Adam Bradley on 06/10/2016.
//  Copyright © 2016 Naguna. All rights reserved.
//

#import "FileProcessor.h"
#import "XMLReader.h"
#import "DCTar.h"
#import <zlib.h>

@implementation FileProcessor

-(void)ProcessXMLFile:(NSString *)RunNumber :(NSString *)InputDirectory :(NSString*)OutputDirectory
{
    NSLog(@"Process number: %@", RunNumber);
    
    
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:InputDirectory error:Nil];
    
    NSArray* TarFiles = [dirs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.xml.gz'"]];
    
    for(int p=0; p<[TarFiles count];p++)
    {
        //NSLog(@"Tarfiles: %@", [TarFiles objectAtIndex:p]);
        
        @autoreleasepool {
        
        NSString * Frompath = InputDirectory;
        NSString * Filepath = [Frompath stringByAppendingPathComponent:[TarFiles objectAtIndex:p]];
            
        NSString * FileNameWithoutExt1 = [[[TarFiles objectAtIndex:p] lastPathComponent] stringByDeletingPathExtension];
        NSString * FileNameWithoutExt = [[FileNameWithoutExt1 lastPathComponent] stringByDeletingPathExtension];
        
        NSString* toPath = [NSString stringWithFormat:@"%@/Temp/",InputDirectory];
        NSString* toPath1 = [toPath stringByAppendingPathComponent:[NSString stringWithFormat:@"testFile-%i.xml",p]];
        NSError * err1;
        [DCTar gzipDecompress:Filepath toPath:toPath1 error:&err1];
        
        NSURL * URL1 = [NSURL fileURLWithPath:Filepath];
        NSURL * URL2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Done/%@",InputDirectory,[TarFiles objectAtIndex:p]]];
        NSError * err2;
        [[NSFileManager defaultManager] copyItemAtURL:URL1 toURL:URL2 error:&err2];
        
        //NSLog(@"Error: %@", err2);
        
        
        
        NSMutableArray * AbstractQueries = [[NSMutableArray alloc] init];
        NSMutableArray * KeywordQueries = [[NSMutableArray alloc] init];
        NSMutableArray * MeshHeadingQueries = [[NSMutableArray alloc] init];
        NSMutableArray * ArticleQueries = [[NSMutableArray alloc] init];
        

        
        
        NSString * fileContents = [NSString stringWithContentsOfFile:toPath1 encoding:NSUTF8StringEncoding error:nil];
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:fileContents error:&parseError];
        //NSLog(@"%@", xmlDictionary);
        
        NSMutableArray * ArrayOfQueries = [[NSMutableArray alloc] init];
        
        for(int i=0; i<[xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"] count]; i++)
        {

            
            NSString * ArticleTitle = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"ArticleTitle"][@"text"]];
            
            
            
            NSString * PMID = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"PMID"][@"text"]];
            
            NSString * DateCreated = [NSString stringWithFormat:@"%@-%@-%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateCreated"][@"Day"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateCreated"][@"Month"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateCreated"][@"Year"][@"text"]];
            
            NSString * DateCompleted = [NSString stringWithFormat:@"%@-%@-%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateCompleted"][@"Day"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateCompleted"][@"Month"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateCompleted"][@"Year"][@"text"]];
            
            NSString * DateRevised = [NSString stringWithFormat:@"%@-%@-%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateRevised"][@"Day"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateRevised"][@"Month"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"DateRevised"][@"Year"][@"text"]];
            
            
            NSString * Volume = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"Journal"][@"JournalIssue"][@"Volume"][@"text"]];
            
            NSString * PublicationDate = [NSString stringWithFormat:@"%@-%@", xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"Journal"][@"JournalIssue"][@"PubDate"][@"Month"][@"text"],xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"Journal"][@"JournalIssue"][@"PubDate"][@"Year"][@"text"]];
            
            NSString * JournalTitle = [NSString stringWithFormat:@"%@", xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"Journal"][@"Title"][@"text"]];
            
            NSString * ISOAbbreviation = [NSString stringWithFormat:@"%@", xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"Journal"][@"ISOAbbreviation"][@"text"]];
            
            
            //NSString * Language = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Article"][@"Language"][@"text"]];
            NSString * Language = @"";
            
            NSString * GeneralNote = @"";
            
            id jso5 = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"GeneralNote"];
            
            if (jso5 == nil) {
                // Error.  You should probably have passed an NSError ** as the error
                // argument so you could log it.
            } else if ([jso5 isKindOfClass:[NSMutableDictionary class]]) {
            
                GeneralNote = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"GeneralNote"][@"text"]];
            
            } else {
                GeneralNote = @"";
            }
            
        //    NSMutableArray * AbstractArray = [[NSMutableArray alloc] init];
            
            id jso99 = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"OtherAbstract"];
            
            
            if (jso99 == nil) {
                // Error.  You should probably have passed an NSError ** as the error
                // argument so you could log it.
            } else if ([jso99 isKindOfClass:[NSArray class]]) {
                
                for(int h=0;h<[xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"OtherAbstract"] count];h++)
                {
                    NSString * CurrentAbstract = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"OtherAbstract"][h][@"AbstractText"][@"text"];
                    CurrentAbstract = [CurrentAbstract stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    
                    if(![CurrentAbstract isEqualToString:@"Abstract available from the publisher."])
                    {
                        if(([CurrentAbstract length] > 2) && (![CurrentAbstract isEqual:@"(null)"]))
                        {
                            NSString * AbstractQuery = [NSString stringWithFormat:@"(NULL,'%@','%@')",PMID,CurrentAbstract];
                            
                            [AbstractQueries addObject:AbstractQuery];
                        }
                    }
                }
                    
                
                // process array elements
            } else if ([jso99 isKindOfClass:[NSDictionary class]]) {
                NSString * AbstractText = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"OtherAbstract"][@"AbstractText"][@"text"]];
                AbstractText = [AbstractText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                if(![AbstractText isEqualToString:@"Abstract available from the publisher."])
                {
                    if(([AbstractText length] > 2) && (![AbstractText isEqual:@"(null)"]))
                    {
                        NSString * AbstractQuery = [NSString stringWithFormat:@"(NULL,'%@','%@')",PMID,AbstractText];
                        
                        [AbstractQueries addObject:AbstractQuery];
                    }
                }
                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                NSLog(@"Something else?!?: %@", jso99);
            }
            
            
            //Abstracts
            
            id jso88 = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Abstract"];
            
            
            if (jso88 == nil) {
                // Error.  You should probably have passed an NSError ** as the error
                // argument so you could log it.
            } else if ([jso88 isKindOfClass:[NSArray class]]) {
                
                for(int h=0;h<[xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Abstract"] count];h++)
                {
                    NSString * CurrentAbstract = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Abstract"][h][@"AbstractText"][@"text"];
                    CurrentAbstract = [CurrentAbstract stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    
                    if(([CurrentAbstract length] > 2) && (![CurrentAbstract isEqual:@"(null)"]))
                    {
                        NSString * AbstractQuery = [NSString stringWithFormat:@"(NULL,'%@','%@')",PMID,CurrentAbstract];
                        
                        [AbstractQueries addObject:AbstractQuery];
                    }
                }
                
                
                // process array elements
            } else if ([jso88 isKindOfClass:[NSDictionary class]]) {
                NSString * AbstractText = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"Abstract"][@"AbstractText"][@"text"]];
                AbstractText = [AbstractText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                if(([AbstractText length] > 2) && (![AbstractText isEqual:@"(null)"]))
                {
                    NSString * AbstractQuery = [NSString stringWithFormat:@"(NULL,'%@','%@')",PMID,AbstractText];
                    
                    [AbstractQueries addObject:AbstractQuery];
                }
                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                NSLog(@"Something else?!?: %@", jso99);
            }

            
            //End Abstracts


            ArticleTitle = [ArticleTitle stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            PMID = [PMID stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            DateCreated = [DateCreated stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            DateCompleted = [DateCompleted stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            DateRevised = [DateRevised stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            Volume = [Volume stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            PublicationDate = [PublicationDate stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            JournalTitle = [JournalTitle stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            ISOAbbreviation = [ISOAbbreviation stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            Language = [Language stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            GeneralNote = [GeneralNote stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
           // AbstractText = [AbstractText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];


            
            id jso = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"KeywordList"];
            if (jso == nil) {
                // Error.  You should probably have passed an NSError ** as the error
                // argument so you could log it.
            } else if ([jso isKindOfClass:[NSArray class]]) {
                
                for(int j=0;j<[jso count];j++)
                {
                    NSArray *ArrayOfKeywords = jso[j][@"Keyword"];
                
                    //NSLog(@"Array of keywords: %@", ArrayOfKeywords);
                    
                    id jso1 = ArrayOfKeywords;
                    
                    if (jso1 == nil) {
                        // Error.  You should probably have passed an NSError ** as the error
                        // argument so you could log it.
                    } else if ([jso1 isKindOfClass:[NSArray class]]) {
                        for(int e=0; e<[ArrayOfKeywords count];e++)
                        {
                            NSString * CurrentKeyword = [[ArrayOfKeywords objectAtIndex:e] objectForKey:@"text"];
                            CurrentKeyword = [CurrentKeyword stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                            NSString * MajorSwitch = [[ArrayOfKeywords objectAtIndex:e] objectForKey:@"MajorTopicYN"];
                            MajorSwitch = [MajorSwitch stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                           
                            
                            NSString * KeywordQuery = [NSString stringWithFormat:@"(NULL,'%@','%@','%@')", PMID, MajorSwitch, CurrentKeyword];
                            
                            [KeywordQueries addObject:KeywordQuery];
                        }
                        
                    } else if ([jso1 isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = jso1;
                        
                        //NSLog(@"Dictionary: %@", dict);
                        NSString * CurrentKeyword = [dict objectForKey:@"text"];
                        CurrentKeyword = [CurrentKeyword stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        NSString * MajorSwitch = [dict objectForKey:@"MajorTopicYN"];
                        MajorSwitch = [MajorSwitch stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        NSString * KeywordQuery = [NSString stringWithFormat:@"(NULL,'%@','%@','%@')", PMID, MajorSwitch, CurrentKeyword];
                        
                        [KeywordQueries addObject:KeywordQuery];
                        // process dictionary elements
                    } else {
                        // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                        NSLog(@"Something else?!?: %@", jso1);
                    }
                    
                    

                }
                // process array elements
            } else if ([jso isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = jso;
                
                //NSLog(@"Dictionary: %@", dict);
                
                NSArray *ArrayOfKeywords = dict[@"Keyword"];
                
                //NSLog(@"Array of keywords: %@", ArrayOfKeywords);
                
                id jso1 = ArrayOfKeywords;
                
                if (jso1 == nil) {
                    // Error.  You should probably have passed an NSError ** as the error
                    // argument so you could log it.
                } else if ([jso1 isKindOfClass:[NSArray class]]) {
                    for(int e=0; e<[ArrayOfKeywords count];e++)
                    {
                        NSString * CurrentKeyword = [[ArrayOfKeywords objectAtIndex:e] objectForKey:@"text"];
                        CurrentKeyword = [CurrentKeyword stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        NSString * MajorSwitch = [[ArrayOfKeywords objectAtIndex:e] objectForKey:@"MajorTopicYN"];
                        MajorSwitch = [MajorSwitch stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        NSString * KeywordQuery = [NSString stringWithFormat:@"(NULL,'%@','%@','%@')", PMID, MajorSwitch, CurrentKeyword];
                        
                        [KeywordQueries addObject:KeywordQuery];
                    }
                    
                } else if ([jso1 isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = jso1;
                    
                    //NSLog(@"Dictionary: %@", dict);
                    NSString * CurrentKeyword = [dict objectForKey:@"text"];
                    CurrentKeyword = [CurrentKeyword stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    NSString * MajorSwitch = [dict objectForKey:@"MajorTopicYN"];
                    MajorSwitch = [MajorSwitch stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    NSString * KeywordQuery = [NSString stringWithFormat:@"(NULL,'%@','%@','%@')", PMID, MajorSwitch, CurrentKeyword];
                    
                    [KeywordQueries addObject:KeywordQuery];
                    // process dictionary elements
                } else {
                    // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                    NSLog(@"Something else?!?: %@", jso1);
                }

                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                NSLog(@"Something else?!?: %@", jso);
            }
            
            
            
            id jso1 = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"MeshHeadingList"][@"MeshHeading"];
            
            if (jso1 == nil) {
                // Error.  You should probably have passed an NSError ** as the error
                // argument so you could log it.
            } else if ([jso1 isKindOfClass:[NSArray class]]) {
                for(int y=0; y<[jso1 count]; y++)
                {
                    NSDictionary * CurrentMeshHeading = [[jso1 objectAtIndex:y] objectForKey:@"DescriptorName"];
                    NSString * MajorTopicFlag = [CurrentMeshHeading objectForKey:@"MajorTopicYN"];
                    NSString * UI = [CurrentMeshHeading objectForKey:@"UI"];
                    UI = [UI stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    
                    NSString * TextData = [CurrentMeshHeading objectForKey:@"text"];
                    TextData = [TextData stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    
                    NSString * Query = [NSString stringWithFormat:@"(NULL,'%@','%@','%@','%@')", PMID, MajorTopicFlag, UI,TextData];
                    
                    [MeshHeadingQueries addObject:Query];
                    
                    // NSString * CurrentMeshHeadingText = [[MeshHeadings objectAtIndex:y] objectForKey:@"text"];
                }
            } else if ([jso1 isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = jso1;
                
                NSDictionary * CurrentMeshHeading = [dict objectForKey:@"DescriptorName"];
                NSString * MajorTopicFlag = [CurrentMeshHeading objectForKey:@"MajorTopicYN"];
                NSString * UI = [CurrentMeshHeading objectForKey:@"UI"];
                UI = [UI stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                NSString * TextData = [CurrentMeshHeading objectForKey:@"text"];
                TextData = [TextData stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                NSString * Query = [NSString stringWithFormat:@"(NULL,'%@','%@','%@','%@')", PMID, MajorTopicFlag, UI,TextData];
                
                [MeshHeadingQueries addObject:Query];

                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                NSLog(@"Something else?!?: %@", jso1);
            }
            
            /*if(([AbstractText length] > 2) && (![AbstractText isEqual:@"(null)"]))
            {
                NSString * AbstractQuery = [NSString stringWithFormat:@"(NULL,'%@','%@')",PMID,AbstractText];
                
                [AbstractQueries addObject:AbstractQuery];
            }*/
            
            NSString * ArticleInsertQuery = [NSString stringWithFormat:@"(NULL,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",PMID,DateCreated,DateCompleted,DateRevised,Volume,PublicationDate,ArticleTitle,ISOAbbreviation,JournalTitle,Language,GeneralNote];
            
            [ArticleQueries addObject:ArticleInsertQuery];
            
        }
        
        // NSString * AbstractQuery = [NSString stringWithFormat:@"INSERT INTO `Abstracts` (`id`,`PMID`,`Abstract`) VALUES (NULL,'%@','%@');",PMID,AbstractText];
        
        if([AbstractQueries count] > 0)
        {
        
            NSMutableString * AbstractQuery = [NSMutableString stringWithFormat:@"INSERT INTO `Abstracts` (`id`,`PMID`,`Abstract`) VALUES "];

            
            for(int f=0;f<[AbstractQueries count]; f++)
            {
                NSString * currentItem = [AbstractQueries objectAtIndex:f];
                currentItem = [currentItem stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [AbstractQuery appendString:currentItem];
                [AbstractQuery appendString:@","];
            }
            
            
            NSString *AbstractQuery1 = [AbstractQuery substringToIndex:[AbstractQuery length]-1];
            AbstractQuery1 = [AbstractQuery1 stringByAppendingString:@";"];
            
            AbstractQuery1 = [AbstractQuery1 stringByReplacingOccurrencesOfString:@"'\'" withString:@"''"];

            
            [ArrayOfQueries addObject:AbstractQuery1];
        
        }
        
        
        if([KeywordQueries count] > 0)
        {
            NSMutableString * KeywordInsertQuery = [NSMutableString stringWithFormat:@"INSERT INTO `Keywords` (`id`, `PMID`, `MajorTopic`, `Keyword`) VALUES "];
            
            for(int f=0;f<[KeywordQueries count]; f++)
            {
                NSString * currentItem = [KeywordQueries objectAtIndex:f];
                currentItem = [currentItem stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [KeywordInsertQuery appendString:currentItem];
                [KeywordInsertQuery appendString:@","];
            }
            
            NSString *KeywordInsertQuery1 = [KeywordInsertQuery substringToIndex:[KeywordInsertQuery length]-1];
            KeywordInsertQuery1 = [KeywordInsertQuery1 stringByAppendingString:@";"];
            
            KeywordInsertQuery1 = [KeywordInsertQuery1 stringByReplacingOccurrencesOfString:@"'\'" withString:@"''"];
            
            [ArrayOfQueries addObject:KeywordInsertQuery1];
            
        }
        
        if([ArticleQueries count] > 0)
        {
            NSMutableString * ArticleInsertQuery = [NSMutableString stringWithFormat:@"INSERT INTO `ArticleData` (`id`,`PMID`,`DateCreated`,`DateCompleted`,`DateRevised`,`Volume`,`PublicationDate`,`ArticleTitle`,`ISOAbbreviation`,`JournalTitle`,`Language`,`GeneralNote` ) VALUES "];
            
            for(int f=0;f<[ArticleQueries count]; f++)
            {
                NSString * currentItem = [ArticleQueries objectAtIndex:f];
                currentItem = [currentItem stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [ArticleInsertQuery appendString:currentItem];
                [ArticleInsertQuery appendString:@","];
            }
            
            NSString *ArticleInsertQuery1 = [ArticleInsertQuery substringToIndex:[ArticleInsertQuery length]-1];
            ArticleInsertQuery1 = [ArticleInsertQuery1 stringByAppendingString:@";"];
            
            ArticleInsertQuery1 = [ArticleInsertQuery1 stringByReplacingOccurrencesOfString:@"'\'" withString:@"''"];
            
            [ArrayOfQueries addObject:ArticleInsertQuery1];
        }
        
        if([MeshHeadingQueries count] > 0)
        {
        
            NSMutableString * MeshHeadingQuery = [NSMutableString stringWithFormat:@"INSERT INTO `MeshHeadings` (`id`, `PMID`, `MajorTopic`, `UI`, `Heading`) VALUES "];
            //NSString * MeshHeadingQuery = [NSString stringWithFormat:];

            for(int h=0;h<[MeshHeadingQueries count]; h++)
            {
                NSString * currentItem = [MeshHeadingQueries objectAtIndex:h];
                currentItem = [currentItem stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                if([currentItem length] > 1)
                {
                    [MeshHeadingQuery appendString:currentItem];
                    [MeshHeadingQuery appendString:@","];
                    //MeshHeadingQuery = [MeshHeadingQuery stringByAppendingString:];
                    //MeshHeadingQuery = [MeshHeadingQuery stringByAppendingString:@","];
                }
                
            }
            
            NSString *MeshHeadingQuery1 = [MeshHeadingQuery substringToIndex:[MeshHeadingQuery length]-1];
            
            MeshHeadingQuery1 = [MeshHeadingQuery1 stringByAppendingString:@";"];
            
            MeshHeadingQuery1 = [MeshHeadingQuery1 stringByReplacingOccurrencesOfString:@"'\'" withString:@"''"];

            
            [ArrayOfQueries addObject:MeshHeadingQuery1];

        }
        
        //NSLog(@"Queries: %@", ArrayOfQueries);
        
        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@-%i.txt",OutputDirectory,FileNameWithoutExt,p] contents:nil attributes:nil];
        
        for(int x=0; x<[ArrayOfQueries count]; x++)
        {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithFormat:@"%@/%@-%i.txt",OutputDirectory,FileNameWithoutExt,p]];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[[ArrayOfQueries objectAtIndex:x] dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
            
        }
        NSError * err4;
        
        [[NSFileManager defaultManager] removeItemAtPath:toPath1 error:&err4];
        [[NSFileManager defaultManager] removeItemAtPath:Filepath error:&err4];

        if(err4)
        {
            NSLog(@"Err: %@", err4);
        }
        
        NSLog(@"Input: %@",[NSString stringWithFormat:@"%@",Filepath]);
        NSLog(@"Output: %@",[NSString stringWithFormat:@"%@/%@-%i.txt",OutputDirectory,FileNameWithoutExt,p]);
        
        xmlDictionary = nil;
        ArrayOfQueries = nil;
        fileContents = nil;
        }
    }
}

@end
