//
//  ViewController.swift
//  ClusterAnnotationTestingAttempt001
//
//  Created by 123456 on 7/22/19.
//  Copyright © 2019 123456. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        return mapView
    }()
    
    lazy var locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.distanceFilter = 200
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        let initialLocation = CLLocation(latitude: 40.758896, longitude: -73.985130)
        let zachsHome = CLLocationCoordinate2D(latitude: 40.612550, longitude: -73.907061)
        let laVillaLatLong = CLLocationCoordinate2D(latitude: 40.6168812, longitude: -73.9096593)
        let keyfoodLatLong = CLLocationCoordinate2D(latitude: 40.6172223, longitude: -73.9094067)
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
        
        let myHome = ReusableAnnotation(title: "Zach's Home", subtitle:  "2352 east 66th Street", coordinate: zachsHome)
        
            
        let laVillaAnnotation = ReusableAnnotation(title: "La Villa", subtitle: "6610 Avenue U", coordinate: laVillaLatLong)
        
        let keyFoodAnnotation = ReusableAnnotation(title: "Key Food", subtitle: "6620 Avenue U", coordinate: keyfoodLatLong)
        
        mapView.addAnnotations([myHome,laVillaAnnotation,keyFoodAnnotation])
 
    }


}


extension ViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation{
            return nil
        }else if let cluster = annotation as? MKClusterAnnotation{
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: cluster) as? MKMarkerAnnotationView
           
            view?.annotation = cluster
            view?.markerTintColor = UIColor.green

            
            return view
        }
        else if let marker = annotation as? ReusableAnnotation{
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: marker)
            view.annotation = marker
            view.clusteringIdentifier = "cluster"
            
            view.canShowCallout = true
//            view.detailCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "apolloRocket"))
            
//            view.image = #imageLiteral(resourceName: "apolloRocket").resizeImage(150, opaque: false) // #imageLiteral(resourceName: "apolloRocket")
            let subView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            subView.backgroundColor = UIColor.red
            view.addSubview(subView)
            
            view.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            return view
        }else{
            return nil
        }
    }
    
}

extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            fatalError("No last location reported")
        }
        print("did begin updating: \(location.coordinate)")
        //        self.mapView.setCenter(location.coordinate, animated: true)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(region, animated: true)
    }
    
    
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}

