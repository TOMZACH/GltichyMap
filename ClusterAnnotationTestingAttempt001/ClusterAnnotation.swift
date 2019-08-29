//
//  ClusterView.swift
//  ClusterAnnotationTestingAttempt001
//
//  Created by 123456 on 7/22/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import MapKit

class ClusterAnnotation:MKClusterAnnotation{
    
    
    override init(memberAnnotations: [MKAnnotation]) {
        super.init(memberAnnotations: memberAnnotations)
    }
    
    init(memberAnnotations:[MKAnnotation],title:String, subtitle:String){
        super.init(memberAnnotations: memberAnnotations)
        self.title = title
        self.subtitle = subtitle
    }
}
