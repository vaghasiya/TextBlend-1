//
//  ImageEditMainView.m
//  TextBlend
//
//  Created by Wayne Rooney on 06/12/15.
//  Copyright © 2015 Wayne Rooney. All rights reserved.
//

#import "ImageEditMainView.h"
#import "PECropView.h"
#import "UIImage+PECrop.h"

@implementation ImageEditMainView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}


-(void)initializeView
{
    // Call this when user has selected the image.
    if(self.hasSelectedImage)
    {
        self.main_image_view =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.selected_image.size.width, self.selected_image.size.height)];
        self.main_image_view.image=self.selected_image;
        CGRect frameOfImageView = [self areaToDrawImage:self.main_image_view.frame inView:self.frame];
        self.main_image_view.frame = frameOfImageView;
        [self addSubview:self.main_image_view];
        [self draGridLinesWithRowsinArea:frameOfImageView];
    }
    else
    {
        /* Call this when we have to crop and get image */
        //Create image scroll.
        
        
        self.main_image_view  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.selected_image.size.width, self.selected_image.size.height)];
        CGRect rect = [self areaToDrawImage:self.main_image_view.frame inView:self.frame];
        
        self.image_edit_scroll_view =[[UIScrollView alloc]initWithFrame:rect];
        self.image_edit_scroll_view.minimumZoomScale = 1.0;
        self.image_edit_scroll_view.maximumZoomScale = MIN(self.selected_image.size.height/rect.size.height, self.selected_image.size.width/rect.size.width);
        NSLog(@"%f",self.image_edit_scroll_view.maximumZoomScale);
        self.image_edit_scroll_view.delegate = self;
        [self.image_edit_scroll_view.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.image_edit_scroll_view.layer setBorderWidth:1.0];
        //        self.image_edit_scroll_view.contentSize= self.main_image_view.frame.size;
        [self addSubview:self.image_edit_scroll_view];
        
        
        // Create image object and add the same to scroll view.
        [self.main_image_view setImage:self.selected_image];
        [self.image_edit_scroll_view setClipsToBounds:NO];
        [self.main_image_view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        [self.image_edit_scroll_view addSubview:self.main_image_view];
        [self addOverlayViews];
        [self layoutOverlayViewsWithCropRect:rect];
        
    }
}

-(void)addOverlayViews
{
    
    self.topOverlayView = [[UIView alloc] init];
    self.topOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:self.topOverlayView];
    
    self.leftOverlayView = [[UIView alloc] init];
    self.leftOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:self.leftOverlayView];
    
    self.rightOverlayView = [[UIView alloc] init];
    self.rightOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:self.rightOverlayView];
    
    self.bottomOverlayView = [[UIView alloc] init];
    self.bottomOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:self.bottomOverlayView];
    
}
- (void)layoutOverlayViewsWithCropRect:(CGRect)cropRect
{
    self.cropRectView = cropRect;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.topOverlayView.frame = CGRectMake(0.0f,
                                               0.0f,
                                               CGRectGetWidth(self.bounds),
                                               CGRectGetMinY(cropRect));
        self.leftOverlayView.frame = CGRectMake(0.0f,
                                                CGRectGetMinY(cropRect),
                                                CGRectGetMinX(cropRect),
                                                CGRectGetHeight(cropRect));
        self.rightOverlayView.frame = CGRectMake(CGRectGetMaxX(cropRect),
                                                 CGRectGetMinY(cropRect),
                                                 CGRectGetWidth(self.bounds) - CGRectGetMaxX(cropRect),
                                                 CGRectGetHeight(cropRect));
        self.bottomOverlayView.frame = CGRectMake(0.0f,
                                                  CGRectGetMaxY(cropRect),
                                                  CGRectGetWidth(self.bounds),
                                                  CGRectGetHeight(self.bounds) - CGRectGetMaxY(cropRect));
        
        [self.image_edit_scroll_view setFrame:cropRect];
        [self.image_edit_scroll_view setContentSize:self.main_image_view.frame.size];
        [self.image_edit_scroll_view scrollRectToVisible:CGRectMake(
                                                                    (self.image_edit_scroll_view.contentSize.width-self.image_edit_scroll_view.frame.size.width)/2 ,
                                                                    
                                                                    (self.image_edit_scroll_view.contentSize.height-self.image_edit_scroll_view.frame.size.height)/2 ,
                                                                    
                                                                    self.image_edit_scroll_view.frame.size.width,
                                                                    self.image_edit_scroll_view.frame.size.height)
         
                                                animated:NO];
        
    } completion:^(BOOL finished)
     {
     }];
    
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
        return self.main_image_view;
