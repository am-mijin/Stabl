//
//  Consts.h
//  Stabl
//
//  Created by Mijin Cho on 25/02/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

#ifndef Consts_h
#define Consts_h
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define Primary UIColorFromRGB(0x601F7B)

#define Secondary UIColorFromRGB(0xAD6BC9)

#define Text_Primary UIColorFromRGB(0x4A4A4A)

#define Text_Secondary UIColorFromRGB(0x999999)

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#endif /* Consts_h */
