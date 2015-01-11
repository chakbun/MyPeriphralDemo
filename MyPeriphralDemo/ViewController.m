//
//  ViewController.m
//  MyPeriphralDemo
//
//  Created by Jaben on 14-12-25.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CBPeripheralManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupService {
    
    // Creates the characteristic UUID
    
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUIDRead];
    CBUUID *writeUUID = [CBUUID UUIDWithString:kCharacteristicUUIDWrite];
    
    // Creates the characteristic
    
    self.customReadCharacteristic = [[CBMutableCharacteristic alloc] initWithType:
                                 
                                 characteristicUUID properties:CBCharacteristicPropertyNotify
                                 
                                                                        value:nil permissions:CBAttributePermissionsReadable];
    
    self.customWriteCharacteristic = [[CBMutableCharacteristic alloc] initWithType:writeUUID properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];

    
    // Creates the service UUID
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    
    // Creates the service and adds the characteristic to it
    
    self.customService = [[CBMutableService alloc] initWithType:serviceUUID
                          
                                                        primary:YES];
    
    // Sets the characteristics for this service
    
    [self.customService setCharacteristics:
     
     @[self.customReadCharacteristic,self.customWriteCharacteristic]];
    
    // Publishes the service
    
    [self.myPeripheralManager addService:self.customService];
    
}


#pragma mark --CBPeriphral Delegate 

- (void)respondToRequest:(CBATTRequest *)request withResult:(CBATTError)result {
    NSLog(@"============ respondToRequest ============");
}

- (BOOL)updateValue:(NSData *)value forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:(NSArray *)centrals {
    NSLog(@"============ updateValue ============");
    return YES;
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"============ didReceiveReadRequest ============");

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    NSLog(@"============ didReceiveWriteRequests ============");
    NSLog(@"request : %@",requests);
    for(CBATTRequest *request in requests) {
        NSLog(@"characteritic UUID : %@", [request.characteristic.UUID UUIDString]);
        NSLog(@"value :%@ length:%d",request.value,(int)(request.value.length));
    }

}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            
            [self setupService];
            
            break;
            
        default:
            
            NSLog(@"Peripheral Manager did change state");
            
            break;
            
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error == nil) {
        // Starts advertising the service
        
        [self.myPeripheralManager startAdvertising:
         
         @{ CBAdvertisementDataLocalNameKey :
                
                @"JabenSerivce", CBAdvertisementDataServiceUUIDsKey :
                
                @[[CBUUID UUIDWithString:kServiceUUID]] }];
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateValue) userInfo:nil repeats:YES];
    

}

- (void)updateValue {
    NSData *data = [@"abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcappppp" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data length : %d",(int)data.length);
    BOOL hello = [self.myPeripheralManager updateValue:data forCharacteristic:self.customReadCharacteristic onSubscribedCentrals:nil];
    NSLog(@"hello %d",hello);
}

@end
