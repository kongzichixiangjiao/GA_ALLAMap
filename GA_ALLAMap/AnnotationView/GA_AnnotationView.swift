//
//  GA_AnnotationView.swift
//  GA_AMap_Swift
//
//  Created by houjianan on 15/11/3.
//  Copyright © 2015年 houjianan. All rights reserved.
//

import MapKit

let kNavigationWidth: CGFloat = 45
let kSpaceWidth: CGFloat = 8
class GA_AnnotationView: MAAnnotationView {
    private let imageName                 = "Dota2_003.jpg"
    private let kCalloutHeight: CGFloat   = 34.0
    private let space: CGFloat            = 5
    private let pinImageName: String      = "小人"
    private let titleString: String       = "SB"
    
    var calloutView: GA_CalloutView!
    var subTitle            = ""
    var describeString      = ""
    var hasNavigation: Bool = false
    var portraitImage: UIImage?
    var imagePostionType: ImagePostionType = .LEFT
    
    typealias ShowActionSheetHandler = () -> ()
    var showActionSheetHandler: ShowActionSheetHandler!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        annotationCreateUI()
    }
    
    func annotationCreateUI() {
        let pinImage         = UIImage(named: pinImageName)!
        let pinW: CGFloat    = pinImage.size.width / 3
        let pinH: CGFloat    = pinImage.size.height / 3
        let x: CGFloat       = 0
        let y: CGFloat       = 0
        let w: CGFloat       = pinW * 2 + space
        let h: CGFloat       = pinH + space
        self.bounds          = CGRectMake(x, y, w, h)
        self.backgroundColor = UIColor.whiteColor()
        
        let pX: CGFloat = space
        let pY: CGFloat = space
        let pW: CGFloat = pinW
        let pH: CGFloat = pinH
        let portraitImageView = UIImageView(frame: CGRectMake(pX, pY, pW, pH))
        portraitImageView.image = pinImage
        self.addSubview(portraitImageView)
        
        let tX: CGFloat            = CGRectGetMaxX(portraitImageView.frame)
        let tW: CGFloat            = w - pW - space
        let tH: CGFloat            = 16
        let tY: CGFloat            = h / 2 - tH / 2
        let titleLabel             = UILabel(frame: CGRectMake(tX, tY, tW, tH))
        titleLabel.text            = titleString
        titleLabel.textAlignment   = .Center
        titleLabel.font            = UIFont.systemFontOfSize(12)
        titleLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(titleLabel)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if self.selected == selected {return}
        if selected {
            if calloutView == nil {
                let fontSizeWidth = widthForComment(subTitle, fontSize: 12)
                var w: CGFloat = 0
                if hasNavigation {
                    w = fontSizeWidth + kNavigationWidth + kSpaceWidth * 2
                } else {
                    if portraitImage != nil {
                        hasNavigation   = false
                        let pW: CGFloat = portraitImage!.size.width > 20 ? 20 : portraitImage!.size.width
                        w = fontSizeWidth + pW + kSpaceWidth * 3
                    } else {
                        w = fontSizeWidth + kSpaceWidth * 2
                    }
                }
                let x: CGFloat = -w / 2 + self.frame.size.width / 2 + self.calloutOffset.x
                let y: CGFloat = -kCalloutHeight + self.calloutOffset.y
                calloutView = GA_CalloutView(frame: CGRectMake(x, y, w, kCalloutHeight),
                                             textWidth: fontSizeWidth,
                                             portraitImage: portraitImage,
                                             imagePostion: imagePostionType,
                                             hasNavigation: hasNavigation,
                                             subTitle: subTitle,
                                             describeString: describeString)
                calloutView.navigationTapHandler = {
                    [weak self] in
                    if let weakSelf = self {
                        if let handler = weakSelf.showActionSheetHandler {
                            handler()
                        }
                    }
                }
                self.addSubview(calloutView)
            }
        } else {
            calloutView.removeFromSuperview()
            calloutView = nil
        }
        
        super.setSelected(selected, animated: animated)
    }
    
    func widthForComment(comment: String, fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFontOfSize(fontSize)
        let rect = NSString(string: comment).boundingRectWithSize(CGSize(width: CGFloat(MAXFLOAT), height: height), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.width)
    }
}
