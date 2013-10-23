//
//  secondViewController.m
//  testApp
//
//  Created by Nathan Buth on 10/11/12.
//  Copyright (c) 2012 Nathan Buth. All rights reserved.
//

#import "secondViewController.h"

@interface secondViewController ()

@end

@implementation secondViewController
@synthesize delegate, eventDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//So that an alert can be made
-(void)DisplayAlertWithString:(NSString *)alertString customTitle:(NSString *)customTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:customTitle message:alertString delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    if (alertView != nil)
    {
        [alertView show];
    }
}
//End alert function

//Save Events
//Saves the data entered and switchs back to the first view

//End Save Events


//Collapse/Expand Keyboard
//Allows the keyboard to expand and collapse dynamically
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    leftSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    leftSwiper.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftSwipeLabel addGestureRecognizer:leftSwiper];
    
    rightSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    rightSwiper.direction = UISwipeGestureRecognizerDirectionRight;
    [leftSwipeLabel addGestureRecognizer:rightSwiper];
    
    [super viewWillAppear:animated];
}

//Swipe function for switching back to the first view and passing event info to textView
-(void)onSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)//checks for left swipe gesture
    {
        if(eventInfo.text.length != 0)//checks for entered text
        {
            NSString *eventText = eventInfo.text;//saves entered text as a string
            NSLog(@"Event: %@", eventText);//displays the string in the log
            
            NSDate *chosenDate = [eventDate date];//declares the selected date
            if(chosenDate != nil)
            {
                NSDateFormatter *trueDate = [[NSDateFormatter alloc]init];
                if(trueDate != nil)
                {
                    [trueDate setDateFormat:@"MMMM dd, h:mm a"];//Makes the date more readable
                }
                finalDate = [trueDate stringFromDate:chosenDate];//Makes the date a string
                NSLog(@"Event Date: %@", finalDate);//Loads date into the log
                NSLog(@"The Event is: %@ on %@", eventText, finalDate);//Loads full event info into the log
            }
            
            if(delegate != nil)
            {
                fullEvent = [NSString stringWithFormat:@"%@ \n %@ \n \n", eventInfo.text, finalDate];
                [delegate eventSave:fullEvent];
            }
            
            [self dismissViewControllerAnimated:TRUE completion:nil];//switches back to the first view
        }
        else//If the text field is empty display an alert saying to enter text
        {
            NSString *alert = [NSString stringWithFormat:@"In order to save a date, you must put some text in the event text field."];
            [self DisplayAlertWithString:alert customTitle:@"No Text Entered"];
        }
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)//if swipe right pop up alert
    {
        NSString *alert = [NSString stringWithFormat:@"Swiping right here currently does nothing."];
        [self DisplayAlertWithString:alert customTitle:@"No Action Here"];

    }
}

-(void)showKeyboard:(NSNotification *)notification
{
    
}

-(void)hideKeyboard:(NSNotification *)notification
{
    
}

//Close the keyboard when button is pressed
-(IBAction)collapseKeyboard:(id)sender
{
    [eventInfo resignFirstResponder];
}
//End Collaps/Expand Keyboard

//Send you back to the first view without passing info
-(IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)viewDidLoad
{
    //makes it so that users cannot set to date/time earlier than the present date/time
    eventDate.minimumDate = [NSDate date];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
