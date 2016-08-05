//
//  GA_AMapView.swift
//  GA_ALLAMap
//
//  Created by houjianan on 16/8/3.
//  Copyright © 2016年 houjianan. All rights reserved.
//

import UIKit

struct LocationData {
    var location: CLLocation?
    var regeocode: AMapLocationReGeocode?
    var error: NSError?
}

enum ZoomLevelType: Double {
    case BIGBIG     = 5.2,
         BIG        = 10.2,
         MIDDLE     = 12.2,
         SMALL      = 15.2,
         SMALLSMALL = 18.2
}

class GA_AMapView: UIView {
    private var isHiddenAnnotation: Bool!
    var aMapView: MAMapView!
    
    init(frame: CGRect, mapViewFrame: CGRect = CGRectMake(0, 0, 0, 0)) {
        super.init(frame: frame)
        if mapViewFrame == CGRectMake(0, 0, 0, 0) {
            initAMapView(frame)
        } else {
            initAMapView(mapViewFrame)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initAMapView(frame: CGRect) {
        aMapView = MAMapView(frame: frame)
        aMapView.delegate = self
        aMapView.showsUserLocation = true
        aMapView.showsScale = false
        aMapView.setZoomLevel(15.2, animated: true)
        self.addSubview(aMapView)
    }
    
    func configeAPointAnnotations(location: CLLocation,
                                  regeocode: AMapLocationReGeocode?) -> [MAPointAnnotation] {
        var annotations: [MAPointAnnotation] = []
        
        let annotation = MAPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title      = regeocode?.formattedAddress
        annotation.subtitle   = location.description
        
        annotations.append(annotation)
        return annotations
    }
    
    func addMAPointAnnotation(isHidden: Bool) {
        self.isHiddenAnnotation = isHidden
        
        initLocationManager()
    }
    
    func addMAPointAnnotation(location: CLLocation, regeocode: AMapLocationReGeocode?, isHidden: Bool) {
        let annotations = configeAPointAnnotations(location, regeocode: regeocode)
        // 001
        removeMAPointAnnotations()
        // 002
        aMapView.addAnnotation(annotations.first)
        // 003
        if !hidden {
            aMapView.selectAnnotation(annotations.first, animated: true)
        }
        
        aMapView.zoomLevel = 15.1
        aMapView.setCenterCoordinate(location.coordinate, animated: false)
    }
    
    func removeMAPointAnnotations() {
        aMapView.removeAnnotations(aMapView.annotations)
    }
    
    func initLocationManager() {
        GA_LocationManager.share.delegate = self
        GA_LocationManager.share.reGeocodeAction()
    }
    
    func myLocatingCompletionAction(location: CLLocation?, regeocode: AMapLocationReGeocode?, error: NSError?) {
        if let location: CLLocation = location {
            print("location", location)
        }
        if let regeocode: AMapLocationReGeocode = regeocode {
            print("regeocode", regeocode)
        }
        
        addMAPointAnnotation(location!, regeocode: regeocode, isHidden: false)
        
        if let error: NSError = error {
            print("error", error)
        }
    }
    
    func getCurrentPostionCoordinate(handler: (lng: Double, lat: Double) -> ()) {
        let c = aMapView.userLocation.coordinate
        handler(lng: c.longitude, lat: c.latitude)
    }
    
    func getScreenCenterPostionCoordinate(handler: (lng: Double, lat: Double) -> ()) {
        let screenCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        let c = aMapView.convertPoint(screenCenter, toCoordinateFromView: aMapView)
        handler(lng: c.longitude, lat: c.latitude)
    }
    
    func getImageOfSnipMAMapView(frame: CGRect, handler: (image: UIImage) -> ()) {
        let image = aMapView.takeSnapshotInRect(frame)
        handler(image: image)
    }
    
    func setMAMapViewZoomLevel(zoomLevel: ZoomLevelType, animated: Bool) {
        aMapView.setZoomLevel(zoomLevel.rawValue, animated: animated)
    }
    
}

extension GA_AMapView: MAMapViewDelegate {
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(MAPointAnnotation) {
            var annotationView =
                mapView.dequeueReusableAnnotationViewWithIdentifier("GA_Point")
                    as? GA_AnnotationView
            if annotationView == nil {
                annotationView = GA_AnnotationView(annotation: annotation,
                                                   reuseIdentifier: "GA_Point")
                annotationView?.calloutOffset  = CGPointMake(0, -5)
                annotationView?.canShowCallout = false
                annotationView?.draggable      = true
                //001
                //                annotationView?.portraitImage  = UIImage(named: "hand")
                //                annotationView?.subTitle       = "我是测试我是测试我是测试"
                //                annotationView?.hasNavigation  = true
                //002
                //                annotationView?.subTitle       = "我是测试我是测试我是测试"
                //003
                annotationView?.portraitImage  = UIImage(named: "hand")
                annotationView?.subTitle       = "我是测试我是测试我是测试"
                annotationView?.hasNavigation  = false
            }
            return annotationView
        }
        return nil
    }
}

extension GA_AMapView: GA_LocationManagerDelegate {
    //一次定位
    func locatingCompletionAction(location: CLLocation?, regeocode: AMapLocationReGeocode?, error: NSError?) {
        myLocatingCompletionAction(location, regeocode: regeocode, error: error)
    }
}


