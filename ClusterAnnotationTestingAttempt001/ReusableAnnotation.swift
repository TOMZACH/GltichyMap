//
//  ReusableAnnotation.swift
//  ClusterAnnotationTestingAttempt001
//
//  Created by 123456 on 7/22/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import MapKit

class ReusableAnnotation:NSObject,MKAnnotation{
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String,subtitle:String,coordinate:CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
