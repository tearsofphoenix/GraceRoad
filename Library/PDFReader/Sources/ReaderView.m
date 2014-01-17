//
//  ReaderView.m
//  PDFReader
//
//  Created by Lei on 14-1-17.
//
//

#import "ReaderView.h"
#import "ReaderDocument.h"
#import "ReaderThumbCache.h"
#import "ReaderContentView.h"


#define PAGING_VIEWS 3

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 44.0f
#define PAGEBAR_HEIGHT 48.0f

#define TAP_AREA_SIZE 48.0f

@interface ReaderView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, ReaderContentViewDelegate>
{
    NSMutableDictionary *_contentViews;
    UIScrollView *_theScrollView;
    NSInteger _currentPage;
}

@property (nonatomic, retain) ReaderDocument *document;
@property (nonatomic, retain) NSDate *lastHideTime;

@end

@implementation ReaderView

- (id)initWithDocument: (ReaderDocument *)document
{
    self = [super init];
    if (self)
    {
        [document updateProperties];
        
        [self setDocument: document];
        
        // Touch the document thumb cache directory
        //
        [ReaderThumbCache touchThumbCacheWithGUID: [document guid]];
        
        assert(document != nil); // Must have a valid ReaderDocument
        
        [self setBackgroundColor: [UIColor grayColor]]; // Neutral gray
        
        CGRect scrollViewRect = self.bounds;
        
        _theScrollView = [[UIScrollView alloc] initWithFrame: scrollViewRect]; // UIScrollView
        _theScrollView.autoresizesSubviews = NO;
        _theScrollView.contentMode = UIViewContentModeRedraw;
        _theScrollView.showsHorizontalScrollIndicator = NO;
        _theScrollView.showsVerticalScrollIndicator = NO;
        _theScrollView.scrollsToTop = NO;
        _theScrollView.delaysContentTouches = NO;
        _theScrollView.pagingEnabled = YES;
        _theScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                           | UIViewAutoresizingFlexibleHeight);
        _theScrollView.backgroundColor = [UIColor clearColor];
        _theScrollView.delegate = self;
        
        [self addSubview: _theScrollView];
        
        UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                       action: @selector(handleSingleTap:)];
        singleTapOne.numberOfTouchesRequired = 1;
        singleTapOne.numberOfTapsRequired = 1;
        singleTapOne.delegate = self;
        [self addGestureRecognizer: singleTapOne];
        
        UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                       action: @selector(handleDoubleTap:)];
        doubleTapOne.numberOfTouchesRequired = 1;
        doubleTapOne.numberOfTapsRequired = 2;
        doubleTapOne.delegate = self;
        
        [self addGestureRecognizer: doubleTapOne];
        
        UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                       action: @selector(handleDoubleTap:)];
        
        doubleTapTwo.numberOfTouchesRequired = 2;
        doubleTapTwo.numberOfTapsRequired = 2;
        doubleTapTwo.delegate = self;
        
        [self addGestureRecognizer: doubleTapTwo];
        
        [singleTapOne requireGestureRecognizerToFail: doubleTapOne]; // Single tap requires double tap to fail
        
        _contentViews = [NSMutableDictionary new];
        [self setLastHideTime: [NSDate date]];
    }
    
    return self;
}

- (void)dealloc
{
    [self setDocument: nil];
    _contentViews = nil;
    [self setLastHideTime: nil];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_theScrollView setFrame: [self bounds]];
    
    if (_theScrollView)
    {
        [self updateScrollViewContentViews];
        [self showDocument: nil];
    }
}

- (void)contentView: (ReaderContentView *)contentView
       touchesBegan: (NSSet *)touches
{
    
}

- (void)updateScrollViewContentSize
{
	NSInteger count = [[_document pageCount] integerValue];
    
	if (count > PAGING_VIEWS)
    {
        count = PAGING_VIEWS; // Limit
    }
    
	CGFloat contentHeight = [_theScrollView bounds].size.height;
    
	CGFloat contentWidth = ([_theScrollView bounds].size.width * count);
    
	[_theScrollView setContentSize: CGSizeMake(contentWidth, contentHeight)];
}

