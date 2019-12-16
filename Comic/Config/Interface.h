//
//  Interface.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#ifndef Interface_h
#define Interface_h


#endif /* Interface_h */

#define isTrueEnvironment 0

#if isTrueEnvironment
//正式环境
#define kHostURL          @"https://www.pulaukomik.com"
#define kHostTempURL      @"https://www.pulaukomik.com%@"


#else

//测试环境
#define kHostURL          @"https://test.pulaukomik.com"
#define kHostTempURL      @"https://test.pulaukomik.com%@"



#endif


/***public***/
#define  kCartoonTypesAPI          @"/cartoon/book/bookType"      //书籍分类
#define  kRecommandBooksAPI        @"/cartoon/book/nominateBook"    //推荐书籍
#define  kUploadPicAPI             @"/cartoon/upload"               //上传图片
#define  kLoginSwitchAPI           @"/cartoon/user/search_switch"

//登录
#define  kTouristSignInAPI       @"/cartoon/login/visitor"          //游客模式登录
#define  kFacebookSignInAPI      @"/cartoon/login/facebook"         //Facebook登录
#define  kGoogleSignInAPI        @"/cartoon/login"                  //Google登录
#define  kAccountSignInAPI       @"/cartoon/login/apple"            //账号密码登录


//书城
#define  kBookCityHomeAPI        @"/cartoon"
#define  kBookDetailsAPI         @"/cartoon/book/bookDetail"      //书籍详情
#define  kBookSelectionAPI       @"/cartoon/book/anthology"        //漫画选集
#define  kBookReadDetailsAPI     @"/cartoon/book/read"            //章节详情 阅读详情
#define  kBookCommentsAPI        @"/cartoon/comment/list"         //评论列表
#define  kCommentDetailsAPI      @"/cartoon/comment/detail"        //评论详情
#define  kCommentBookAPI         @"/cartoon/comment"               //评论漫画、章节
#define  kReplyCommentAPI        @"/cartoon/comment/review"        //回复评论
#define  kSetLikeBookAPI         @"/cartoon/comment/like"          //点赞
#define  kAddBookShelfAPI        @"/cartoon/book/JoinBookrack"     //加入书架
#define  kSendBarrageAPI         @"/cartoon/book/hairBarrage"      //发送弹幕
#define  kBarrageListAPI         @"/cartoon/book/barrage"          //弹幕列表
#define  kExchangeTypeAPI        @"/cartoon/book/exchangeStyle"    //兑换弹幕样式
#define  kPurchasedTypesAPI      @"/cartoon/book/checkStyle"        //已购买弹幕样式
#define  kShareTaskAPI           @"/cartoon/sign/shareQuest"       //分享任务
#define  kDelMyCommentAPI        @"/cartoon/comment/delComment"    //删除评论或回复


//书架
#define  kBookShelfAPI           @"/cartoon/user/bookrack"         //书架
#define  kDelBookShelfAPI        @"/cartoon/book/delBookrack"       //删除书架漫画


//我的
#define  kMineAPI                @"/cartoon/user"                  //我的
#define  kUserInfoAPI            @"/cartoon/user/userInfo"         //用户基本信息
#define  kSetUserInfoAPI         @"/cartoon/user/setUserInfo"      //修改个人信息
#define  kMemberCenterAPI        @"/cartoon/user/center"           //会员中心
#define  kGetDailyKoinAPI        @"/cartoon/user/vipGetBean"        //vip每日领取金币
#define  kVoucherCenterAPI       @"/cartoon/user/voucherCenter"     //充值中心
#define  kTransactionRecordsAPI  @"/cartoon/user/dealLog"           //交易记录
#define  kMessagesAPI            @"/cartoon/comment/commentLog"      //消息
#define  kUnreadMessagesAPI      @"/cartoon/user/unReadMessage"      //查询未读消息
#define  kReadRecordsAPI         @"/cartoon/book/history"            //阅读记录
#define  kReadHistoryAPI         @"/cartoon/user/readHistory"        //阅读历史
#define  kDelReadHistoryAPI      @"/cartoon/user/delReadHistory"     //删除阅读历史
#define  kPurchasedBooksAPI      @"/cartoon/user/buyCatalogue"       //已购漫画
#define  kCheckInPageAPI         @"/cartoon/sign"                    //签到页面
#define  kReceiveTaskAPI         @"/cartoon/sign/getquest"           //领取任务
#define  kCheckInAPI             @"/cartoon/sign/checkin"             //签到
#define  kSetReadPeferenceAPI    @"/cartoon/user/readPreference"     //设置阅读偏好
#define  kFeedbackAPI            @"/cartoon/user/feedback"           //意见反馈

/*************支付***************/
#define kCreatOrderAPI          @"/cartoon/order"                     //创建订单
#define kPayReportAPI           @"/cartoon/apple"                     //支付成功上报

//h5
#define kUserAgreementURL       @"/agreement"


#define kShareUrl               @"/download.html"
#define kRenewUrl               @"/renew.html"
#define kPrivacyUrl             @"/intimate.html"
