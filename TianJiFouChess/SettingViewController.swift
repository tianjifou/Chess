//
//  SettingViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/7/7.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
class SettingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutAction(_ sender: Any) {
        EMClient.shared().logout(true) { (error) in
            if let error = error {
                TJFTool.errorForCode(code: error.code)
            }else {
                TJFTool.setRootVCInitialViewController(storyboardName: "Login")
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
