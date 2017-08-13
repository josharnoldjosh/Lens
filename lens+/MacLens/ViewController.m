//
//  ViewController.m
//  MacLens
//
//  Created by Josh Arnold on 22/03/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import "ViewController.h"
#import "RunModelViewController.h"
#import "ResultViewController.h"
#import "LoadingViewController.h"

@implementation ViewController {
    NSString *percentage;
    NSColor *bluePrimary;
    NSColor *blueDark;
}
@synthesize instructionLabel;
@synthesize backgroundBox;
@synthesize lowBox;
@synthesize mediumBox;
@synthesize highBox;
@synthesize percentLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.view.layer.backgroundColor = [NSColor blueColor].CGColor;
    
    self.mainView.layer.backgroundColor = [NSColor blueColor].CGColor;
    
    bluePrimary = [self.backgroundBox fillColor];
    blueDark = [self.lowBox fillColor];
    
    self.title = @"lens+";
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (IBAction)imageSelected:(id)sender {
    
    [self.instructionLabel setAlphaValue:0];
    [self.backgroundBox setFillColor:bluePrimary];
    [self.lowBox setFillColor:blueDark];
    [self.mediumBox setFillColor:blueDark];
    [self.highBox setFillColor:blueDark];
    [self.outputLabel setStringValue:@""];
    
    [self.outputLabel setTextColor:[NSColor whiteColor]];
    [self.percentLabel setStringValue:@"0%"];
    [self.percentLabel setTextColor:[NSColor whiteColor]];
    
    [self activateBeast];
    
}

-(void)setLowRisk {
    [self.lowBox setFillColor:[NSColor colorWithRed:0.20 green:0.91 blue:0.32 alpha:1]];
    [self.backgroundBox setFillColor:[NSColor colorWithRed:0.09 green:0.75 blue:0.28 alpha:1]];
}

-(void)setMediumRisk {
    [self.mediumBox setFillColor:[NSColor colorWithRed:1 green:0.8 blue:0 alpha:1]];
    [self.backgroundBox setFillColor:[NSColor colorWithRed:1 green:0.59 blue:0 alpha:1]];
}

-(void)setHighRisk {
    [self.highBox setFillColor:[NSColor colorWithRed:1 green:0.1 blue:0.1 alpha:1]];
    [self.backgroundBox setFillColor:[NSColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1]];
}

- (void)activateBeast {
    NSImage *img = self.imageView.image;
    
    if (img != nil) {
        
        RunModelViewController *vc = [[RunModelViewController alloc]init];
        
        NSString *text = [vc analyseImage:img];
        
        
        text = [text stringByReplacingOccurrencesOfString:@"0 " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"1 " withString:@""];
        
        [self letUsDetectShit:text];
        
    }
}

-(void)letUsDetectShit:(NSString *)resultText {
    
    
    NSArray *words = [resultText componentsSeparatedByString:@" "];
    NSLog(@"%@", words);
    
    NSString *percentageString = @"101%";
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
        
        // Dismiss shit
        
    }
    
    if (number == 0) {
        number = 100;
        percentageString = @"99.99%";
    }
    
    NSString *longAssTit = @"";
    
    if (benign == true) {
        
        if (number >= 70) {
            resultNumber = 1;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is benign. It is still recommended you track the lesion and see a specialist.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is benign", percentageString];
            
            [self setLowRisk];
            
            
        }else if ( 69 >= number && number > 51) {
            resultNumber = 2;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is potentially hazardous. It is strongly advised you track the lesion and seek professional medical assistence.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is hazardous", percentageString];
            
            [self setMediumRisk];
        }else{
            resultNumber = 3;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is malignant. It is strongly advised you track the lesion and seek professional medical assistence immediately.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is malignant", percentageString];
            
            [self setHighRisk];
        }
        
        
    }else {
        if (number >= 75) {
            resultNumber = 3;
            
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is malignant. It is strongly advised you track the lesion and seek professional medical assistence immediately.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is malignant", percentageString];
            
            [self setHighRisk];
            
        }else if ( 75 >= number && number > 51) {
            resultNumber = 2;
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is potentially dangerous. It is strongly advised you track the lesion and seek professional medical assistence.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is hazardous", percentageString];
            
            [self setMediumRisk];
            
        }else{
            resultNumber = 1;
            
            longAssTit = [NSString stringWithFormat:@"The scan results have shown with %@ confidence that the lesion is benign. It is still recommended you track the lesion and see a specialist.", percentageString];
            
            percentage = [NSString stringWithFormat:@"%@ confident the lesion is benign", percentageString];
            
            [self setLowRisk];
        }
    }
    
    NSString *displayText;
    if (benign == true) {
        displayText = [NSString stringWithFormat:@"confidence benign"];
    }else{
        displayText = [NSString stringWithFormat:@"confidence malignant"];
    }
    
    [self.percentLabel setStringValue:[NSString stringWithFormat:@"%@",percentageString]];
    
    //    displayText = [NSString stringWithFormat:@"%@ confidence", percentageString];
    
    [self.outputLabel setStringValue:displayText];
    
}

