//
//  KeyboardViewController.m
//  MediaKeyboardExtension
//
//  Created by SAALIS UMER on 29/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import "KeyboardViewController.h"
#import "FetchAssetsCommand.h"
#import "CopyToClipboardCommand.h"
#import <Photos/Photos.h>
#import "CollectionViewCell.h"
#define kCollectionViewCellIdentifier @"CELL_IDENTIFIER"

@interface KeyboardViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CommandDelegate>
{
    NSMutableArray * array;
    
    BOOL * loaded;
}
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    array = [[NSMutableArray alloc]init];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (loaded == NO) {

        [self loadCollectionView];
        [self loadNextKeyboardButton];

    }
    FetchAssetsCommand * command = [[FetchAssetsCommand alloc]init:self];
    [command execute];
    [self.activityIndicator startAnimating];
}


-(UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc]init ];
        [_activityIndicator sizeToFit];
        _activityIndicator.hidesWhenStopped = YES;
        [self.view addSubview:_activityIndicator];
        [_activityIndicator stopAnimating];
        NSLayoutConstraint *activityIndicatorRightSideConstraint = [NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *activityIndicatorTopConstraint = [NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self.view addConstraints:@[activityIndicatorRightSideConstraint, activityIndicatorTopConstraint]];
    }
    return _activityIndicator;
}

- (void)loadCollectionView
{
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init ]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];

}

-(void)loadNextKeyboardButton
{
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

#pragma mark UICollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.asset = array[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetModel * asset = array[indexPath.row];
    CopyToClipboardCommand * copyToClipboardCommand = [[CopyToClipboardCommand alloc]init:self];
    copyToClipboardCommand.asset = asset;
    [self.activityIndicator startAnimating];
    [copyToClipboardCommand execute];
}

#pragma mark Command Did Receive Respons
- (void)command:(BaseCommand *)cmd didReceiveResponse:(id)response
{
    [self.activityIndicator stopAnimating];
    if ([cmd.commandType isEqualToString:kAssetsFetchCommand]) {
    [array addObject:response];
    [self.collectionView reloadData];
    }
    else if ([cmd.commandType isEqualToString:kCopyToClipboardCommand])
    {
        
    }
}

- (void)command:(BaseCommand *)cmd didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
}

@end
