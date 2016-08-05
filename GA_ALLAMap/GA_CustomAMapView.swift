//
//  GA_CustomAMapView.swift
//  GA_ALLAMap
//
//  Created by houjianan on 16/8/5.
//  Copyright © 2016年 houjianan. All rights reserved.
//

import UIKit

protocol GA_CustomAMapViewDelegate: NSObjectProtocol {
    
}

class GA_CustomAMapView: GA_AMapView {
    
     weak var delegate: GA_CustomAMapViewDelegate!
    
    override init(frame: CGRect, mapViewFrame: CGRect = CGRectMake(0, 0, 0, 0)) {
        super.init(frame: frame, mapViewFrame: mapViewFrame)
        initCustomAMapView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCustomAMapView(frame: CGRect) {
        initreturnCurrentPostionButton(frame)
    }
    
    func initreturnCurrentPostionButton(frame: CGRect) {
        let h = self.frame.size.height
        let wR: CGFloat = 25
        let hR: CGFloat = 25
        let xR: CGFloat = 15
        let bottomR: CGFloat = 20
        let yR: CGFloat = h - hR - bottomR
        let returnCurrentPostionButton = UIButton(frame: CGRectMake(xR, yR, wR, hR))
        returnCurrentPostionButton.setImage(UIImage(named: "navigation"), forState: .Normal)
        returnCurrentPostionButton.addTarget(self, action: #selector(GA_CustomAMapView.returnCurrentPostionButtonAction(_:)), forControlEvents: .TouchUpInside)
        returnCurrentPostionButton.backgroundColor = UIColor.whiteColor()
        aMapView.addSubview(returnCurrentPostionButton)
    }
    
    func returnCurrentPostionButtonAction(sender: UIButton) {
        aMapView.setUserTrackingMode(.Follow, animated: true)
    }
    
    
}
