//
//  GA_LocationManager.swift
//  GA_ALLAMap
//
//  Created by houjianan on 16/8/3.
//  Copyright © 2016年 houjianan. All rights reserved.
//

import Foundation

protocol GA_LocationManagerDelegate: NSObjectProtocol {
    func locatingCompletionAction(location: CLLocation?, regeocode: AMapLocationReGeocode?, error: NSError?)
}
/// 一次性定位
class GA_LocationManager: NSObject {
    
    static let l: GA_LocationManager = GA_LocationManager()
    
    class var share: GA_LocationManager {
        return l
    }
    
    private let kDefaultLocationTimeOut: NSInteger = 1
    private let kReGeocodeTimeOut: NSInteger = 1
    
    var locationManager: AMapLocationManager?
    var aMapLocatingCompletionHandler: AMapLocatingCompletionBlock?
    weak var delegate: GA_LocationManagerDelegate!
    
    var isLocating: Bool = false
    
    override init() {
        super.init()
        
        initCompleteBlock()
        configLocationManager()
    }
    
    func initCompleteBlock() {
        aMapLocatingCompletionHandler = {
            [weak self] location, regeocode, error in
            if let weakSelf = self {
                if let location = location {
                    print("location", location)
                }
                if let regeocode = regeocode {
                    print("regeocode", regeocode)
                }
                if let error = error {
                    print("error", error)
                }
                weakSelf.isLocating = false
                weakSelf.delegate.locatingCompletionAction(location, regeocode: regeocode, error: error)
            }
        }
    }
    
    func configLocationManager() {
        locationManager = AMapLocationManager()
        locationManager?.delegate = self
        // kCLLocationAccuracyBest 越准确越慢
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.allowsBackgroundLocationUpdates = false
        locationManager?.locationTimeout = kDefaultLocationTimeOut
        locationManager?.reGeocodeTimeout = kReGeocodeTimeOut
    }
    
    func cleanUpAction() {
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
    }
    
    func reGeocodeAction() {
        locationActionWith(isReGeocode: true)
    }
    
    func locAction() {
        locationActionWith(isReGeocode: false)
    }
    
    func locationActionWith(isReGeocode isRe: Bool) {
        if !isLocating {
            locationManager?.requestLocationWithReGeocode(isRe, completionBlock: aMapLocatingCompletionHandler)
            isLocating = true
        }
    }
    
}

extension GA_LocationManager: AMapLocationManagerDelegate {
    
    func amapLocationManager(manager: AMapLocationManager!, didFailWithError error: NSError!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didUpdateLocation location: CLLocation!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didExitRegion region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didEnterRegion region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didStartMonitoringForRegion region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didDetermineState state: AMapLocationRegionState, forRegion region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, monitoringDidFailForRegion region: AMapLocationRegion!, withError error: NSError!) {
        
    }
    
}