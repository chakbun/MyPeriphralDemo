//
//  ViewController.h
//  MyPeriphralDemo
//
//  Created by Jaben on 14-12-25.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


static NSString * const kServiceUUID = @"312700E2-E798-4D5C-8DCF-49908332DF9F";

static NSString * const kCharacteristicUUIDRead = @"FFA28CDE-6525-4489-801C-1C060CAC9767";

static NSString * const kCharacteristicUUIDWrite = @"FFA28CDE-6525-4489-801C-1C060CAC9769";

@interface ViewController : UIViewController


@property (nonatomic, strong) CBPeripheralManager *myPeripheralManager;

@property (nonatomic, strong) CBMutableCharacteristic *customReadCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *customWriteCharacteristic;

@property (nonatomic, strong) CBMutableService *customService;

@end

