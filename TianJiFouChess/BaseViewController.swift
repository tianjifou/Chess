//
//  BaseViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import MBProgressHUD
import Hyphenate
class BaseViewController: UIViewController {
    static let letterOfChallenge = NSNotification.Name.init("letterOfChallenge")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        
        ChatHelpTool.share.networkState = { (state) in
            switch state {
            case EMConnectionConnected:()
                
            case EMConnectionDisconnected:
                PAMBManager.sharedInstance.showBriefMessage(message: "服务器已断开连接，请重试")
            default:
                ()
            }
        }
        if self.navigationController?.visibleViewController != self.navigationController?.viewControllers.first {
            let leftBtn = customLeftBackButtonItem()
            navigationItem.leftBarButtonItem = leftBtn
        }
        
       
    }
    
    private func customLeftBackButtonItem() -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 25.0, height: 18.0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "back_leftButton"), for: .normal)
        btn.contentHorizontalAlignment = .left
        return UIBarButtonItem(customView: btn)
    }
    func backAction() {
     self.navigationController?.popViewController(animated: true)
    }
    
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
       
        print(String(describing: self.classForCoder)+"已被释放")
      
    }

}

