//
//  ReadCateCollectionView.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ReadCateCollectionViewDelegate <NSObject>

-(void)readCateCollectionViewDidChooseChannels:(NSMutableArray *)selChannelsArray;

@end

@interface ReadCateCollectionView : UICollectionView

@property (nonatomic,strong) UIColor         *textColor;
@property (nonatomic,strong) NSMutableArray  *channelArray;
@property (nonatomic,strong) NSMutableArray  *selectedChannelIdsArray;
@property (nonatomic, weak ) id<ReadCateCollectionViewDelegate>viewDelegate;

@end