//    return nil;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGSize imgViewSize = self.main_image_view.frame.size;
    CGSize imageSize = self.main_image_view.image.size;
    
    CGSize realImgSize;
    if(imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height) {
        realImgSize = CGSizeMake(imgViewSize.width, imgViewSize.width / imageSize.width * imageSize.height);
    }
    else
    {
        realImgSize = CGSizeMake(imgViewSize.height / imageSize.height * imageSize.width, imgViewSize.height);
    }
    
    CGRect fr = CGRectMake(0, 0, 0, 0);
    fr.size = realImgSize;
    self.main_image_view.frame = fr;
    
    CGSize scrSize = scrollView.frame.size;
    //    float offx = (scrSize.width > realImgSize.width ? (scrSize.width - realImgSize.width) / 2 : 0);
    
    
    
    float offx;
    float offy;
    
    if(scrSize.width > realImgSize.width)
    {
        offx = (scrSize.width - realImgSize.width) / 2;
    }
    else
    {
        offx = (realImgSize.width - scrSize.width) / 2;
    }
    
    if(scrSize.height > realImgSize.height)
    {
        offy = (scrSize.height - realImgSize.height) / 2;
    }
    else
    {
        offy = (realImgSize.height - scrSize.height) / 2;
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    //    scrollView.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
    [scrollView setContentSize:imgViewSize];
    
    [UIView commitAnimations];
}

-(void)draGridLinesWithRowsinArea:(CGRect)drawArea
{
    long rows;
    long coloums;
    
    float rowSpan;
    float colSpan;
    
    if(drawArea.size.height > drawArea.size.width)
    {
        coloums = 4;
        rows = (drawArea.size.height/(drawArea.size.width/coloums));
        colSpan = drawArea.size.width/coloums;
        rowSpan = drawArea.size.height/rows;
    }
    else
    {
        rows = 4;
        coloums = (drawArea.size.width/(drawArea.size.height/rows));
        colSpan = drawArea.size.width/coloums;
        rowSpan = drawArea.size.height/rows;
        
    }
    
    
    self.gridLayer = [CALayer layer];
    for (int i =0 ; i<=rows; i++)
    {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(CGRectGetMinX(drawArea),rowSpan*i+drawArea.origin.y)];
        [linePath addLineToPoint:CGPointMake(CGRectGetMaxX(drawArea),rowSpan*i+drawArea.origin.y)];
        line.path=linePath.CGPath;
        line.fillColor = nil;
        line.opacity = 0.5;
        line.lineWidth = 1.0;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [self.gridLayer addSublayer:line];
    }
    
    for (int j =0 ; j<=coloums; j++)
    {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(colSpan*j+drawArea.origin.x, CGRectGetMinY(drawArea))];
        [linePath addLineToPoint:CGPointMake(colSpan*j
                                             +drawArea.origin.x, CGRectGetMaxY(drawArea))];
        line.path=linePath.CGPath;
        line.fillColor = nil;
        line.opacity = 0.5;
        line.lineWidth = 1.0;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [self.gridLayer addSublayer:line];
    }
    [self.layer addSublayer:self.gridLayer];
    [self.gridLayer setHidden:YES];
}

-(CGRect)areaToDrawImage:(CGRect)childImageView inView:(CGRect)parentView
{
    CGRect rect;
    if(childImageView.size.height > childImageView.size.width)
    {
        // Height > Width
        if(parentView.size.height > childImageView.size.height)
        {
            rect.size.height = childImageView.size.height;
            rect.size.width = rect.size.height * childImageView.size.width/childImageView.size.height;
            rect.origin.x = (parentView.size.width - rect.size.width)/2;
            rect.origin.y = (parentView.size.height - rect.size.height)/2;
        }
        else
        {
            rect.size.height = parentView.size.height;
            rect.size.width = rect.size.height * childImageView.size.width/childImageView.size.height;
            rect.origin.x = (parentView.size.width - rect.size.width)/2;
            rect.origin.y = (parentView.size.height - rect.size.height)/2;
        }
    }
    else
    {
        // Image Width >Image Height
        if(parentView.size.width > childImageView.size.width)
        {
            rect.size.width = childImageView.size.width;
            rect.size.height = rect.size.width * childImageView.size.height/childImageView.size.width;
            rect.origin.x = (parentView.size.width - rect.size.width)/2;
            rect.origin.y = (parentView.size.height - rect.size.height)/2;
        }
        else
        {
            rect.size.width = parentView.size.width;
            rect.size.height = rect.size.width * childImageView.size.height/childImageView.size.width;
            rect.origin.x = (parentView.size.width - rect.size.width)/2;
            rect.origin.y = (parentView.size.height - rect.size.height)/2;
        }
    }
    return rect;
}


@end
