//
//  WBWebViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/30.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+Frame.h"

@interface WBWebViewController () <WKNavigationDelegate>
{
    NSURL *_URL;
    WKWebView *_webView;
    UIProgressView *_progressView;
}
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
    
    self.navigationItem.title = @"Loading...";
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 1.0f)];
    [_progressView setTintColor:[UIColor orangeColor]];
    [self.view addSubview:_progressView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];
    [_webView loadRequest:request];
}

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.navigationItem.title = webView.title;
    [_progressView setProgress:0 animated:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progressView.hidden = _webView.estimatedProgress == 1.0f;
        [_progressView setProgress:_webView.estimatedProgress animated:YES];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
