//
//  ResultView.m
//
//  Created by Josh Arnold on 4/03/17.
//

#import "ResultView.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"
#import "TableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation ResultView {
    NSString *percentage;
    UITableView *tableView;
    UILabel *adviceLabel;
}

@synthesize mainView;

-(instancetype)initWithView:(UIView *)view {
    return self;
}

- (instancetype)initWithView:(UIView*)view :(NSString*)text :(UIImage *)previewImage
{
    self = [super init];
    if (self) {
        
        self.resultText = text;
        _previewImage = [self imageRotatedByDegrees:previewImage deg:90];
        
        [self setFrame:view.frame];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    NSArray *words = [self.resultText componentsSeparatedByString:@" "];
    NSLog(@"%@", words);
    
    NSString *percentageString = @"";
    NSInteger number = 0;
    
    int resultNumber = 1; // 1 = benign, 2 = semi dangerous, 3 = oh shit fuck this
    
    
    BOOL benign = true;
    
    if ([words count] > 1) {
        NSString *percent = [words objectAtIndex:0];
        
        number =([percent floatValue] * 100);
        percentageString = [NSString stringWithFormat:@"%ld%%", (long)number];
        
        if ([[words objectAtIndex:1]containsString:@"benign"]) {
            benign = true;
        }else if ([[words objectAtIndex:1]containsString:@"malignant"]) {
            benign = false;
        }else if ([[words objectAtIndex:1] isEqualToString:@""] && [[words objectAtIndex:2] containsString:@"benign"]) {
            benign = true;
        }else if ([[words objectAtIndex:1] isEqualToString:@""] && [[words objectAtIndex:2] containsString:@"malignant"]) {
            benign = false;
        }
    }else{
        [self dismissView];
    }
    
    NSString *longAssTit = @"";
    
    if (benign == true) {
        
        if (number >= 70) {
            resultNumber = 1;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is benign. It is still recommended you track the lesion and see a specialist.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is benign", percentageString];

            
        }else if ( 69 >= number && number > 51) {
            resultNumber = 2;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is potentially hazardous. It is strongly advised you track the lesion and seek professional medical assistence.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is hazardous", percentageString];
        }else{
            resultNumber = 3;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is malignant. It is strongly advised you track the lesion and seek professional medical assistence immediately.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is malignant", percentageString];
        }
        
        
    }else {
        if (number >= 75) {
            resultNumber = 3;
            
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is malignant. It is strongly advised you track the lesion and seek professional medical assistence immediately.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is malignant", percentageString];
            
        }else if ( 75 >= number && number > 51) {
            resultNumber = 2;
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is potentially dangerous. It is strongly advised you track the lesion and seek professional medical assistence.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is hazardous", percentageString];

        }else{
            resultNumber = 1;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is benign. It is still recommended you track the lesion and see a specialist.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is benign", percentageString];
        }
    }
    
    NSString *displayText;
    if (benign == true) {
        displayText = [NSString stringWithFormat:@"%@ confidence benign", percentageString];
    }else{
        displayText = [NSString stringWithFormat:@"%@ confidence malignant", percentageString];
    }
    
    displayText = [NSString stringWithFormat:@"%@ confidence", percentageString];
    
    int constantHeight = 48;
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, constantHeight, self.frame.size.width, self.frame.size.height)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [[mainView layer]setCornerRadius:12];
    [mainView setClipsToBounds:YES];
    [self addSubview:mainView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, mainView.frame.size.width-32, 32)];
    [titleLabel setText:@"Scan results"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:21]];
    [titleLabel setTextColor:[UIColor colorWithRed:0.11 green:0.37 blue:1 alpha:1]];
    [mainView addSubview:titleLabel];
    
    UIButton *dismiss = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, ((mainView.frame.size.width-32)/2), 32)];
    [dismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismiss setTitleColor:[UIColor colorWithRed:0.11 green:0.37 blue:1 alpha:1] forState:UIControlStateNormal];
    [dismiss setTitleColor:[UIColor colorWithRed:0.11 green:0.37 blue:1 alpha:0.5] forState:UIControlStateHighlighted];
    [[dismiss titleLabel]setTextAlignment:NSTextAlignmentCenter];
    [dismiss setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dismiss addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:dismiss];
    
    UIButton *track = [[UIButton alloc]initWithFrame:CGRectMake(mainView.frame.size.width-((mainView.frame.size.width-32)/2)-16, 16, ((mainView.frame.size.width-32)/2), 32)];
    [track setTitle:@"Track" forState:UIControlStateNormal];
    [track setTitleColor:[UIColor colorWithRed:0.11 green:0.37 blue:1 alpha:1] forState:UIControlStateNormal];
    [track setTitleColor:[UIColor colorWithRed:0.11 green:0.37 blue:1 alpha:0.5] forState:UIControlStateHighlighted];
    [[track titleLabel]setTextAlignment:NSTextAlignmentCenter];
    [track setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [track addTarget:self action:@selector(trackMole) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:track];
    
    UIView *colourBackground = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+12, mainView.frame.size.width, 240)];
    [mainView addSubview:colourBackground];
    
    UIView *stripe = [[UIView alloc]initWithFrame:CGRectMake(32, colourBackground.frame.origin.y, 4, colourBackground.frame.size.height)];
    [stripe setBackgroundColor:[UIColor colorWithWhite:0.35 alpha:0.25]];
    [mainView addSubview:stripe];
    
    UIView *bigCircle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    [[bigCircle layer]setCornerRadius:8];
    [mainView addSubview:bigCircle];
    bigCircle.center = stripe.center;
    
    UIView *smallCircle1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    [[smallCircle1 layer]setCornerRadius:6];
    [smallCircle1 setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.4]];
    [mainView addSubview:smallCircle1];
    
    UIView *smallCircle2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    [[smallCircle2 layer]setCornerRadius:6];
    [smallCircle2 setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.4]];
    [mainView addSubview:smallCircle2];
    
    UILabel *secondaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [secondaryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    [secondaryLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.75]];
    [mainView addSubview:secondaryLabel];
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    [thirdLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.75]];
    [mainView addSubview:thirdLabel];
    
    // Set this to control point lol
    if (resultNumber == 3) {
        bigCircle.frame = CGRectMake(bigCircle.center.x-8, bigCircle.center.y-60, 16, 16);
        
        smallCircle1.frame = CGRectMake(stripe.center.x-6, bigCircle.center.y+80, 12, 12);
        [secondaryLabel setText:@"Moderate risk"];
        secondaryLabel.frame = CGRectMake(stripe.center.x+41, bigCircle.center.y+74, 200, 20);
        
        smallCircle2.frame = CGRectMake(stripe.center.x-6, bigCircle.center.y+130, 12, 12);
        [thirdLabel setText:@"Low risk"];
        thirdLabel.frame = CGRectMake(stripe.center.x+41, bigCircle.center.y+124, 200, 20);
        
    }else if (resultNumber == 2) {
        bigCircle.frame = CGRectMake(bigCircle.center.x-8, bigCircle.center.y, 16, 16);
        
        smallCircle1.frame = CGRectMake(stripe.center.x-6, bigCircle.center.y-90, 12, 12);
        [secondaryLabel setText:@"High risk"];
        secondaryLabel.frame = CGRectMake(stripe.center.x+41, bigCircle.center.y-98, 200, 25);
        
        smallCircle2.frame = CGRectMake(stripe.center.x-6, bigCircle.center.y+74, 12, 12);
        [thirdLabel setText:@"Low risk"];
        thirdLabel.frame = CGRectMake(stripe.center.x+41, bigCircle.center.y+66, 200, 25);
        
        
    }else if (resultNumber == 1) {
        bigCircle.frame = CGRectMake(bigCircle.center.x-8, bigCircle.center.y+38, 16, 16);
        
        smallCircle2.frame = CGRectMake(stripe.center.x-6, bigCircle.center.y-136, 12, 12);
        [thirdLabel setText:@"High risk"];
        thirdLabel.frame = CGRectMake(stripe.center.x+41, bigCircle.center.y-140, 200, 25);
        
        smallCircle1.frame = CGRectMake(stripe.center.x-6, bigCircle.center.y-90, 12, 12);
        [secondaryLabel setText:@"Moderate risk"];
        secondaryLabel.frame = CGRectMake(stripe.center.x+41, bigCircle.center.y-98, 200, 25);
    }
    
    UIView *selectBar = [[UIView alloc]initWithFrame:CGRectMake(0, bigCircle.center.y-50, mainView.frame.size.width-75, 100)];
    [selectBar setBackgroundColor:[UIColor clearColor]];
    [mainView addSubview:selectBar];
    
    UIView *circleComplement = [[UIView alloc]initWithFrame:CGRectMake(mainView.frame.size.width-125, bigCircle.center.y-50, 100, 100)];
    [[circleComplement layer]setCornerRadius:50];
    [mainView addSubview:circleComplement];
    
    [mainView bringSubviewToFront:bigCircle];
    [mainView bringSubviewToFront:smallCircle1];
    
    UILabel *riskAssesment = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigCircle.frame)+32, 16, 200, 40)];
    [selectBar addSubview:riskAssesment];
    [riskAssesment setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:27]];
    [riskAssesment setTextColor:[UIColor whiteColor]];
    
    UILabel *certainty = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigCircle.frame)+32, 54, 200, 25)];
    [selectBar addSubview:certainty];
    [certainty setText:displayText];
    [certainty setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [certainty setTextColor:[UIColor whiteColor]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = selectBar.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    
    UIButton *previewImageBtn = [[UIButton alloc]initWithFrame:CGRectInset(circleComplement.frame, 12, 12)];
    [previewImageBtn setBackgroundColor:[UIColor whiteColor]];
    [[previewImageBtn layer]setCornerRadius:(previewImageBtn.frame.size.width/2)];
    [previewImageBtn setImage:_previewImage forState:UIControlStateNormal];
    [[previewImageBtn layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[previewImageBtn layer]setBorderWidth:2];
    [previewImageBtn setClipsToBounds:YES];
    [previewImageBtn addTarget:self action:@selector(previewPhotoUsingLibrary) forControlEvents:UIControlEventTouchUpInside];
    [[previewImageBtn imageView]setContentMode:UIViewContentModeScaleAspectFit];
//    [[previewImageBtn imageView]setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [mainView addSubview:previewImageBtn];
    
    // Set this to control point lol
    if (resultNumber == 3) {
        gradient.colors = @[(id)[UIColor colorWithRed:1 green:0.1 blue:0.1 alpha:0.35].CGColor, (id)[UIColor redColor].CGColor, (id)[UIColor redColor].CGColor];
        [riskAssesment setText:@"High risk"];
        [colourBackground setBackgroundColor:[UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1]];
        
        [circleComplement setBackgroundColor:[UIColor redColor]];
        
        [bigCircle setBackgroundColor:[UIColor colorWithRed:1 green:0.35 blue:0.35 alpha:0.9]];
        
        [[previewImageBtn layer]setBorderColor:[UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1].CGColor];
        
        
    }else if (resultNumber == 2) {
        UIColor *yellowFull = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        UIColor *yellowLight = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:0.35];
        
        UIColor *yellowDark = [UIColor colorWithRed:1 green:0.59 blue:0 alpha:1];
        
        gradient.colors = @[(id)yellowLight.CGColor, (id)yellowFull.CGColor, (id)yellowFull.CGColor];
        [circleComplement setBackgroundColor:yellowFull];
        
        
        [bigCircle setBackgroundColor:yellowFull];
        
        [colourBackground setBackgroundColor:yellowDark];
        
        [riskAssesment setText:@"Medium risk"];
        
        [[previewImageBtn layer]setBorderColor:yellowDark.CGColor];
        
        
    }else if (resultNumber == 1) {
        UIColor *yellowFull = [UIColor colorWithRed:0.20 green:0.91 blue:0.32 alpha:1];
        UIColor *yellowLight = [UIColor colorWithRed:0.2 green:0.91 blue:0.32 alpha:0.35];
        
        UIColor *yellowDark = [UIColor colorWithRed:0.09 green:0.75 blue:0.28 alpha:1];
        
        gradient.colors = @[(id)yellowLight.CGColor, (id)yellowFull.CGColor, (id)yellowFull.CGColor];
        [circleComplement setBackgroundColor:yellowFull];
        
        
        [bigCircle setBackgroundColor:yellowFull];
        
        [colourBackground setBackgroundColor:yellowDark];
        
        [[previewImageBtn layer]setBorderColor:yellowDark.CGColor];
        
        [riskAssesment setText:@"Low risk"];
    }
    
    [selectBar.layer insertSublayer:gradient atIndex:0];
    
    adviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, CGRectGetMaxY(colourBackground.frame)+32, mainView.frame.size.width-64, 300)];
    [adviceLabel setText:longAssTit];
    [adviceLabel setTextColor:[UIColor grayColor]];
    adviceLabel.numberOfLines = 0;
    [adviceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [adviceLabel sizeToFit];
    [mainView addSubview:adviceLabel];
    
    UILabel *miniTitle = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(adviceLabel.frame)+60, [self frame].size.width-32, 30)];
    [miniTitle setText:@"Skin clinics near you"];
    [miniTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:24]];
    [tableView setUserInteractionEnabled:NO];
    [[self mainView]addSubview:miniTitle];
    
    [self createTableviewBullshit];
    
}

