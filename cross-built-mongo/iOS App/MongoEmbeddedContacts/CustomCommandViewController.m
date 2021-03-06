//
//  CustomCommandViewController.m
//  MongoEmbeddedContacts
//
//  Created by Edward Tuckman on 7/31/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import "CustomCommandViewController.h"

@interface CustomCommandViewController ()

@end

@implementation CustomCommandViewController

@synthesize commandBox = _commandBox;
@synthesize resultBox = _resultBox;
@synthesize submitCommand = _submitCommand;
@synthesize collStatsButton = _collStatsButton;
@synthesize serverStatusButton = _serverStatusButton;
@synthesize countButton = _countButton;
@synthesize validateButton = _validateButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _commandBox.placeholder = [NSString stringWithFormat:@"Enter Command"];
    _commandBox.delegate = self;
    // commandBox setup
    [_commandBox addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // resultBox setup
    _resultBox.text = [NSString stringWithFormat:@"No Results Yet"];
    _resultBox.editable = NO;
    
    // button -- submit command setup
    _submitCommand.enabled = NO;
    [_submitCommand addTarget:self action:@selector(submitCommandFunc:) forControlEvents:UIControlEventTouchUpInside];
    [_submitCommand setTitle:@"Submit" forState:UIControlStateNormal];
    
    // command button setup
    [_collStatsButton addTarget:self action:@selector(collStatsFunc:) forControlEvents:UIControlEventTouchUpInside];
    [_collStatsButton setTitle:@"collStats" forState:UIControlStateNormal];
    [_serverStatusButton addTarget:self action:@selector(serverStatusFunc:) forControlEvents:UIControlEventTouchUpInside];
    [_serverStatusButton setTitle:@"serverStatus" forState:UIControlStateNormal];
    [_countButton addTarget:self action:@selector(countFunc:) forControlEvents:UIControlEventTouchUpInside];
    [_countButton setTitle:@"count" forState:UIControlStateNormal];
    [_validateButton addTarget:self action:@selector(validateFunc:) forControlEvents:UIControlEventTouchUpInside];
    [_validateButton setTitle:@"validate" forState:UIControlStateNormal];
    printf("Done with load\n");
    
}

-(void)textFieldDidChange :(UITextField *) textField {

    char * cmd = [textField.text UTF8String];
    if (validateCommand(self.bundle, cmd)) {
        NSLog(@"Valid\n");
        _submitCommand.enabled = YES;
    }
    else {
        NSLog(@"Invalid\n");
        _submitCommand.enabled = NO;
    }
}

-(void) submitCommandFunc:(UIButton *)submitCommand {
    [self.view endEditing:YES];
    // NSString *settingsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    const char * cmd = [_commandBox.text UTF8String];

    char * temp = executeCollectionCommand(self.bundle, cmd);
    NSString * s = [NSString stringWithUTF8String:temp];
    // NSString * s = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
    if (!s) {_resultBox.text = @"Got NULL from database"; return;}

    NSError* e;
    //1. convert string to NSData
    NSData* jsonData = [s dataUsingEncoding:NSUTF8StringEncoding];

    //2. convert JSON data to JSON object
    NSObject* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];

    //3. convert back to JSON data by setting .PrettyPrinted option
    NSData* prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&e];

    //4. convert NSData back to NSString (use NSString init for convenience), later you can convert to String.
    NSString * prettyPrintedJson = [[NSString alloc] initWithData:prettyJsonData encoding:NSUTF8StringEncoding];
    
    _resultBox.text = prettyPrintedJson;


}

-(void) collStatsFunc:(UIButton *)collStats {
    _commandBox.text = @"{ \"collStats\" : \"contacts\"}";
    _submitCommand.enabled = YES;
}

-(void) serverStatusFunc:(UIButton *)serverStatus {
    _commandBox.text = @"{ \"serverStatus\": 1 }";
    _submitCommand.enabled = YES;
}

-(void) countFunc:(UIButton *) countButtonObj {
    _commandBox.text = @"{\"count\": \"contacts\"}";
    _submitCommand.enabled = YES;
}
-(void) validateFunc:(UIButton *) validate {
    _commandBox.text = @"{\"validate\": \"contacts\"}";
    _submitCommand.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
