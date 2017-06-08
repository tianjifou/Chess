//
//  PALoadingView.swift
//  wanjia2B
//
//  Created by 陈龙坤 on 17/2/13.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit
import MBProgressHUD
import HexColors
import Masonry
class PALoadingView: UIView {

    lazy var containerView: UIView = {
        var containerView = UIView()
        containerView.backgroundColor = UIColor(hexString: "#F0F0F0")
        containerView.alpha = 0.5
        containerView.isUserInteractionEnabled = true
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = true
        
        return containerView
    }()
    
    var loadingViewWidth: CGFloat = 120.0 * PADeviceSize.screenHeight/736.0
    let loadingViewheight: CGFloat = 120.0 * PADeviceSize.screenHeight/736.0
//    var iPhone6Plus_screenHeight: CGFloat = 736.0
    
    var detailText: String?
    
    lazy var labelText: UILabel = {
        var label = UILabel.createLabel(fontSize: 15, textColor: UIColor.green)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        if PADeviceSize.RETIAN_4_0 {
            label.font = UIFont.systemFont(ofSize: 13)
        } else if PADeviceSize.IPHONE_4_7 {
            label.font = UIFont.systemFont(ofSize: 14)
        } else if PADeviceSize.IPHONE_5_5 {
            label.font = UIFont.systemFont(ofSize: 15)
        }
        return label
    }()
    
    var fourRound : CALayer?