+ (int)detectUltimateShit:(NSString *)resultText {
    
    
    NSArray *words = [resultText componentsSeparatedByString:@" "];
    NSLog(@"%@", words);
    
    NSString *percentageString = @"101%";
    NSInteger number = 0;

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
    }
    
    if (benign == true) {
        return 0;
    }else{
        return 1;
    }
}

- (IBAction)scanAgain:(id)sender {
    [self.instructionLabel setAlphaValue:1];
    [self.imageView setImage:nil];
    [self.backgroundBox setFillColor:bluePrimary];
    [self.lowBox setFillColor:blueDark];
    [self.mediumBox setFillColor:blueDark];
    [self.highBox setFillColor:blueDark];
    [self.outputLabel setStringValue:@""];
    [self.outputLabel setTextColor:blueDark];
    [self.percentLabel setStringValue:@"0%"];
    [self.percentLabel setTextColor:blueDark];
}
- (IBAction)deepScan:(id)sender {
    NSOpenPanel *panel = [[NSOpenPanel alloc]init];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:NO];
    [panel setCanChooseDirectories:YES];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        NSLog(@"%@ FUCK YEA", [panel URL]);
        [self findImagesWithDirectory:[panel directoryURL]];
    }];
}

- (void)findImagesWithDirectory:(NSURL*)url {
    
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[url path] error:nil];
    NSArray *jpgFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
//    NSLog(@"%@",jpgFiles);
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (NSString *str in jpgFiles) {
        NSString *path =  [[url path] stringByAppendingString:[NSString stringWithFormat:@"/%@",str]];
//        NSLog(@"%@", path);
        
        NSImage *image = [[NSImage alloc]initWithContentsOfFile:path];
        if (image == nil) {
            NSLog(@"image nil");
            
        }else{
//            NSLog(@"%f and %f",image.size.width, image.size.height);
            [imageArray addObject:image];
        }
    }
    
//    NSLog(@"final array %@", imageArray);
    
    [self deepScanImages:imageArray];
}

-(void)deepScanImages:(NSArray *)array {
    
    RunModelViewController *vc = [[RunModelViewController alloc]init];
    
    NSMutableArray *benign = [[NSMutableArray alloc]init];
    NSMutableArray *malignant = [[NSMutableArray alloc]init];
    
    LoadingViewController *loadVC = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:nil];
    [self presentViewControllerAsSheet:loadVC];

    for (NSImage *img in array) {
        
        NSString *text = [vc analyseImage:img];
        
        text = [text stringByReplacingOccurrencesOfString:@"0 " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"1 " withString:@""];
        
        
        if ([ViewController detectUltimateShit:text] == 0) {
            [benign addObject:img];
        }else{
            [malignant addObject:img];
        }
    }
    
    [loadVC dismissController:loadVC];
    
    ResultViewController *vcc = [[ResultViewController alloc]initWithNibName:@"ResultViewController" bundle:nil];
    vcc.bengin = benign;
    vcc.malignant = malignant;
    [self presentViewControllerAsSheet:vcc];
}




@end
