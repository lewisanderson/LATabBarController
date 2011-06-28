//
//  LATabBarController.m
//  MrCruncher
//
//  Created by Lewis Anderson on 6/27/11.
//  Copyright 2011 Lewis Anderson. All rights reserved.
//

#import "LATabBarController.h"

@interface LATabBarController ()

- (void)loadTabs;

@end



@implementation LATabBarController

@synthesize viewControllers, tabBar, selectedIndex, selectedViewController, contentView, visible, ignoreNextDelegateCall;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedIndex = 0;
		self.selectedViewController = nil;
		self.ignoreNextDelegateCall = FALSE;
		
		//[[NSNotificationCenter defaultCenter] addObserver:self
		//										 selector:@selector(orientationChanged:)
		//											 name:UIDeviceOrientationDidChangeNotification
		//										   object:nil];
    }
    return self;
}

- (void)dealloc
{
	[viewControllers release];
	[tabBar release];
	[selectedViewController release];
	[contentView release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	if (ignoreNextDelegateCall)
	{
		ignoreNextDelegateCall = FALSE;
		return;
	}
	
	int i = 0, index = -1;
	for (UITabBarItem *option in self.tabBar.items) 
	{
		if (option == item)
		{
			index = i;
			break;
		}
		i++;
	}
	
	if (index < 0)
		return;
	
	if (index != selectedIndex)
		self.selectedIndex = index; // changes to this propogate down to setSelectedViewController
	else
	{
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
		
		/*UIViewController *vc = [self.viewControllers objectAtIndex:index];
		if (self.selectedViewController == vc) {
			if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
				[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
			}
		} else {
			[self setSelectedViewController:vc];
		}*/
	}
	

}

- (void)setSelectedViewController:(UIViewController *)vc {
	
	// update selectedIndex if necessary
	if (selectedIndex >= [viewControllers count] || [viewControllers objectAtIndex:selectedIndex] != vc)
	{
		int i = 0, index = -1;
		for (UIViewController *option in self.viewControllers) 
		{
			if (option == vc)
			{
				index = i;
				break;
			}
			i++;
		}
		
		if (index < 0)
			return;
		
		selectedIndex = index;
	}
	
	
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		[selectedViewController release];
		selectedViewController = [vc retain];
		if (visible) {
			[oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
		
		for (UIView *previousSubview in self.contentView.subviews)
			[previousSubview removeFromSuperview];
		selectedViewController.view.frame = self.contentView.frame;
		[self.contentView addSubview:vc.view];
		
		if (visible) {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
		
		if (self.tabBar.selectedItem != [self.tabBar.items objectAtIndex:self.selectedIndex])
		{
			//ignoreNextDelegateCall = TRUE;
			self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:self.selectedIndex];
		}
	}
}

- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex)
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
}

- (void)loadTabs {
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
	for (UIViewController *vc in self.viewControllers) {
		[tabs addObject:vc.tabBarItem];
	}
	self.tabBar.items = tabs;
	
	if (self.selectedIndex >= 0 && self.selectedIndex < [tabs count])
		self.tabBar.selectedItem = [tabs objectAtIndex:self.selectedIndex];
	
	
	
	
}


- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
		[viewControllers release];
		viewControllers = [array retain];

		if (viewControllers != nil) {
			[self loadTabs];
		}
		
		if (selectedViewController != [viewControllers objectAtIndex:selectedIndex])
			self.selectedIndex = 0;
		
	}
}

#pragma mark - Interface Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

/*- (void)orientationChanged:(NSNotification *)notification
{
	
}*/

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.tabBar = [[[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)] autorelease];
	self.tabBar.delegate = self;
	self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	
	self.contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49)] autorelease];
	self.contentView.backgroundColor = [UIColor clearColor];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	
	[self.view addSubview:contentView];
	[self.view addSubview:tabBar];

	[self loadTabs];
	
	if (selectedViewController == nil)
		selectedViewController = [viewControllers objectAtIndex:0];
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];

}


- (void)viewDidUnload {
	self.tabBar = nil;
	self.contentView = nil;
	self.view = nil;
	
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.selectedViewController viewDidAppear:animated];
	visible = TRUE;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.selectedViewController viewDidDisappear:animated];
	visible = FALSE;
}


@end
