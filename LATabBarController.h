//
//  LATabBarController.h
//  MrCruncher
//
//  Created by Lewis Anderson on 6/27/11.
//  Copyright 2011 Lewis Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LATabBarController : UIViewController <UITabBarDelegate> {
    NSArray		*viewControllers;
	UIViewController *selectedViewController;
	UITabBar	*tabBar;
	UIView		*contentView;
	NSUInteger	selectedIndex;
	BOOL		visible;
	BOOL		ignoreNextDelegateCall;
}

@property (nonatomic, retain) 	NSArray		*viewControllers;
@property (nonatomic, retain)	UIViewController *selectedViewController;
@property (nonatomic, retain)	UITabBar	*tabBar;
@property (nonatomic, retain)	UIView		*contentView;
@property (nonatomic)			NSUInteger	selectedIndex;
@property (nonatomic)			BOOL		visible;
@property (nonatomic)			BOOL		ignoreNextDelegateCall;

@end
