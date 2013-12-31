//
//  ERConversionBasicConfiguration.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERConversionProcedure.h"

#import <NoahsService/NoahsService.h>

#import "NSArray+NSNull.h"
#import "NSDictionary+NSNull.h"

#import "NSDictionary+CollectionPath.h"
#import "NSMutableDictionary+CollectionPath.h"

#import "NSMutableDictionary+NSNull.h"
#import "NSDictionary+NSNull.h"

#import "NSDate+Formatting.h"

#import "NSString+Transform.h"

#import "NSString+LatinTransliteration.h"

#import "ERUUID.h"

#import "ERFileInput.h"

#import "NSURL+ApplicationURL.h"

#import "NSData+HEXStringDescription.h"

static NSMutableDictionary* ERConversionConfigurationProcessors;

@implementation ERConversionProcedure

@synthesize preprocessorIdentifier = _preprocessorIdentifier;
@synthesize preprocessorParameter = _preprocessorParameter;

@synthesize postprocessorIdentifier = _postprocessorIdentifier;
@synthesize postprocessorParameter = _postprocessorParameter;

@synthesize map = _map;
@synthesize mappingMethod = _mappingMethod;
@synthesize noMatchingResult = _noMatchingResult;

+ (void)load
{
    
    @autoreleasepool
    {
        
        ERConversionConfigurationProcessors = [[NSMutableDictionary alloc] init];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source stringByDeletingPathExtension];
          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.remove-path-extension"];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              NSData *data = [NSPropertyListSerialization dataWithPropertyList: source
                                                                        format: NSPropertyListXMLFormat_v1_0
                                                                       options: 0
                                                                         error: NULL];
              
              if (data)
              {
                  
                  NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
              
                  return [string autorelease];
                  
              }
              else
              {
                  return nil;
              }
              

          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-plist-string"];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              id data = [source dataUsingEncoding: NSUTF8StringEncoding];
              
              NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
              
              id result = [NSPropertyListSerialization propertyListFromData: data
                                                           mutabilityOption: NSPropertyListMutableContainers
                                                                     format: &format
                                                           errorDescription: nil];
              
              return result;
              
          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-object-from-plist-string"];
        
        [self registerConversionConfigurationProcessor:
         (^id (id source, id parameters)
          {
              
              if ([source isKindOfClass: [NSString class]])
              {
                  source = [source dataUsingEncoding: NSUTF8StringEncoding];
              }
              
              return ERSSC(ERCryptographyServiceIdentifier,
                           ERCryptographyServiceDataHashedViaMD5From_Action,
                           @[source]);
          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-md5"];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source hexBytesStringDescription];
          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-hex-string"];
        
        [self registerConversionConfigurationProcessor:
         (^id (id source, id parameters)
          {
              return [[[ERFileInput alloc] initWithURL: source] autorelease];
          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.make-file-input"];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              NSMutableData *data = [NSMutableData data];
              
              NSString *boundary = [source objectOrNilForKey: @"com.eintsoft.gopher-wood.noahs-service.network.request.post.multipart-form-data.boundary-text"];
              if (!boundary)
              {
                  boundary = [@"----------------" stringByAppendingString:
                              [[[ERUUID UUID] stringDescription] stringByReplacingOccurrencesOfString: @"-"
                                                                                           withString: @""]];
              }
              
              NSData *boundaryEdgeData = [@"--" dataUsingEncoding: NSUTF8StringEncoding];
              
              NSData *boundaryData = [boundary dataUsingEncoding: NSUTF8StringEncoding];
              
              NSData *returnData = [@"\r\n" dataUsingEncoding: NSUTF8StringEncoding];
              
              NSData *contentFormDataNameDataBegin = [@"Content-Disposition: form-data; name=\"" dataUsingEncoding: NSUTF8StringEncoding];
              NSData *contentFormDataNameDataEnd = [@"\"" dataUsingEncoding: NSUTF8StringEncoding];
              NSData *contentFormDataFileNameDataBegin = [@"; filename=\"" dataUsingEncoding: NSUTF8StringEncoding];
              NSData *contentFormDataFileNameDataEnd = [@"\"" dataUsingEncoding: NSUTF8StringEncoding];

              NSData *contentTypeData = [@"Content-Type: application/octet-stream" dataUsingEncoding: NSUTF8StringEncoding];

              
              for (NSString *key in source)
              {
                  
                  if (![key isEqualToString: @"com.eintsoft.gopher-wood.noahs-service.network.request.post.multipart-form-data.boundary-text"])
                  {
                      
                      [data appendData: boundaryEdgeData];
                      
                      [data appendData: boundaryData];
                      
                      [data appendData: returnData];
                      
                      [data appendData: contentFormDataNameDataBegin];
                      
                      [data appendData: [key dataUsingEncoding: NSUTF8StringEncoding]];
                      
                      [data appendData: contentFormDataNameDataEnd];
                      
                      id value = [source objectOrNilForKey: key];
                      if ([value isKindOfClass: [ERFileInput class]])
                      {
                          
                          [data appendData: contentFormDataFileNameDataBegin];
                          
                          [data appendData: [[[value URL] lastPathComponent] dataUsingEncoding: NSUTF8StringEncoding]];
                          
                          [data appendData: contentFormDataFileNameDataEnd];
                          
                          [data appendData: returnData];
                          
                          [data appendData: contentTypeData];
                          
                          [data appendData: returnData];
                          
                          [data appendData: returnData];
                          
                          [data appendData: [NSData dataWithContentsOfURL: [NSURL URLForApplicationURL: [value URL]]]];
                          
                          [data appendData: returnData];
                          
                      }
                      else
                      {
                          
                          [data appendData: returnData];
                          
                          [data appendData: returnData];
                          
                          [data appendData: [value dataUsingEncoding: NSUTF8StringEncoding]];
                          
                          [data appendData: returnData];
                          
                      }
                      
                  }
                  
              }
              
              [data appendData: boundaryEdgeData];
              
              [data appendData: boundaryData];
              
              [data appendData: boundaryEdgeData];
              
              [data appendData: returnData];
              
              return data;
          })
                                        withIdentifier: @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-http-multipart-form-data"];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if (source)
              {
                  return [NSDate dateFromString: source];
              }
              else
              {
                  return nil;
              }
              
          })
                                        withIdentifier: ERConversionProcedureParseDateStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if (source && [source length])
              {
                  return [[NSURL URLWithString: source] absoluteURL];
              }
              else
              {
                  return nil;
              }
              
          })
                                        withIdentifier: ERConversionProcedureParseURLStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [parameters convert: source];
          })
                                        withIdentifier: ERConversionProcedureApplyConversionProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if ([NSJSONSerialization isValidJSONObject: source])
              {
                  
                  NSError *error = nil;
                  
                  NSData *data = [NSJSONSerialization dataWithJSONObject: source
                                                                 options: 0
                                                                   error: &error];
                  
                  if (data && (!error))
                  {
                      return [[[NSString alloc] initWithData: data
                                                    encoding: NSUTF8StringEncoding] autorelease];
                  }
                  else
                  {
                      return nil;
                  }

              }
              else
              {
                  return nil;
              }
              
          })
                                        withIdentifier: ERConversionProcedureGenerateJSONStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source autolocalizedLowercaseString];
          })
                                        withIdentifier: ERConversionProcedureLowercaseStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source autolocalizedUppercaseString];
          })
                                        withIdentifier: ERConversionProcedureUppercaseStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              if (source)
              {
                  return [NSMutableArray arrayWithObject: source];
              }
              else
              {
                  return [NSMutableArray array];
              }
          })
                                        withIdentifier: ERConversionProcedureEncloseAsArrayProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              if (source)
              {
                  return [NSMutableSet setWithObject: source];
              }
              else
              {
                  return [NSMutableSet set];
              }
          })
                                        withIdentifier: ERConversionProcedureEncloseAsSetProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              if (source)
              {
                  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          parameters, source, nil];
              }
              else
              {
                  return [NSMutableDictionary dictionary];
              }
          })
                                        withIdentifier: ERConversionProcedureEncloseAsDictionaryProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [NSMutableArray array];
          })
                                        withIdentifier: ERConversionProcedureCreateArrayProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [NSMutableSet set];
          })
                                        withIdentifier: ERConversionProcedureCreateSetProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [NSMutableDictionary dictionary];
          })
                                        withIdentifier: ERConversionProcedureCreateDictionaryProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if (source)
              {
                  return ERSSC(ERLocaleServiceIdentifier,
                               ERLocaleServiceFamilyNameFromCombinedName_Action,
                               [NSArray arrayWithObject: source]);
              }
              else
              {
                  return nil;
              }
              
          })
                                        withIdentifier: ERConversionProcedureExtractFamilyNameProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if (source)
              {
                  return ERSSC(ERLocaleServiceIdentifier,
                               ERLocaleServiceGivenNameFromCombinedName_Action,
                               [NSArray arrayWithObject: source]);
              }
              else
              {
                  return nil;
              }
              
          })
                                        withIdentifier: ERConversionProcedureExtractGivenNameProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if (source)
              {
                  
                  NSString *familyName = ERSSC(ERLocaleServiceIdentifier,
                                               ERLocaleServiceFamilyNameFromCombinedName_Action,
                                               [NSArray arrayWithObject: source]);
                  
                  NSString *givenName = ERSSC(ERLocaleServiceIdentifier,
                                              ERLocaleServiceGivenNameFromCombinedName_Action,
                                              [NSArray arrayWithObject: source]);
                  
                  return ERSSC(ERLocaleServiceIdentifier,
                               ERLocaleServiceNameCombinedFromFamilyName_GivenName_Action,
                               [NSArray arrayWithCount: 2
                                         objectsOrNils:
                                familyName,
                                givenName]);
                  
              }
              else
              {
                  return nil;
              }
              
          })
                                        withIdentifier: ERConversionProcedureReformatNameProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source stringWithFormat: parameters];
          })
                                        withIdentifier: ERConversionProcedureFormatDateStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source stringWithFormat: @"yyyy'-'MM'-'dd HH':'mm':'ss'.'SSS"];
          })
                                        withIdentifier: ERConversionProcedureGenerateDateStringProcessorIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if (!parameters)
              {
                  parameters = [NSArray arrayWithObjects:
                                [NSNumber numberWithBool: YES],
                                [NSNumber numberWithBool: NO],
                                nil];
              }
              
              if (source)
              {
                  
                  if ([source isKindOfClass: [NSNumber class]])
                  {
                      if ([source boolValue])
                      {
                          return [parameters objectAtIndex: 0];
                      }
                      else
                      {
                          return [parameters objectAtIndex: 1];
                      }
                  }
                  else if ([source isKindOfClass: [NSNull class]])
                  {
                      return [parameters objectAtIndex: 1];
                  }
                  else
                  {
                      return [parameters objectAtIndex: 0];
                  }
                  
              }
              else
              {
                  return [parameters objectAtIndex: 1];
              }
              
          })
                                        withIdentifier: ERConversionProcedureIsNotZeroOrNilProcedureIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if (!parameters)
              {
                  parameters = [NSArray arrayWithObjects:
                                [NSNumber numberWithBool: YES],
                                [NSNumber numberWithBool: NO],
                                nil];
              }

              if (source)
              {
                  
                  if ([source isKindOfClass: [NSNumber class]])
                  {
                      if ([source boolValue])
                      {
                          return [parameters objectAtIndex: 0];
                      }
                      else
                      {
                          return [parameters objectAtIndex: 1];
                      }
                  }
                  else if ([source isKindOfClass: [NSNull class]])
                  {
                      return [parameters objectAtIndex: 1];
                  }
                  else if ([source isKindOfClass: [NSString class]])
                  {
                      return [NSNumber numberWithBool: (([source length] > 0) &&
                                                        (![[source uppercaseString] isEqualToString: @"N/A"]))];
                  }
                  else
                  {
                      return [parameters objectAtIndex: 0];
                  }
                  
              }
              else
              {
                  return [parameters objectAtIndex: 1];
              }
              
          })
                                        withIdentifier: ERConversionProcedureIsNotZeroOrNilOrNAStringProcedureIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if (!parameters)
              {
                  parameters = [NSArray arrayWithObjects:
                                [NSNumber numberWithBool: YES],
                                [NSNumber numberWithBool: NO],
                                nil];
              }

              if (source)
              {
                  
                  if ([source isKindOfClass: [NSNumber class]])
                  {
                      if ([source boolValue])
                      {
                          return [parameters objectAtIndex: 0];
                      }
                      else
                      {
                          return [parameters objectAtIndex: 1];
                      }
                  }
                  else if ([source isKindOfClass: [NSNull class]])
                  {
                      return [parameters objectAtIndex: 0];
                  }
                  else
                  {
                      return [parameters objectAtIndex: 1];
                  }
                  
              }
              else
              {
                  return [parameters objectAtIndex: 0];
              }
              
          })
                                        withIdentifier: ERConversionProcedureIsZeroOrNilProcedureIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if (!parameters)
              {
                  parameters = [NSArray arrayWithObjects:
                                [NSNumber numberWithBool: YES],
                                [NSNumber numberWithBool: NO],
                                nil];
              }

              if (source)
              {
                  
                  if ([source isKindOfClass: [NSNumber class]])
                  {
                      if ([source boolValue])
                      {
                          return [parameters objectAtIndex: 0];
                      }
                      else
                      {
                          return [parameters objectAtIndex: 1];
                      }
                  }
                  else if ([source isKindOfClass: [NSNull class]])
                  {
                      return [parameters objectAtIndex: 0];
                  }
                  else if ([source isKindOfClass: [NSString class]])
                  {
                      return [NSNumber numberWithBool: !(([source length] > 0) &&
                                                         (![[source uppercaseString] isEqualToString: @"N/A"]))];
                  }
                  else
                  {
                      return [parameters objectAtIndex: 1];
                  }
                  
              }
              else
              {
                  return [parameters objectAtIndex: 0];
              }
              
          })
                                        withIdentifier: ERConversionProcedureIsZeroOrNilOrNAStringProcedureIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source description];
          })
                                        withIdentifier: ERConversionProcedureGenerateStringProcessorIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source humanReadableDescriptionUsingAbbreviation: [parameters boolValue]];
          })
                                        withIdentifier: ERConversionProcedureGenerateHumanReadableDateDescriptionProcessorIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              
              if (source)
              {
                  return [NSNumber numberWithBool: ![source boolValue]];
              }
              else
              {
                  return [NSNumber numberWithBool: YES];
              }
              
          })
                                        withIdentifier: ERConversionProcedureNotProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              switch ([parameters count])
              {

                  case 0:
                  {
                      return @"";
                  }

                  case 1:
                  {
                      return [parameters objectAtIndex: 0];
                  }

                  case 2:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]]
                              ];
                  }

                  case 3:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]]
                              ];
                  }

                  case 4:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]]
                              ];
                  }

                  case 5:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]]
                              ];
                  }

                  case 6:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]]
                              ];
                  }

                  case 7:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]]
                             ];
                  }

                  case 8:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]]
                              ];
                  }

                  case 9:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]]
                              ];
                  }

                  case 10:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]]
                              ];
                  }

                  case 11:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 10]]
                              ];
                  }

                  case 12:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 10]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 11]]
                              ];
                  }

                  case 13:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 10]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 11]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 12]]
                              ];
                  }

                  case 14:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 10]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 11]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 12]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 13]]
                              ];
                  }

                  case 15:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 10]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 11]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 12]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 13]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 14]]
                              ];
                  }

                  case 16:
                  {
                      return [NSString stringWithFormat:
                              [parameters objectAtIndex: 0],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 1]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 2]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 3]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 4]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 5]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 6]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 7]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 8]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 9]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 10]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 11]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 12]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 13]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 14]],
                              [source objectOrNilAtCollectionPath: [parameters objectAtIndex: 15]]
                              ];
                  }

                  default:
                  {
                      return @"Illegal string format with to many arguments";
                  }

              }

          })
                                        withIdentifier: ERConversionProcedureFormatToStringProcessorIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source latinTransliterationForUsages: parameters];
          })
                                        withIdentifier: ERConversionProcedureGenerateLatinTransliterationProcessorIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              int offset = [[parameters objectAtIndex: 0] integerValue];
              int length = [[parameters objectAtIndex: 1] integerValue];
              if ((offset < 0) || (offset + length > [source length]))
              {
                  return @"";
              }
              else
              {
                  return [source substringWithRange: NSMakeRange(offset, length)];
              }
              
          })
                                        withIdentifier: ERConversionProcedureExtractSubstringProcessorIdentifier];
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if ([parameters isKindOfClass: [NSString class]])
              {

                  id sourceCollectionPath = [source objectOrNilAtCollectionPath: parameters];

                  return [source objectOrNilAtCollectionPath: sourceCollectionPath];

              }
              else
              {

                  id finalSource = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 0]];

                  id result = finalSource;
                  
                  NSInteger looper = 1;
                  while (looper < [parameters count])
                  {

                      id collectionPath = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: looper]];

                      result = [result objectOrNilAtCollectionPath: collectionPath];

                      ++looper;
                  }

                  return result;

              }

          })
                                        withIdentifier: ERConversionProcedureRedirectProcessorIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source autolocalizedStringWithFormatTemplate: parameters];
          })
                                        withIdentifier: ERConversionProcedureFormatDateStringWithTemplateProcessorIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              BOOL first = YES;
              
              NSString *result = @"";
              for (NSString *key in source)
              {

                  NSString *data = [source objectOrNilForKey: key];
                  if (!data)
                  {
                      data = @"";
                  }

                  if (first)
                  {

                      result = [result stringByAppendingFormat:
                                @"?%@=%@",
                                [[key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"],
                                [[data stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"]];

                      first = NO;
                  }
                  else
                  {
                      result = [result stringByAppendingFormat:
                                @"&%@=%@",
                                [[key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"],
                                [[data stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"]];
                  }
                  
              }

              return result;
          })
                                        withIdentifier: ERConversionProcedureGenerateHTTPGetParameterProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source dataUsingEncoding: NSUTF8StringEncoding];
          })
                                        withIdentifier: ERConversionProcedureConvertToDataProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              BOOL first = YES;

              NSString *result = @"";
              for (NSString *key in source)
              {

                  NSString *data = [source objectOrNilForKey: key];
                  if (!data)
                  {
                      data = @"";
                  }

                  if (first)
                  {

                      result = [result stringByAppendingFormat:
                                @"%@=%@",
                                [[key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"],
                                [[data stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"]];

                      first = NO;
                  }
                  else
                  {
                      result = [result stringByAppendingFormat:
                                @"&%@=%@",
                                [[key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"],
                                [[data stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingOccurrencesOfString: @"&" withString: @"%26"]];
                  }

              }
              
              return [result dataUsingEncoding: NSUTF8StringEncoding];
              
          })
                                        withIdentifier: ERConversionProcedureGenerateHTTPGetParameterDataProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              ERConversionConfigurationProcessor redirectProcessor = [ERConversionProcedure processorWithIdentifier: ERConversionProcedureRedirectProcessorIdentifier];

              id finalSource = redirectProcessor(source, [parameters subarrayWithRange: NSMakeRange(2, [parameters count] - 2)]);

              ERConversionConfigurationProcessor processor = [ERConversionProcedure processorWithIdentifier: [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 0]]];

              id processorParameter = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 1]];

              id result = processor(finalSource, processorParameter);
              
              return result;
          })
                                        withIdentifier: ERConversionProcedureProcessProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source stringByReplacingOccurrencesOfString: [parameters objectOrNilAtIndex: 0] withString: [parameters objectOrNilAtIndex: 1]];
          })
                                        withIdentifier: ERConversionProcedureReplaceSubstringProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source componentsJoinedByString: parameters];
          })
                                        withIdentifier: ERConversionProcedureJoinArrayToStringProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [source componentsSeparatedByString: parameters];
          })
                                        withIdentifier: ERConversionProcedureSplitStringToArrayProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if ((!source) && (!parameters))
              {
                  return [NSNumber numberWithBool: YES];
              }
              else
              {
                  return [NSNumber numberWithBool: [source isEqual: parameters]];
              }

          })
                                        withIdentifier: ERConversionProcedureIsEqualProcedureIdentifier];

        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {

              if ((!source) && (!parameters))
              {
                  return [NSNumber numberWithBool: NO];
              }
              else
              {
                  return [NSNumber numberWithBool: ![source isEqual: parameters]];
              }

          })
                                        withIdentifier: ERConversionProcedureIsNotEqualProcedureIdentifier];
        
        [self registerConversionConfigurationProcessor:
         (^id(id source, id parameters)
          {
              return [ERUUID UUIDWithStringDescription: source];
          })
                                        withIdentifier: ERConversionProcedureParseUUIDStringProcessorIdentifier];

    }
    
}

