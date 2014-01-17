//
//  OSCEmotionMainView.m
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCEmotionMainView.h"
#import "OSCEmotionEntity.h"

#define LEFT_MARGIN 25
#define TOP_MARGIN 20
#define ROW_COUNT 4
#define COLUMN_COUNT 7
#define SPACE 10
#define FACE_WIDTH 30
#define PAGE_CONTROL_HEIGHT 20

@interface OSCEmotionPageView : UIView <NIPagingScrollViewPage>

@end
@implementation OSCEmotionPageView
@synthesize pageIndex = _pageIndex;

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
}

@end

@interface OSCEmotionMainView()<NIPagingScrollViewDataSource, NIPagingScrollViewDelegate>
@property (nonatomic, strong) NSArray* emotionArray;
@property (nonatomic, strong) NIPagingScrollView* scrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UIImageView* inputBackgroundImageView;
@end

@implementation OSCEmotionMainView

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.emotionArray = [OSCGlobalConfig emotionsArray];
        self.backgroundColor = [UIColor clearColor];
        
        // 键盘表情选择框底图messages_inputview_background.png
        _inputBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds ];
        _inputBackgroundImageView.image = [UIImage nimbusImageNamed:@"emoticon_keyboard_background.png"];
        [self addSubview:_inputBackgroundImageView];
        
        _scrollView = [[NIPagingScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f,//self.bounds.size.height - PAGE_CONTROL_HEIGHT,
                                                                       self.bounds.size.width, PAGE_CONTROL_HEIGHT)];
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_pageControl];
        
        [self.scrollView reloadData];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIScrollViewDataSource

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    int numInPage = ROW_COUNT * COLUMN_COUNT;
	int pageNum = ceil((float)_emotionArray.count / numInPage);
	[_pageControl setNumberOfPages:pageNum];
	return pageNum;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex
{
	int row = ROW_COUNT;
	int column = COLUMN_COUNT;
	
    OSCEmotionPageView *pageView = (OSCEmotionPageView *)[pagingScrollView dequeueReusablePageWithIdentifier:@"OSCEmotionPageView"];
	if (pageView == nil) {
		pageView = [[OSCEmotionPageView alloc] initWithFrame:CGRectMake(0, 0, column * (FACE_WIDTH + SPACE),
                                                             row * (FACE_WIDTH + SPACE))];
		pageView.backgroundColor = [UIColor clearColor];
		
		UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceTaped:)];
		[pageView addGestureRecognizer:gest];
	}
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < column; j++) {
			UIImageView* imgView = (UIImageView*)[pageView viewWithTag:9 + i*column +j];
			if (row*column*pageIndex + i*column + j < _emotionArray.count) {
				OSCEmotionEntity* entity = [_emotionArray objectAtIndex:row*column*pageIndex + i*column + j];
				if (imgView == nil) {
					imgView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(FACE_WIDTH + SPACE) + LEFT_MARGIN,
                                                                            i*(FACE_WIDTH + SPACE) + TOP_MARGIN,
                                                                            FACE_WIDTH, FACE_WIDTH)];
					imgView.tag = 9 + i*column +j;
					imgView.backgroundColor = [UIColor clearColor];
                    imgView.userInteractionEnabled = YES;
					[pageView addSubview:imgView];
				}
				imgView.image = [UIImage imageNamed:entity.imageName];
			}
			else {
				[imgView removeFromSuperview];
			}
		}
	}
	
	return pageView;
}

#pragma mark - NIPagingScrollViewDelegate
- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView
{
    self.pageControl.currentPage = pagingScrollView.centerPageIndex;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pageChanged:(id)sender
{
	[self.scrollView setCenterPageIndex:self.pageControl.currentPage];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)faceTaped:(UIGestureRecognizer*)gest
{
	CGPoint point = [gest locationInView:_scrollView];
	int row = ROW_COUNT;
	int column = COLUMN_COUNT;
	
	int currentRow = floor((point.y - TOP_MARGIN) / (FACE_WIDTH+SPACE));
	int currentcolumn = floor((point.x - LEFT_MARGIN) / (FACE_WIDTH + SPACE));
#ifdef DEBUG
    NSLog(@"row = %d, column = %d", currentRow, currentcolumn);
#endif
	int index = row*column*_scrollView.centerPageIndex + column* currentRow + currentcolumn;
	if (index < _emotionArray.count) {
		if ([self.emotionDelegate respondsToSelector:@selector(emotionSelectedWithCode:)]) {
			[self.emotionDelegate emotionSelectedWithCode:[(OSCEmotionEntity*)[_emotionArray objectAtIndex:index] code]];
		}
	}
}

@end
