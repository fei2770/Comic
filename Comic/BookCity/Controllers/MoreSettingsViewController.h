//
//  MoreSettingsViewController.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SetSuccessBlock)(void);

@interface MoreSettingsViewController : UIViewController

@property (nonatomic, copy ) SetSuccessBlock setBlock;



@end


