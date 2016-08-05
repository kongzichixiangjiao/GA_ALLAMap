//
//  GA_CalloutView.swift
//  GA_AMap_Swift
//
//  Created by houjianan on 15/11/3.
//  Copyright © 2015年 houjianan. All rights reserved.
//

import UIKit

enum ImagePostionType {
    case LEFT, RIGHT
}

class GA_CalloutView: UIView {
    
    private let adjustY: CGFloat = -1.6
    private let backCGColor: CGColor = UIColor.lightGrayColor().CGColor
    
    let navigationString = "导航"
    var hasNavigation: Bool = false
    var textWidth: CGFloat = 0
    var hasPortraitImage: Bool = false
    
    typealias NavigationTapHandler = () -> ()
    var navigationTapHandler: NavigationTapHandler!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect,
                     textWidth: CGFloat,
                     portraitImage: UIImage?,
                     imagePostion: ImagePostionType,
                     hasNavigation: Bool,
                     subTitle: String?,
                     describeString: String?) {
        self.init(frame: frame)
        
        createUI(textWidth,
                 portraitImage: portraitImage,
                 imagePostion: imagePostion,
                 hasNavigation: hasNavigation,
                 subTitle: subTitle,
                 describeString: describeString)
    }
    
    func createUI(textWidth: CGFloat,
                  portraitImage: UIImage?,
                  imagePostion: ImagePostionType,
                  hasNavigation: Bool,
                  subTitle: String?,
                  describeString: String?) {
        
        self.hasNavigation = hasNavigation
        self.textWidth = textWidth
        
        let font = UIFont.systemFontOfSize(12)
        let w: CGFloat  = self.frame.size.width
        let h: CGFloat  = self.frame.size.height
        var sX: CGFloat = 0
        let sY: CGFloat = adjustY
        let sW: CGFloat = textWidth + kSpaceWidth
        let sH: CGFloat = h
        if hasNavigation {
            let navigationLabel = UILabel(frame: CGRectMake(0, adjustY, kNavigationWidth, h))
            navigationLabel.text = navigationString
            navigationLabel.font = font
            navigationLabel.textAlignment = .Center
            navigationLabel.textColor = UIColor.brownColor()
            navigationLabel.backgroundColor = UIColor.clearColor()
            self.addSubview(navigationLabel)
            
            sX = kNavigationWidth + kSpaceWidth / 2
        } else {
            if portraitImage != nil {
                self.hasPortraitImage = true
                
                let portraitView = UIImageView(image: portraitImage)
                let pW: CGFloat = portraitImage!.size.width > 20 ? 20 : self.frame.size.width
                let pH: CGFloat = portraitImage!.size.height > 20 ? 20 : self.frame.size.height
                let pY: CGFloat = h / 2 - pH / 2 + adjustY
                var pX: CGFloat = pY
                if imagePostion == .RIGHT {
                    pX = w - kSpaceWidth - pW
                } else {
                    sX = pW + kSpaceWidth
                }
                portraitView.frame = CGRectMake(pX, pY, pW, pH)
                portraitView.backgroundColor = UIColor.clearColor()
                self.addSubview(portraitView)
            } else {
                sX = kSpaceWidth / 2
            }
        }
        
        if subTitle != "" {
            let subTitleLabel = UILabel(frame: CGRectMake(sX, sY, sW, sH))
            subTitleLabel.text = subTitle
            subTitleLabel.font = font
            subTitleLabel.textAlignment = .Center
            subTitleLabel.textColor = UIColor.brownColor()
            subTitleLabel.backgroundColor = UIColor.clearColor()
            self.addSubview(subTitleLabel)
        }
        
        setNeedsDisplay()
    }
    
    func navigationTap() {
        navigationTapHandler()
    }
    
    override func drawRect(rect: CGRect) {
        if hasNavigation {
            hasNavigationDrawPath()
        } else {
            if hasPortraitImage {
                hasPortraitImageDrawPath()
            } else {
                onlyHasTextDrawPath()
            }
        }
        setShadowMethod()
    }
    
    func setShadowMethod() {
//        self.layer.shadowColor = UIColor.redColor().CGColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.layer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    func hasNavigationDrawPath() {
        let frame = self.bounds
        let x = frame.origin.x
        let y = frame.origin.y
        let w = frame.size.width
        let p: CGFloat = 4
        let h = frame.size.height - p
        let r: CGFloat = 10
        
        //左
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextMoveToPoint(context, x + r, y)
        CGContextAddLineToPoint(context, x + kNavigationWidth, y)
        CGContextAddLineToPoint(context, x + kNavigationWidth, y + h)
        CGContextAddLineToPoint(context, x + r, y + h)
        CGContextAddArcToPoint(context, x, y + h, x, y + r, r)
        CGContextAddArcToPoint(context, x, y, x + r, y, r)
        CGContextClosePath(context)
        CGContextFillPath(context)

        //右
        CGContextBeginPath(context)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextMoveToPoint(context, kNavigationWidth, y)
        CGContextAddLineToPoint(context, w - r, y)
        CGContextAddArcToPoint(context, w, y, w, y + r, r)
        CGContextAddLineToPoint(context, w, y + h - r)
        CGContextAddArcToPoint(context, w, y + h, w - r, y + h, r)
        
        //箭头
        CGContextAddLineToPoint(context, w / 2 + p / 1.3, y + h)
        CGContextAddLineToPoint(context, w / 2, y + h + p + 1)
        CGContextAddLineToPoint(context, w / 2 - p / 1.3, y + h)
        CGContextAddLineToPoint(context, kNavigationWidth, y + h)
        
        CGContextAddLineToPoint(context, kNavigationWidth, y)
        CGContextClosePath(context)
        CGContextFillPath(context)
    }
    
    func hasPortraitImageDrawPath() {
        let frame = self.bounds
        let x = frame.origin.x
        let y = frame.origin.y
        let w = frame.size.width
        let p: CGFloat = 4
        let h = frame.size.height - p
        let r: CGFloat = 10
        //只有文字
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backCGColor)
        CGContextMoveToPoint(context, x + r, y)
        CGContextAddLineToPoint(context, x + w - r, y)
        CGContextAddArcToPoint(context, x + w,  y, x + w , y + r, r)
        CGContextAddLineToPoint(context, x + w, y + h - r)
        CGContextAddArcToPoint(context, x + w, y + h, x + w - r, y + h, r)
        //箭头
        CGContextAddLineToPoint(context, w / 2 + p / 1.3, y + h)
        CGContextAddLineToPoint(context, w / 2, y + h + p + 1)
        CGContextAddLineToPoint(context, w / 2 - p / 1.3, y + h)
        CGContextAddLineToPoint(context, x + r, y + h)
        
        CGContextAddArcToPoint(context, x, y + h, x, y + h - r, r)
        CGContextAddLineToPoint(context, x, y + r)
        CGContextAddArcToPoint(context, x, y, x + r, y, r)
        
        CGContextClosePath(context)
        CGContextFillPath(context)

    }
    
    func onlyHasTextDrawPath() {
        let frame = self.bounds
        let x = frame.origin.x
        let y = frame.origin.y
        let w = frame.size.width
        let p: CGFloat = 4
        let h = frame.size.height - p
        let r: CGFloat = 10
        //只有文字
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextMoveToPoint(context, x + r, y)
        CGContextAddLineToPoint(context, x + w - r, y)
        CGContextAddArcToPoint(context, x + w,  y, x + w , y + r, r)
        CGContextAddLineToPoint(context, x + w, y + h - r)
        CGContextAddArcToPoint(context, x + w, y + h, x + w - r, y + h, r)
        //箭头
        CGContextAddLineToPoint(context, w / 2 + p / 1.3, y + h)
        CGContextAddLineToPoint(context, w / 2, y + h + p + 1)
        CGContextAddLineToPoint(context, w / 2 - p / 1.3, y + h)
        CGContextAddLineToPoint(context, x + r, y + h)
        
        CGContextAddArcToPoint(context, x, y + h, x, y + h - r, r)
        CGContextAddLineToPoint(context, x, y + r)
        CGContextAddArcToPoint(context, x, y, x + r, y, r)
        
        CGContextClosePath(context)
        CGContextFillPath(context)
    }

}