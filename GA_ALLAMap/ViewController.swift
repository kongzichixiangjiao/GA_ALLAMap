//
//  ViewController.swift
//  GA_ALLAMap
//
//  Created by houjianan on 16/8/3.
//  Copyright © 2016年 houjianan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var mapView: GA_AMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = GA_CustomAMapView(frame: CGRectMake(0, 0, AppWidth, AppHeight - 100))
        view.addSubview(mapView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        mapView.addMAPointAnnotation(false)
        
        mapView.getCurrentPostionCoordinate { (lng, lat) in
            print(lng, lat)
        }
        mapView.getScreenCenterPostionCoordinate { (lng, lat) in
            print(lng, lat)
        }
        mapView.getImageOfSnipMAMapView(mapView.bounds) { (image) in
            print(image)
        }
        
        mapView.setMAMapViewZoomLevel(.SMALLSMALL, animated: false)
    }
}

