//
//  WBWebViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/30.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBWebViewController.h"
#import <WebKit/WebKit.h>

@interface WBWebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WBWebViewController

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        _URL = URL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];
    [_webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.navigationItem.title = webView.title;
}
@end