- (void)previewPhotoUsingLibrary {
    UIViewController *vc = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    
    NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
    photo.imageData = UIImageJPEGRepresentation(_previewImage, 1);
    photo.image = _previewImage;
    photo.placeholderImage = nil;
    
//    photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:percentage attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@"Please ensure the skin lesion is clearly visible, otherwise re-scan the lesion." attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    

    NSArray *array = [[NSArray alloc]initWithObjects:photo, nil];
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:array];
    [vc presentViewController:photosViewController animated:YES completion:nil];
    
    
    
}

- (void)dismissView {
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:4 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(0, self.frame.size.height, mainView.frame.size.width, mainView.frame.size.height)];
        [self setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    //Calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    //Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)createTableviewBullshit {
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(adviceLabel.frame)+106, self.frame.size.width, self.frame.size.height/2) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [tableView setScrollEnabled:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setShowsVerticalScrollIndicator:NO];
    [self.mainView addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    
    
    [[[cell previewImageView]layer]setCornerRadius:cell.previewImageView.frame.size.width/2];
    [[cell previewImageView]setClipsToBounds:YES];
    [cell setUserInteractionEnabled:NO];
    
    if (indexPath.row == 0) {
        [[cell mainLabel]setText:@"Skin & Cancer Foundation"];
        [[cell smallerLabel]setText:@"247 Remuera Rd, Remuera"];
        [[cell previewImageView]setImage:[UIImage imageNamed:@"cancerFound"]];
    }else if (indexPath.row == 1) {
        [[cell mainLabel]setText:@"Skin Institute - Ponsonby"];
        [[cell smallerLabel]setText:@"3 St Marys Rd, Ponsonby"];
        [[cell previewImageView]setImage:[UIImage imageNamed:@"skinInst"]];

    }else{
        [[cell mainLabel]setText:@"Laser Clinics, New Zealand"];
        [[cell smallerLabel]setText:@"7/28, Remuera Road, Station Square, Newmarket"];
        [[cell previewImageView]setImage:[UIImage imageNamed:@"laserClinic"]];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self->tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {

    }else if (indexPath.row == 1) {

    }else{

    }
}

- (void)trackMole {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(@"Tracked mole", @"HUD done title");
    
    
    [hud hideAnimated:YES afterDelay:2.5f];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.superview animated:YES];
        [self dismissView];
    });
}

@end