+ (void)registerConversionConfigurationProcessor: (ERConversionConfigurationProcessor)processor
                                  withIdentifier: (NSString *)identifier
{
    [ERConversionConfigurationProcessors setObjectOrNil: [Block_copy(processor) autorelease]
                                                 forKey: identifier];
}

+ (ERConversionConfigurationProcessor)processorWithIdentifier: (NSString *)identifier
{
    return [ERConversionConfigurationProcessors objectOrNilForKey: identifier];
}

- (void)dealloc
{

    [_preprocessorIdentifier release];
    [_preprocessorParameter release];

    [_postprocessorIdentifier release];
    [_postprocessorParameter release];

    [_map release];
    [_mappingMethod release];
    [_noMatchingResult release];

    [super dealloc];
}

- (id)convert: (id)source
         into: (id)target
{

    id value = [self sourceValueDefinedFromSource: source target: target];
    
    if (_preprocessorIdentifier)
    {
        
        ERConversionConfigurationProcessor processor = [ERConversionProcedure processorWithIdentifier: _preprocessorIdentifier];
        if (processor)
        {
            value = processor(value, _preprocessorParameter);
        }
        
    }
    
    if (_map)
    {
        
        if ([_mappingMethod isEqualToString: ERConversionProcedureMappingFirstMatchingInCollectionMethod])
        {
            
            __block id matched = nil;

            __block BOOL couldStop = NO;
            
            [value enumerateObjectsUsingBlock:
             (^(id object, NSUInteger index, BOOL *stop)
              {

                  if (!couldStop)
                  {
                      
                      matched = [_map objectOrNilForKey: object];

                      if (matched)
                      {

                          [matched retain];
                          
                          couldStop = YES;
                      }

                  }
                  
              })];
            
            value = [matched autorelease];
            
        }
        else if ([_mappingMethod isEqualToString: ERConversionProcedureMappingAllElementMatchingInCollectionMethod])
        {

            id matched = nil;
            if ([value isKindOfClass: [NSSet class]])
            {
                matched = [[NSMutableSet alloc] init];
            }
            else if ([value isKindOfClass: [NSArray class]])
            {
                matched = [[NSMutableArray alloc] init];
            }
            else if ([value isKindOfClass: [NSDictionary class]])
            {
                matched = [[NSMutableDictionary alloc] init];
            }
//            id matched = [[[[[value class] alloc] init] autorelease] mutableCopy];
            
            for (id key in value)
            {
                
                id sourceElement = key;
                if ([value isKindOfClass: [NSDictionary class]])
                {
                    sourceElement = [value objectOrNilForKey: key];
                }
                
                if ([[_map allKeys] containsObject: sourceElement])
                {
                    
                    id targetElement = [_map objectOrNilForKey: sourceElement];
                    if (!targetElement)
                    {
                        targetElement = [NSNull null];
                    }
                
                    if ([matched isKindOfClass: [NSDictionary class]])
                    {
                        [matched setObjectOrNil: targetElement
                                         forKey: key];
                    }
                    else
                    {
                        [matched addObject: targetElement];
                    }
                    
                }
                
            }
            
            value = [matched autorelease];
            
        }
        else
        {
            value = [_map objectOrNilForKey: value];
        }
            
        if (!value)
        {
            value = _noMatchingResult;
        }
        
    }
    
    if (_postprocessorIdentifier)
    {
        ERConversionConfigurationProcessor processor = [ERConversionProcedure processorWithIdentifier: _postprocessorIdentifier];
        if (processor)
        {
            value = processor(value, _postprocessorParameter);
        }
    }
    
    return [ERConversionConfiguration fillValue: value
                               atCollectionPath: _targetCollectionPath
                                      forTarget: target
                                 withTargetMode: _targetMode];
    
}

@end
