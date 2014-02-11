//
// Created by Martin Weissbach on 17/01/14.
// Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "RandomString.h"

unsigned int random_number(int limit) {
    int divisor = RAND_MAX / (limit + 1);
    unsigned int retval;

    do {
        retval = (unsigned) rand() / divisor;
    } while (retval > limit);

    return retval;
}

@implementation RandomString

static const NSArray *__letterArray = nil;

+ (void)initialize
{
    [super initialize];

    if (__letterArray == nil)
        __letterArray = [NSArray arrayWithObjects:
                @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",
                @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",
                @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
}

+ (NSString *)randomStringWithLength:(NSUInteger)length
{

    NSMutableString *string = [NSMutableString new];
    for (int index = 0; index < length; index++) {
        [string appendString:__letterArray[random_number(__letterArray.count - 1)]]; // random_number is limit inclusive
    }
    return string;
}

+ (NSString *)generatePassword
{
    return [self randomStringWithLength:17];
}
@end