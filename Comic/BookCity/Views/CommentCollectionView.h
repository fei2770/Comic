//
//  CommentCollectionView.h
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentCollectionView;

@protocol CommentCollectionViewDelegate <NSObject>

-(void)commentCollectionView:(CommentCollectionView *)commentView didDeletePhoto:(NSInteger)index;

@end

@interface CommentCollectionView : UICollectionView

@property (nonatomic,strong) NSMutableArray *photosArray;
@property (nonatomic, weak ) id<CommentCollectionViewDelegate>viewDelegate;

@end


