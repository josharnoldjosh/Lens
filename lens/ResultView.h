//
//  ResultView.h
//
//  Created by Josh Arnold on 4/03/17.
//

#import <UIKit/UIKit.h>

@interface ResultView : UIScrollView <UITableViewDelegate, UITableViewDataSource>
- (instancetype)initWithView:(UIView*)view;
- (instancetype)initWithView:(UIView*)view :(NSString*)text :(UIImage *)previewImage;
@property (nonatomic, strong) NSString *resultText;
@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, strong) UIView *mainView;

@end