    init(labelText: String?) {
        super.init(frame: .zero)
        detailText = labelText
        instanceViewWithSuperView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    class func showLoadingView(view: UIView?, labelText: String?, isTranslucent: Bool = true, animated: Bool = true) -> MBProgressHUD {
        let loadingView = PALoadingView.init(labelText: labelText)
        let hud = MBProgressHUD.showAdded(to: view ?? (UIApplication.shared.delegate as! AppDelegate).window!, animated: animated)
        if !isTranslucent {
            hud!.backgroundColor = view?.backgroundColor
        }
        hud!.mode = .customView
        hud!.customView = loadingView
        hud!.opacity = 0
        
        return hud!
    }
    
    func instanceViewWithSuperView() {
        
        var height: CGFloat = 0.0
        if detailText != nil && detailText != "" {
            
            let width: CGFloat = TJFString.widthForString(detailText!, font: self.labelText.font) + 10
            if width > loadingViewWidth && width < 210 {
                loadingViewWidth = width
            } else if width > 210 {
                loadingViewWidth = 210
            }
            height = 20.0
        }
        self.frame = CGRect.init(x: 0, y: 0, width: self.loadingViewWidth, height: self.loadingViewheight-height)

        self.addSubview(self.containerView)
        self.containerView.mas_makeConstraints { (make) in
            make!.left.top().right().mas_equalTo()(self)!.setOffset(0)
            make!.bottom.mas_equalTo()(self)!.setOffset(height)
        }

        if detailText != nil && detailText != "" {
            self.addSubview(self.labelText)
            labelText.mas_makeConstraints { (make) in
                make!.top.mas_equalTo()(self.mas_bottom)!.setOffset(-5)
                make!.left.equalTo()(self)!.offset()(5)
                make!.right.equalTo()(self)!.offset()(-5)
            }
            self.labelText.text = detailText
        }
        
        let replicatorLayerWidth: CGFloat = 30.0
        fourRound = loadingReplicatorLayerRoundDot()
        
        self.layer.addSublayer(fourRound!)
        fourRound?.bounds = CGRect(x: 0, y: 0, width: replicatorLayerWidth, height: replicatorLayerWidth)
        fourRound?.position = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    
    func dismissLoadingView() -> Void {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.alpha = 0
        }) { (finished) in
            self.containerView.layer.removeAllAnimations()
            self.containerView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}

extension PALoadingView {
 
    func creatShapeLayerWithRadius(radius: CGFloat) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        layer.path = UIBezierPath.init(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        layer.fillColor = UIColor.green.cgColor
        layer.strokeColor = UIColor.green.cgColor
        
        return layer
    }
    
    func loadingReplicatorLayerRoundDot() -> CALayer {

        let sigleSquareDiameter: CGFloat = 10.0
        let layer = creatShapeLayerWithRadius(radius: sigleSquareDiameter)
        layer.add(addReplicatorLayerScaleAnition(), forKey: "scale")
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
        
        ///复制多个圆
        let instanceCount: Int = 8
        var transform3D: CATransform3D = CATransform3DIdentity
        let i = 2 * Double.pi/Double(instanceCount)
        transform3D = CATransform3DRotate(transform3D, CGFloat(i), 0, 0, 1)
        let replicatorLayer = creatReplicatorLayerWithCount(transform: transform3D, count: instanceCount, copyLayer: layer)
        replicatorLayer.instanceDelay = 1.0/Double(instanceCount)
        
        return replicatorLayer
    }
    
    func addReplicatorLayerScaleAnition() -> CABasicAnimation {
        
        let basic = CABasicAnimation(keyPath: "transform.scale")
        basic.repeatCount = MAXFLOAT
        basic.fromValue = 1
        basic.toValue = 0
        basic.duration = 1.0
        basic.isRemovedOnCompletion = false
        
        return basic
    }
    
    func creatReplicatorLayerWithCount(transform: CATransform3D,count: Int,copyLayer: CALayer) -> CAReplicatorLayer {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceTransform = transform
        replicatorLayer.frame = copyLayer.frame
        replicatorLayer.addSublayer(copyLayer)
        
        return replicatorLayer
    }
}
let PAMBProgressMsgLoading : String = "加载中..."
let PAMBProgressMsgTimeInterval : TimeInterval = 3.0

// 是否忽略弹框枚举
enum PAHUDIgnore {
    static let requestCanceled = "isPARequestCanceled"
    
    case ignore
    case unIgnore
    
    init(value: String) {
        switch value {
        case PAHUDIgnore.requestCanceled:
            self = .ignore
        default:
            self = .unIgnore
        }
    }
}

class PAMBManager: NSObject {
    
    static var sharedInstance: PAMBManager = PAMBManager()
    
    ///转圈
    @discardableResult
    @objc func showLoading(view: UIView?, isTranslucent: Bool = true) -> MBProgressHUD {
        return showLoadingInView(view: getActiveView(view: view), labelText: nil, isTranslucent: isTranslucent)
    }
    
    ///隐藏
    func hideAlert(view: UIView?) -> Void {
        MBProgressHUD.hideAllHUDs(for: getActiveView(view: view), animated: true)
    }
    
    ///提示，3秒后消失
    func showBriefAlert(alert: String?) -> Void {
        showBriefMessage(message: alert, view: nil)
    }
    
    ///向下偏移yOffset
    @objc func showBriefAlert(alert: String?,yOffset:float_t) -> Void {
        if let hud: MBProgressHUD = showBriefMessage(message: alert, view: nil) {
            hud.yOffset = Float(yOffset)
        }
    }
    
    @discardableResult
    func showBriefMessage(message: String?, view: UIView? = nil, after delay: TimeInterval = PAMBProgressMsgTimeInterval) -> MBProgressHUD? {
        let alertIgnore: PAHUDIgnore = PAHUDIgnore(value: message.noneNull)
        if alertIgnore == .ignore {
            return nil
        }
        
        let topView = getActiveView(view: view)
        MBProgressHUD.hideAllHUDs(for: topView, animated: false)
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: topView, animated: true)
        hud.detailsLabelText = message ?? "网络请求失败，请检查网络"
        hud.isUserInteractionEnabled = false
        hud.mode = .text
        hud.detailsLabelFont = UIFont.systemFont(ofSize: 14)
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: delay)
        
        return hud
    }
    
    ///返回一个hud
    @discardableResult
    func showLoadingInView(view: UIView?,labelText: String?,isTranslucent: Bool = true) -> MBProgressHUD {
        let topView = getActiveView(view: view)
        MBProgressHUD.hideAllHUDs(for: topView, animated: false)
        return PALoadingView.showLoadingView(view: topView, labelText: labelText, isTranslucent: isTranslucent)
    }
    
    ///显示图片
    func show(text: String,icon: String = "mbprogress_success",view: UIView?) -> Void {
        let alertIgnore: PAHUDIgnore = PAHUDIgnore(value: text)
        if alertIgnore == .ignore {
            return
        }
        let topView = getActiveView(view: view)
        MBProgressHUD.hideAllHUDs(for: topView, animated: false)
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: topView, animated: true)
        hud.labelText = text
        hud.customView = UIImageView.init(image: UIImage.init(named: icon))
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: PAMBProgressMsgTimeInterval)
    }
    
    fileprivate func getActiveView(view:UIView?)->UIView{
        return view ?? (UIApplication.shared.delegate as! AppDelegate).window!
    }
}

