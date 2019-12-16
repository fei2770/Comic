//
//  BaseWebViewController.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>

#define kEstimatedProgress  @"estimatedProgress"

@interface BaseWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic ,strong) WKWebView *rootWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = self.webTitle;
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.rootWebView];
       
    MyLog(@"网页地址：%@",self.urlStr);
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
    [self.rootWebView loadRequest:req];
}


#pragma mark KVO
#pragma mark 监听方法中获取网页加载的进度
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        self.progressView.progress = self.rootWebView.estimatedProgress;
        if (self.progressView.progress == 1.0) {
            kSelfWeak;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -- WKNavigationDelegate
#pragma mark 开始加载网页
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    MyLog(@"开始加载网页  didStartProvisionalNavigation");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

#pragma mark 加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    MyLog(@"网页加载完成 didFinishNavigation");
}


#pragma mark
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *url = navigationAction.request.URL.absoluteString;
    MyLog(@"监听到url：%@",url);
    
    if ([url rangeOfString:@"lookfirst"].location != NSNotFound) {
        
        [self webListenToJumpWithUrl:url];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 监听跳转
-(void)webListenToJumpWithUrl:(NSString *)url{
    
}

#pragma mark -- Getters and Setters
#pragma mark 加载进度条
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 2)];
        _progressView.backgroundColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#FF727A"];
        //设置进度条的高度
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

#pragma mark 网页浏览器
-(WKWebView *)rootWebView{
    if (_rootWebView==nil) {
        _rootWebView=[[WKWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-(isXDevice?24:0))];
        _rootWebView.UIDelegate=self;
        _rootWebView.navigationDelegate = self;
        //添加KVO，监听WKWebView加载进度
        [_rootWebView addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    }
    return _rootWebView;
}

- (void)dealloc {
    [self.rootWebView removeObserver:self forKeyPath:kEstimatedProgress];
}

@end
