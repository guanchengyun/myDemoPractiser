//
//  ListMenber.m
//  数字健身
//
//  Created by 城云 官 on 14-5-27.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ListMenber.h"

@implementation ListMenber

+(ListMenber *)initWithListmenber:(ListMenber *)listmenberinsert{
    static ListMenber *listmenber = nil;
    if (!listmenber) {
        listmenber = [[ListMenber alloc]init];
        listmenber.ID = listmenberinsert.ID;
        listmenber.rownum = listmenberinsert.rownum;
        listmenber.UI_CreateDate = listmenberinsert.UI_CreateDate;
        listmenber.UI_Face = listmenberinsert.UI_Face;
        listmenber.UI_FirstName = listmenberinsert.UI_FirstName;
    }
   
    return listmenber;
}
@end
