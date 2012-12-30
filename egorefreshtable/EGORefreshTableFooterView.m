//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Zbigniew Kominek on 3/10/11.
//  Copyright 2011 Zbigniew Kominek. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableFooterView.h"


@implementation EGORefreshTableFooterView

- (void)setup:(CGRect)frame {
    _lastUpdatedLabelFrame = CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f);
    _statusLabelFrame      = CGRectMake(0.0f, 28.0f, self.frame.size.width, 20.0f);
    _arrowImageFrame       = CGRectMake(25.0f, 10.0f, 30.0f, 55.0f);
    _activityViewFrame     = CGRectMake(25.0f, 18.0f, 20.0f, 20.0f);
    
    _arrowPullingTransform = CATransform3DMakeRotation((M_PI / 180.0f) * -360.0f, 0.0f, 0.0f, 1.0f);
    _arrowNormalTransform  = CATransform3DMakeRotation((M_PI / 180.0f) *  180.0f, 0.0f, 0.0f, 1.0f);

    _releaseLabelText = LocalString(@"ego.releaserefresh");
    _pullingLabelText = LocalString(@"ego.pulluptorefresh");
    _loadingLabelText = LocalString(@"ego.loading");
    _lastUpdatedLabelText = LocalString(@"ego.lastupdate");

    _userDefaultsKey = @"EGORefreshTableFooterView_LastRefresh";
}

#pragma mark -
#pragma mark ScrollView Methods

- (float)endOfTableView:(UIScrollView *)scrollView {
    CGFloat tableViewHeight = scrollView.bounds.size.height;
    if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderTableViewHeight:)]) {
        tableViewHeight = [self.delegate egoRefreshTableHeaderTableViewHeight:self];
    }

    return tableViewHeight - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [self.delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
        float endOfTable = [self endOfTableView:scrollView];
		if (_state == EGOOPullRefreshPulling && 
            endOfTable > -65.0f 
            && endOfTable < 0.0f
            && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal &&
                   endOfTable < -65.0f &&
                   !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [self.delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    
    float endOfTable = [self endOfTableView:scrollView];
	if (endOfTable <= - 65.0f && !_loading) {
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[self.delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
    BOOL needLoad = YES;
    if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceNeedLoading:)]){
        needLoad = [self.delegate egoRefreshTableHeaderDataSourceNeedLoading:self];
    }
    if (needLoad){
        [self setState:EGOOPullRefreshNormal];
    }else{
        [self setState:EGOOPullRefreshIdle];        
    }
    [self refreshLastUpdatedDate];
    
    CGFloat tableViewHeight = scrollView.bounds.size.height;
    if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderTableViewHeight:)]) {
        tableViewHeight = [self.delegate egoRefreshTableHeaderTableViewHeight:self];
    }

    CGRect frame = self.frame;
    frame.origin.y = tableViewHeight;
    self.frame = frame;
}


@end
