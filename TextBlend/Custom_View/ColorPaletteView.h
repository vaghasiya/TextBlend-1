//
//  ColorPaletteView.h
//  TextBlend
//
//  Created by Itesh Dutt on 11/01/16.
//  Copyright © 2016 Wayne Rooney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectColorPaletteView.h"
@class ColorPaletteView;
//Delegate Functions used for handling button actions in the SelectFontsView.

@protocol ColorPaletteViewDelegate <NSObject>

@optional
-(void)setSelectedColor:(UIColor*)color onSelectedView:(ColorPaletteView  *)selected_view onSelectedZticker:(ZDStickerView *)sticker_view;
-(void)color_palette_view_done_check_mark_button_pressed:(UIButton *)sender onSelectedView:(ColorPaletteView *)selected_view;

@end

@interface ColorPaletteView : UIView<PagingCollectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DTColorPickerImageViewDelegate,UIGestureRecognizerDelegate,SelectColorPaletteViewDelegate>{
    
}
@property(nonatomic,strong)PagingCollectionView *custom_collection_view;
@property(nonatomic,strong)id <ColorPaletteViewDelegate> color_palette_view_delegate;
@property(nonatomic,strong)UIView *black_view;
@property(nonatomic,strong)NSMutableArray *color_palette_array;
@property(nonatomic,strong)UIButton *done_check_mark_button;
@property(nonatomic,strong)ZDStickerView *selected_sticker_view;
@property(nonatomic,strong)UIImageView *colorPreviewView;
@property(nonatomic,strong)SelectColorPaletteView *select_color_palette_view;
-(void)initializeArray;


@end
