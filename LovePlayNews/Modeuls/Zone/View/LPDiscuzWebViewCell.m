//
//  LPDiscuzWebViewCell.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/9.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzWebViewCell.h"
#import "JTSImageViewController.h"
#import "LPWebViewController.h"

@interface LPDiscuzWebViewCell () <UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIWebView *webView;

@property (nonatomic,assign) CGFloat webViewHeight;

@end

@implementation LPDiscuzWebViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = RGB_255(247, 247, 247);
    
    [self addWebView];
    
    [self addWebViewTapGesture];
    
}

#pragma mark - add WebView

- (void)addWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kWebViewTopEdge, kScreenWidth, 1)];
    webView.backgroundColor = RGB_255(247, 247, 247);
    webView.scalesPageToFit = NO;
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    [webView setAutoresizingMask:UIViewAutoresizingNone];
    [webView.scrollView setScrollEnabled:NO];
    [webView.scrollView setScrollsToTop:NO];
    [self.contentView addSubview:webView];
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

#pragma mark - private

- (void)loadWebURL
{
    [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
}

- (void)loadWebHtml
{
    NSURL *cssURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"News" ofType:@"css"]];
    [_webView loadHTMLString:[self handleWithHtmlBody:_htmlBody] baseURL:cssURL];
}

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

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
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
    imageInfo.referenceView = self;
    
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    [imageViewer showFromViewController:self.viewController.navigationController transition:JTSImageViewControllerTransition_FromOffscreen];
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue]+10;
    NSLog(@"webViewHeight %.f",_webViewHeight);
    if (_webViewDidFinishLoad) {
        _webViewDidFinishLoad(_webViewHeight);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _webView.frame = CGRectMake(0, kWebViewTopEdge, CGRectGetWidth(self.frame),_webViewHeight);
}

- (void)dealloc{
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    _webView = nil;
}

@end
