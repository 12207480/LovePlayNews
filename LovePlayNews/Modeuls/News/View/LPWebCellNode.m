//
//  LPWebCellNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPWebCellNode.h"
#import <WebKit/WebKit.h>

@interface LPWebCellNode () <WKNavigationDelegate, UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) WKWebView *wkWebView;

@property (nonatomic,strong) NSURL *URL;

@property (nonatomic,assign) CGFloat webViewHeight;

@end

@implementation LPWebCellNode

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        _URL = URL;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didLoad
{
    [super didLoad];

    [self addWkWebView];
    
    [self loadWebData];
}

- (void)addWkWebView
{
    WKWebView *webView = [[WKWebView alloc]init];
    webView.navigationDelegate = self;
    webView.scrollView.bounces = NO;
    webView.scrollView.scrollEnabled = NO;
    [webView.scrollView setScrollsToTop:NO];
    [self.view addSubview:webView];
    _wkWebView = webView;
}

- (void)loadWebData
{
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:_URL]];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    return CGSizeMake(constrainedSize.width, _webViewHeight);
}

- (void)layout
{
    [super layout];
    
    _wkWebView.frame = CGRectMake(0, 0, self.calculatedSize.width,_webViewHeight);
    _wkWebView.scrollView.scrollEnabled = NO;
    
}

- (void)dealloc{
    _wkWebView.navigationDelegate = nil;
    [_wkWebView loadHTMLString:@"" baseURL:nil];
    _wkWebView = nil;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"document.body.offsetHeight"completionHandler:^(id result,NSError * error) {
        //获取页面高度，并重置webview的frame
        _webViewHeight = [result floatValue];
        NSLog(@"webViewHeight %.f",_webViewHeight);
        [self setNeedsLayout];
    }];
}

@end
