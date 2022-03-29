//
//  FVMainRequest.m
//  ForVisa
//
//  Created by neilson on 2022-03-28.
//

#import "FVMainRequestManager.h"
#import <WebKit/WebKit.h>

#define mainURL @"https://ais.usvisa-info.com/en-ca/niv/schedule/37859079/appointment"
#define suffix @".json?appointments%5Bexpedite%5D=false"

@interface FVMainRequestManager () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *invisibleWebView;

@property (nonatomic, copy  ) NSDictionary *cityMap;

@property (nonatomic, strong) NSMutableDictionary *resultMap;

@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, assign) NSInteger currentCity;

@property (nonatomic, copy  ) CompletionBlock completionBlock;

@end

@implementation FVMainRequestManager

#pragma mark - override lifecycle

- (instancetype)init {
    if (self = [super init]) {
        self.cityMap = @{
            @89:@"Calgary",
            @90:@"Halifax",
            @91:@"Montréal",
            @92:@"Ottawa",
            @93:@"Québec",
            @94:@"Toronto",
            @95:@"Vancouver"
        };
        self.resultMap = @{}.mutableCopy;
        
        [self _setupWebView];
    }
    return self;
}

#pragma mark - public methods

- (void)startDataRequest:(CompletionBlock)completionBlock {
    
    self.firstLoad = YES;
    self.completionBlock = completionBlock;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:mainURL]];
    [_invisibleWebView loadRequest:request];
}

#pragma mark - private methods

- (void)_setupWebView {
    self.invisibleWebView = ({
        WKWebView *webView = [[WKWebView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        webView.hidden = YES;
        webView.navigationDelegate = self;
        webView;
    });
}

- (void)_loadNextCity {
    if (self.currentCity == 96) {
            // all finished
        [self _onAllFinished];
        return;
    }
    NSString *cityURL = [NSString stringWithFormat:@"%@/days/%@%@",
                         mainURL, @(self.currentCity), suffix];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:cityURL]];
    [self.invisibleWebView loadRequest:request];
}

- (void)_onAllFinished {
    if (self.completionBlock) {
        self.completionBlock(self.resultMap.copy);
    }
}

- (void)_mockLoginOnFirstLoad {
    NSString *js = @"let d = document;"
    @"d.getElementById(\"user_email\").value = \"\";"
    @"d.getElementById(\"user_password\").value = \"\";"
    @"d.getElementById(\"policy_confirmed\").click();"
    @"document.getElementsByName(\"commit\")[0].click();";
    [self.invisibleWebView evaluateJavaScript:js completionHandler:nil];
}

- (void)_processCityJson:(dispatch_block_t)completion {
    NSString *doc = @"document.body.outerHTML";
    __weak typeof(self) wSelf = self;
    [self.invisibleWebView evaluateJavaScript:doc
                            completionHandler:^(id _Nullable result,
                                                NSError * _Nullable error) {
        __strong typeof(wSelf) self = wSelf;
        if (!self || ![result isKindOfClass:NSString.class]) {
            return;
        }
        NSString *resultStr = [(NSString *)result componentsSeparatedByString:@">"][2];
        resultStr = [resultStr substringToIndex:resultStr.length - @"</pre".length];
        
        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSArray *resultAry = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        NSString *cityName = self.cityMap[@(self.currentCity)];
        self.resultMap[cityName] = resultAry ? : @[];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.firstLoad) {
        self.firstLoad = NO;
        [self _mockLoginOnFirstLoad];
    } else if ([webView.URL.absoluteString isEqualToString:mainURL]) {
            // load first city
        self.currentCity = 89;
        [self _loadNextCity];
    } else if ([webView.URL.absoluteString hasSuffix:suffix]) {
            // on one city load finished
        __weak typeof(self) wSelf = self;
        [self _processCityJson:^{
            __strong typeof(wSelf) self = wSelf;
                // load next city
            self.currentCity ++;
            [self _loadNextCity];
        }];
    }
}

@end
