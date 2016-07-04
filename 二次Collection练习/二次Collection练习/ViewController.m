//
//  ViewController.m
//  二次Collection练习
//
//  Created by hu on 16/1/18.
//  Copyright © 2016年 hu. All rights reserved.
//

#import "ViewController.h"
#import "CuttomViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "FullScreenView.h"
#import "MyCollectionReusableView.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    ALAssetsLibrary *library;
    NSMutableArray *imageArray;
    NSMutableArray *mutableArray;
}
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic,strong)ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong)UIImageView *backView;
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,strong)UIImagePickerController *pickviewController;
@end

static NSInteger count = 0;

@implementation ViewController

-(NSMutableArray*)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

-(UIImagePickerController*)pickviewController{
    if (!_pickviewController) {
        _pickviewController = [[UIImagePickerController alloc]init];
        _pickviewController.delegate = self;
        _pickviewController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    return _pickviewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 200, 200)];
   // [self.view addSubview:self.backView];
    
    //制作相框
    [self makeCollection];
    
    //获取本地相片库中的图片
    //[self getAllPictures];
    
}

#pragma mark 加载时候，有点慢
-(void)getAllPictures{
    
    imageArray=[[NSMutableArray alloc] init];
    
    mutableArray =[[NSMutableArray alloc]init];
    
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if(result != nil) {
            //获取照相机里的照片
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [library assetForURL:url
                 
                         resultBlock:^(ALAsset *asset) {
                             
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count]==count)
                                 
                             {
                                 
                                 imageArray=[[NSMutableArray alloc] initWithArray:mutableArray];
                                 
                                 //获取所有的照片
                                 [self allPhotosCollected:imageArray];
                                 
                             }
                             
                         }
                 
                        failureBlock:^(NSError *error){
                            
                            NSLog(@"operation was not successfull!");
                        } ];
            }
            
        }
        
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        
        if(group != nil) {
            
            [group enumerateAssetsUsingBlock:assetEnumerator];
            
            [assetGroups addObject:group];
            
            count=[group numberOfAssets];
            
        }
        
    };
    
//    assetGroups = [[NSMutableArray alloc] init];
    
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
     
                           usingBlock:assetGroupEnumerator
     
                         failureBlock:^(NSError *error) {
                             NSLog(@"There is an error");
                         }];
    
}

//获取所有图片
-(void)allPhotosCollected:(NSArray*)imgArray{

    //如何加载图片()
    [self makeCollection];
    [self.collection reloadData];
}

#pragma mark
-(void)makeCollection{

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) collectionViewLayout:self.flowLayout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor whiteColor];
    
    //注册
    [self.collection registerClass:[CuttomViewCell class] forCellWithReuseIdentifier:@"123"];
    
    [self.collection registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collection];
}

#pragma mark 完成代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;//imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"123";
    CuttomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    //对imageview进行加载图片
    cell.showImage.image = imageArray[indexPath.item];
    
    cell.label.text = [NSString stringWithFormat:@"{%ld ,%ld}",indexPath.section,indexPath.row];
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}
#pragma mark 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 150);
}
#pragma mark 实现头部视图方法
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        MyCollectionReusableView*headerView = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//        if ([[reusableview.subviews lastObject] isKindOfClass:[UILabel class]]) {
//            [[reusableview.subviews lastObject] removeFromSuperview];
//        }
//        //
//        UILabel *label = [[UILabel alloc]init];
//        label.frame = CGRectMake(0, 0, 80, 30);
//        label.text = @"小草肉";
//        [headerView addSubview:label];
        [headerView resettitle];
        headerView.backgroundColor = [UIColor orangeColor];
        reusableview = headerView;
    }
    return reusableview;

   
}

//增加头部视图
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.view.frame.size.width, 50);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
// 
//    return CGSizeMake(self.view.frame.size.width, 60);
//}


#pragma mark
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){

    return YES;
}
//移动
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0){
    
    id objc = [imageArray objectAtIndex:sourceIndexPath.item];
    [objc removeObject:objc];
    [imageArray insertObject:objc atIndex:destinationIndexPath.item];
    
    
}
#pragma mark 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    //点击展示大图
    
    
    
}






@end