- (void)updateScrollViewContentViews
{
	[self updateScrollViewContentSize]; // Update the content size
    
	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set
    
	[_contentViews enumerateKeysAndObjectsUsingBlock: (^(id key, ReaderContentView *contentView, BOOL *stop)
                                                       {
                                                           [pageSet addIndex: [contentView tag]];
                                                       })];
    
	__block CGRect viewRect = CGRectZero;
    viewRect.size = [_theScrollView bounds].size;
    
	__block CGPoint contentOffset = CGPointZero;
    NSInteger page = [[_document pageNumber] integerValue];
    
	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
     (^(NSUInteger number, BOOL *stop)
     {
         NSNumber *key = @(number); // # key
         
         ReaderContentView *contentView = _contentViews[key];
         
         contentView.frame = viewRect;
         if (page == number)
         {
             contentOffset = viewRect.origin;
         }
         
         viewRect.origin.x += viewRect.size.width; // Next view frame position
     })];
    
	if (CGPointEqualToPoint([_theScrollView contentOffset], contentOffset) == false)
	{
		[_theScrollView setContentOffset: contentOffset]; // Update content offset
	}
}

- (void)showDocument:(id)object
{
	[self updateScrollViewContentSize]; // Set content size
    
	[self showDocumentPage: [[_document pageNumber] integerValue]];
    
	[_document setLastOpen: [NSDate date]]; // Update last opened date
    
	//isVisible = YES; // iOS present modal bodge
}

- (void)showDocumentPage:(NSInteger)page
{
	if (page != _currentPage) // Only if different
	{
		NSInteger minValue;
        NSInteger maxValue;
		NSInteger maxPage = [[_document pageCount] integerValue];
		NSInteger minPage = 1;
        
		if ((page < minPage) || (page > maxPage)) return;
        
		if (maxPage <= PAGING_VIEWS) // Few pages
		{
			minValue = minPage;
			maxValue = maxPage;
		}
		else // Handle more pages
		{
			minValue = (page - 1);
			maxValue = (page + 1);
            
			if (minValue < minPage)
            {minValue++; maxValue++;}
			else
				if (maxValue > maxPage)
                {minValue--; maxValue--;}
		}
        
		NSMutableIndexSet *newPageSet = [NSMutableIndexSet new];
        
		NSMutableDictionary *unusedViews = [_contentViews mutableCopy];
        
		CGRect viewRect = CGRectZero; viewRect.size = [_theScrollView bounds].size;
        
		for (NSInteger number = minValue; number <= maxValue; number++)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key
            
			ReaderContentView *contentView = _contentViews[key];
            
			if (contentView == nil) // Create a brand new document content view
			{
				NSURL *fileURL = [_document fileURL];
                NSString *phrase = [_document password]; // Document properties
                
				contentView = [[ReaderContentView alloc] initWithFrame: viewRect
                                                               fileURL: fileURL
                                                                  page: number
                                                              password: phrase];
                
				[_theScrollView addSubview: contentView];
                [_contentViews setObject: contentView
                                  forKey: key];
                
				contentView.message = self;
                [newPageSet addIndex: number];
                
			}else // Reposition the existing content view
			{
				contentView.frame = viewRect; [contentView zoomReset];
                
				[unusedViews removeObjectForKey:key];
			}
            
			viewRect.origin.x += viewRect.size.width;
		}
        
		[unusedViews enumerateKeysAndObjectsUsingBlock: // Remove unused views
         (^(id key, id object, BOOL *stop)
          {
              [_contentViews removeObjectForKey: key];
              
              ReaderContentView *contentView = object;
              
              [contentView removeFromSuperview];
          })];
        
		unusedViews = nil; // Release unused views
        
		CGFloat viewWidthX1 = viewRect.size.width;
		CGFloat viewWidthX2 = (viewWidthX1 * 2.0f);
        
		CGPoint contentOffset = CGPointZero;
        
		if (maxPage >= PAGING_VIEWS)
		{
			if (page == maxPage)
				contentOffset.x = viewWidthX2;
			else
				if (page != minPage)
					contentOffset.x = viewWidthX1;
		}
		else
			if (page == (PAGING_VIEWS - 1))
				contentOffset.x = viewWidthX1;
        
		if (CGPointEqualToPoint(_theScrollView.contentOffset, contentOffset) == false)
		{
			_theScrollView.contentOffset = contentOffset; // Update content offset
		}
        
		if ([[_document pageNumber] integerValue] != page) // Only if different
		{
			[_document setPageNumber: @(page)]; // Update page number
		}
        
		NSURL *fileURL = [_document fileURL];
        NSString *phrase = [_document password];
        NSString *guid = [_document guid];
        
		if ([newPageSet containsIndex:page] == YES) // Preview visible page first
		{
			NSNumber *key = @(page); // # key
            
			ReaderContentView *targetView = _contentViews[key];
            
			[targetView showPageThumb: fileURL
                                 page: page
                             password: phrase
                                 guid: guid];
            
			[newPageSet removeIndex:page]; // Remove visible page from set
		}
        
		[newPageSet enumerateIndexesWithOptions: NSEnumerationReverse
                                     usingBlock:  (^(NSUInteger number, BOOL *stop)
                                                   {
                                                       ReaderContentView *targetView = _contentViews[@(number)];
                                                       
                                                       [targetView showPageThumb: fileURL
                                                                            page: number
                                                                        password: phrase
                                                                            guid: guid];
                                                   })];
        
		newPageSet = nil; // Release new page set
        
		_currentPage = page; // Track current page number
	}
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
	__block NSInteger page = 0;
    
	CGFloat contentOffsetX = [scrollView contentOffset].x;
    
	[_contentViews enumerateKeysAndObjectsUsingBlock: (^(id key, id object, BOOL *stop)
                                                       {
                                                           ReaderContentView *contentView = object;
                                                           
                                                           if (contentView.frame.origin.x == contentOffsetX)
                                                           {
                                                               page = contentView.tag;
                                                               *stop = YES;
                                                           }
                                                       })];
    
	if (page != 0)
    {
        [self showDocumentPage: page]; // Show the page
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self showDocumentPage: [_theScrollView tag]]; // Show page
    
	[_theScrollView setTag: 0]; // Clear page number tag
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([touch.view isKindOfClass:[UIScrollView class]]) return YES;
    
	return NO;
}

