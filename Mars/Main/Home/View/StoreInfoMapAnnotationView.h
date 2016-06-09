//
//  StoreInfoMapAnnotationView.h
//  Mars
//
//  Created by Wayde C. on 6/4/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <MapKit/MapKit.h>

@class StoreInfoModel;
@interface StoreInfoMapAnnotationView : MKAnnotationView 
@property (strong, nonatomic) StoreInfoModel *store;
@end
