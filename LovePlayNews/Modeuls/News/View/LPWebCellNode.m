//
//  LPWebCellNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPWebCellNode.h"
#import "JTSImageViewController.h"
#import "LPWebViewController.h"

@interface LPWebCellNode () <UIWebViewDelegate,UIGestureRecognizerDelegate>

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
        _webViewHeight = kScreenHeight-156;
        _htmlBody = htmlBody;
        self.backgroundColor = RGB_255(247, 247, 247);
    }
    return self;
}

- (void)didLoad
{
    [super didLoad];

    [self addWebView];
    
    [self addWebViewTapGesture];
    
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
    webView.backgroundColor = RGB_255(247, 247, 247);
    webView.scalesPageToFit = NO;
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    [webView setAutoresizingMask:UIViewAutoresizingNone];
    [webView.scrollView setScrollEnabled:NO];
    [webView.scrollView setScrollsToTop:NO];
    [self.view addSubview:webView];
    _webView = webView;
}

- (void)addWebViewTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapAction:)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    tap.delaysTouchesBegan = YES;
    [self.webView addGestureRecognizer:tap];
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
    return htmlString;
}

#pragma mark - action
// 点击图片
- (void)webViewTapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint pt = [tap locationInView:self.webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length > 0) {
        NSLog(@"%@",urlToSave);
        [self showImageURL:urlToSave point:pt];
    }
}

- (void)showImageURL:(NSString *)url point:(CGPoint)point{
    if(![url hasPrefix:@"http"])return;
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:url];
    imageInfo.referenceView = self.view;
    
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    [imageViewer showFromViewController:self.viewController.navigationController transition:JTSImageViewControllerTransition_FromOffscreen];
    
}

- (UIViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str =request.URL.absoluteString;
    if (navigationType == UIWebViewNavigationTypeLinkClicked &&[str hasPrefix:@"http"] ) {
        NSLog(@"URL == %@",str);
        LPWebViewController *webViewController = [[LPWebViewController alloc] initWithURLString:str];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        [self.viewController presentViewController:navigationController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue]+12;
    NSLog(@"webViewHeight %.f",_webViewHeight);
    if (_webViewDidFinishLoad) {
        _webViewDidFinishLoad();
    }
    [self setNeedsLayout];
}

#pragma mark - layout

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    return CGSizeMake(constrainedSize.width, _webViewHeight);
}

- (void)layout
{
    [super layout];
    _webView.frame = CGRectMake(0, 0, self.calculatedSize.width,_webViewHeight);
}

- (void)dealloc{
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    _webView = nil;
}

@end