#pragma mark UIGestureRecognizer action methods

- (void)decrementPageNumber
{
	if (_theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [[_document pageNumber] integerValue];
		NSInteger maxPage = [[_document pageCount] integerValue];
		NSInteger minPage = 1; // Minimum
        
		if ((maxPage > minPage) && (page != minPage))
		{
			CGPoint contentOffset = [_theScrollView contentOffset];
            
			contentOffset.x -= [_theScrollView bounds].size.width; // -= 1
            
			[_theScrollView setContentOffset: contentOffset
                                    animated: YES];
            
			[_theScrollView setTag: (page - 1)]; // Decrement page number
		}
	}
}

- (void)incrementPageNumber
{
	if ([_theScrollView tag] == 0) // Scroll view did end
	{
		NSInteger page = [[_document pageNumber] integerValue];
		NSInteger maxPage = [[_document pageCount] integerValue];
		NSInteger minPage = 1; // Minimum
        
		if ((maxPage > minPage) && (page != maxPage))
		{
			CGPoint contentOffset = [_theScrollView contentOffset];
            
			contentOffset.x += [_theScrollView bounds].size.width; // += 1
            
			[_theScrollView setContentOffset: contentOffset
                                    animated: YES];
            
			[_theScrollView setTag: (page + 1)]; // Increment page number
		}
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view];
        
		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area
        
		if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
		{
			NSInteger page = [_document.pageNumber integerValue]; // Current page #
            
			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
            
			ReaderContentView *targetView = _contentViews[key];
            
			id target = [targetView processSingleTap:recognizer]; // Target
            
			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					NSURL *url = (NSURL *)target; // Cast to a NSURL object
                    
					if (url.scheme == nil) // Handle a missing URL scheme
					{
						NSString *www = url.absoluteString; // Get URL string
                        
						if ([www hasPrefix: @"www"] == YES) // Check for 'www' prefix
						{
							NSString *http = [NSString stringWithFormat:@"http://%@", www];
                            
							url = [NSURL URLWithString:http]; // Proper http-based URL
						}
					}
                    
					if ([[UIApplication sharedApplication] openURL:url] == NO)
					{
#ifdef DEBUG
                        NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
#endif
					}
				}
				else // Not a URL, so check for other possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger value = [target integerValue]; // Number
                        
						[self showDocumentPage:value]; // Show the page
					}
				}
			}
            
			return;
		}
        
		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}
        
		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;
        
		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber]; return;
		}
	}
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view];
        
		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			NSInteger page = [[_document pageNumber] integerValue]; // Current page #
            
			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
            
			ReaderContentView *targetView = _contentViews[key];
            
			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
					[targetView zoomIncrement]; break;
				}
                    
				case 2: // Two finger double tap: zoom --
				{
					[targetView zoomDecrement]; break;
				}
			}
            
			return;
		}
        
		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}
        
		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;
        
		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber]; return;
		}
	}
}

@end
