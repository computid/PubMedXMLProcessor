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

-(void)ProcessXMLFile:(NSString *)Directory
{
    
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Users/AdamBradley/Desktop/PubMed/ftp.ncbi.nlm.nih.gov/pubmed/baseline/" error:Nil];
    
    NSArray* TarFiles = [dirs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.xml.gz'"]];
    
    for(int p=0; p<[TarFiles count];p++)
    {
        //NSLog(@"Tarfiles: %@", [TarFiles objectAtIndex:p]);
        
        NSString * Frompath = @"/Users/AdamBradley/Desktop/PubMed/ftp.ncbi.nlm.nih.gov/pubmed/baseline/";
        NSString * Filepath = [Frompath stringByAppendingPathComponent:[TarFiles objectAtIndex:p]];
        
        NSString* toPath = @"/Users/AdamBradley/Desktop/PubMed/ftp.ncbi.nlm.nih.gov/pubmed/baseline/Output/";
        NSString* toPath1 = [toPath stringByAppendingPathComponent:[NSString stringWithFormat:@"testFile-%i.xml",p]];
        NSError * err1;
        [DCTar gzipDecompress:Filepath toPath:toPath1 error:&err1];
        
        NSURL * URL1 = [NSURL fileURLWithPath:Filepath];
        NSURL * URL2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/AdamBradley/Desktop/PubMed/ftp.ncbi.nlm.nih.gov/pubmed/baseline/Done/%@",[TarFiles objectAtIndex:p]]];
        
        NSError * err2;
        [[NSFileManager defaultManager] copyItemAtURL:URL1 toURL:URL2 error:&err2];
        
        //NSLog(@"Error: %@", err2);
        

        
        
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
            
            NSString * GeneralNote = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"GeneralNote"][@"text"]];
            
            
            NSString * AbstractText = [NSString stringWithFormat:@"%@",xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"OtherAbstract"][@"AbstractText"][@"text"]];
            
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
            AbstractText = [AbstractText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            
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
                            NSString * Query = [NSString stringWithFormat:@"INSERT INTO `Keywords` (`id`, `PMID`, `MajorTopic`, `Keyword`) VALUES (NULL,'%@','%@','%@');", PMID, MajorSwitch, CurrentKeyword];
                            
                            [ArrayOfQueries addObject:Query];
                        }
                        
                    } else if ([jso1 isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = jso1;
                        
                        //NSLog(@"Dictionary: %@", dict);
                        NSString * CurrentKeyword = [dict objectForKey:@"text"];
                        CurrentKeyword = [CurrentKeyword stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        NSString * MajorSwitch = [dict objectForKey:@"MajorTopicYN"];
                        MajorSwitch = [MajorSwitch stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        NSString * Query = [NSString stringWithFormat:@"INSERT INTO `Keywords` (`id`, `PMID`, `MajorTopic`, `Keyword`) VALUES (NULL,'%@','%@','%@');", PMID, MajorSwitch, CurrentKeyword];
                        
                        [ArrayOfQueries addObject:Query];
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
                        NSString * Query = [NSString stringWithFormat:@"INSERT INTO `Keywords` (`id`, `PMID`, `MajorTopic`, `Keyword`) VALUES (NULL,'%@','%@','%@');", PMID, MajorSwitch, CurrentKeyword];
                        
                        [ArrayOfQueries addObject:Query];
                    }
                    
                } else if ([jso1 isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = jso1;
                    
                    //NSLog(@"Dictionary: %@", dict);
                    NSString * CurrentKeyword = [dict objectForKey:@"text"];
                    CurrentKeyword = [CurrentKeyword stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    NSString * MajorSwitch = [dict objectForKey:@"MajorTopicYN"];
                    MajorSwitch = [MajorSwitch stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    NSString * Query = [NSString stringWithFormat:@"INSERT INTO `Keywords` (`id`, `PMID`, `MajorTopic`, `Keyword`) VALUES (NULL,'%@','%@','%@');", PMID, MajorSwitch, CurrentKeyword];
                    
                    [ArrayOfQueries addObject:Query];
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
                    
                    NSString * Query = [NSString stringWithFormat:@"INSERT INTO `MeshHeadings` (`id`, `PMID`, `MajorTopic`, `UI`, `Heading`) VALUES (NULL,'%@','%@','%@','%@');", PMID, MajorTopicFlag, UI,TextData];
                    
                    [ArrayOfQueries addObject:Query];
                    
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
                
                NSString * Query = [NSString stringWithFormat:@"INSERT INTO `MeshHeadings` (`id`, `PMID`, `MajorTopic`, `UI`, `Heading`) VALUES (NULL,'%@','%@','%@','%@');", PMID, MajorTopicFlag, UI,TextData];
                
                [ArrayOfQueries addObject:Query];

                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
                NSLog(@"Something else?!?: %@", jso1);
            }

            //NSArray * MeshHeadings = xmlDictionary[@"MedlineCitationSet"][@"MedlineCitation"][i][@"MeshHeadingList"][@"MeshHeading"];
            
        
            /*NSLog(@"ArticleTitle: %@", [NSString stringWithFormat:@"%@",ArticleTitle]);
            NSLog(@"PMID: %@", [NSString stringWithFormat:@"%@",PMID]);
            NSLog(@"DateCreated: %@", [NSString stringWithFormat:@"%@",DateCreated]);
            NSLog(@"DateCompleted: %@", [NSString stringWithFormat:@"%@",DateCompleted]);
            NSLog(@"DateRevised: %@", [NSString stringWithFormat:@"%@",DateRevised]);
            NSLog(@"Volume: %@", [NSString stringWithFormat:@"%@",Volume]);
            NSLog(@"PublicationDate: %@", [NSString stringWithFormat:@"%@",PublicationDate]);
            NSLog(@"JournalTitle: %@", [NSString stringWithFormat:@"%@",JournalTitle]);
            
            NSLog(@"ISOAbbreviation: %@", [NSString stringWithFormat:@"%@",ISOAbbreviation]);
            NSLog(@"Language: %@", [NSString stringWithFormat:@"%@",Language]);
            NSLog(@"GeneralNote: %@", [NSString stringWithFormat:@"%@",GeneralNote]);
            NSLog(@"AbstractText: %@", AbstractText);
            */
            
            
            if(([AbstractText length] > 2) && (![AbstractText isEqual:@"(null)"]))
            {
                NSString * AbstractQuery = [NSString stringWithFormat:@"INSERT INTO `Abstracts` (`id`,`PMID`,`Abstract`) VALUES (NULL,'%@','%@');",PMID,AbstractText];
                
                [ArrayOfQueries addObject:AbstractQuery];
            }
            
            NSString * ArticleInsertQuery = [NSString stringWithFormat:@"INSERT INTO `ArticleData` (`id`,`PMID`,`DateCreated`,`DateCompleted`,`DateRevised`,`Volume`,`PublicationDate`,`ArticleTitle`,`ISOAbbreviation`,`JournalTitle`,`Language`,`GeneralNote` ) VALUES (NULL,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",PMID,DateCreated,DateCompleted,DateRevised,Volume,PublicationDate,ArticleTitle,ISOAbbreviation,JournalTitle,Language,GeneralNote];
            
            [ArrayOfQueries addObject:ArticleInsertQuery];
            
        }
        
        
        //NSLog(@"Queries: %@", ArrayOfQueries);
        
        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"/Users/AdamBradley/Desktop/Queries/Queries-%i.txt",p] contents:nil attributes:nil];
        
        for(int x=0; x<[ArrayOfQueries count]; x++)
        {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithFormat:@"/Users/AdamBradley/Desktop/Queries/Queries-%i.txt",p]];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[[ArrayOfQueries objectAtIndex:x] dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
            
        }
        NSError * err4;
        
        [[NSFileManager defaultManager] removeItemAtPath:toPath1 error:&err4];
        [[NSFileManager defaultManager] removeItemAtPath:Filepath error:&err4];

        NSLog(@"Err: %@", err4);
        
        xmlDictionary = nil;
        ArrayOfQueries = nil;
        fileContents = nil;
    }
}

@end
