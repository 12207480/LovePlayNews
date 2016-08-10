//
//  LPWebCellNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPWebCellNode.h"
#import <WebKit/WebKit.h>

@interface LPWebCellNode () <WKNavigationDelegate,UIWebViewDelegate>

@property (nonatomic,strong) WKWebView *wkWebView;

@property (nonatomic,weak) UIWebView *webView;

@property (nonatomic,strong) NSURL *URL;

@property (nonatomic,strong) NSString *htmlBody;

@property (nonatomic,assign) CGFloat webViewHeight;

@end

@implementation LPWebCellNode

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        _URL = URL;
    }
    return self;
}

- (instancetype)initWithHtmlBody:(NSString *)htmlBody
{
    if (self = [super init]) {
        _htmlBody = htmlBody;
    }
    return self;
}

- (void)didLoad
{
    [super didLoad];

    [self addWebView];
    
    if (_htmlBody) {
        [self loadWebHtml];
    }else if (_URL) {
        [self loadWebURL];
    }
}

#pragma mark - UIWebView

- (void)addWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    webView.scalesPageToFit = NO;
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    [webView setAutoresizingMask:UIViewAutoresizingNone];
    [webView.scrollView setScrollEnabled:NO];
    [webView.scrollView setScrollsToTop:NO];
    [self.view addSubview:webView];
    _webView = webView;
}

- (void)loadWebURL
{
    [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
}

- (void)loadWebHtml
{
    NSURL *cssURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"News" ofType:@"css"]];
    [_webView loadHTMLString:[self handleWithHtmlBody:_htmlBody] baseURL:cssURL];
}

#pragma mark - WKWebView

- (void)addWkWebView
{
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    webView.navigationDelegate = self;
    webView.scrollView.bounces = NO;
    [webView.scrollView setScrollsToTop:NO];
    [self.view addSubview:webView];
    _wkWebView = webView;
}

- (void)loadWkWebURL
{
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:_URL]];
}

- (void)loadWkWebHtml
{
    // [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"News" ofType:@"css"]]
    [_wkWebView loadHTMLString:[self handleWithHtmlBody:_htmlBody] baseURL:nil];
}

#pragma mark - private

- (NSString *)handleWithHtmlBody:(NSString *)htmlBody
{
    NSString *html = [htmlBody stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *cssName = @"News.css";
    NSMutableString *htmlString =[[NSMutableString alloc]initWithString:@"<html>"];
    [htmlString appendString:@"<head><meta charset=\"UTF-8\">"];
    [htmlString appendString:@"<link rel =\"stylesheet\" href = \""];
    [htmlString appendString:cssName];
    [htmlString appendString:@"\" type=\"text/css\" />"];
    
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body>"];
    
    [htmlString appendString:html];
    
    [htmlString appendString:@"</body>"];
    
    [htmlString appendString:@"</html>"];
    NSLog(@"%@",htmlString);
    return htmlString;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    return CGSizeMake(constrainedSize.width, _webViewHeight);
}

- (void)layout
{
    [super layout];
    
    if (_wkWebView) {
        _wkWebView.frame = CGRectMake(0, 0, self.calculatedSize.width,_webViewHeight);
        _wkWebView.scrollView.scrollEnabled = NO;
    }
    
    if (_webView) {
        _webView.frame = CGRectMake(0, 0, self.calculatedSize.width,_webViewHeight);
    }
}

- (void)dealloc{
    
    if (_wkWebView) {
        _wkWebView.navigationDelegate = nil;
        [_wkWebView loadHTMLString:@"" baseURL:nil];
        _wkWebView = nil;
    }
    
    if (_webView) {
        _webView.delegate = nil;
        [_webView loadHTMLString:@"" baseURL:nil];
        _webView = nil;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    NSLog(@"webViewHeight %.f",_webViewHeight);
    [self setNeedsLayout];
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
