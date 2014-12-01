//
//  MyInclude.h
//  Kyusu for iOS
//
//  Created by lp6m on 2014/11/25.
//
//

#import <vector>
#import <algorithm>
#import <queue>
#import <stack>
#import <string>
using namespace std;
struct button_set{
    int ldx;//left down x左下
    int ldy;
    int width;
    int height;
    string tag;
    bool on;
};
extern vector<button_set> button_list;

#ifndef Kyusu_for_iOS_MyInclude_h
#define Kyusu_for_iOS_MyInclude_h



#endif
