//
//  LogonViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
let USERNAME = "userName"
class LogonViewController: BaseViewController ,UITextFieldDelegate{

    @IBOutlet weak var namefield: UITextField!
   
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.keyboardType = .twitter
        passwordField.isSecureTextEntry = true
        
        if let userName = UserDefaults.standard.object(forKey: USERNAME) as? String {
            namefield.text = userName
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }

    @IBAction func registerAction(_ sender: Any) {
        if !createErrorShowRetrue() {
            return
        }
        self.updating(withMessage: "")
        DispatchQueue.global(qos: .default).async {
           let error = EMClient.shared().register(withUsername: TJFString.cleanString(self.namefield.text!) , password: TJFString.cleanString(self.passwordField.text!))
            DispatchQueue.main.async {
                   self.updatingEnd()
            }
         
            if let error = error {
                DispatchQueue.main.async {
                    TJFTool.errorForCode(code: error.code)
                }
            }else {
                DispatchQueue.main.async {
                      PAMBManager.sharedInstance.showBriefMessage(message: "注册成功")
                }
              
                print("注册成功")
            }
        }
    }
    
    @IBAction func logonAction(_ sender: Any) {
        if !createErrorShowRetrue() {
            return
        }
        self.updating(withMessage: "")
        DispatchQueue.global(qos: .default).async {
            let error = EMClient.shared().login(withUsername: TJFString.cleanString(self.namefield.text!) , password: TJFString.cleanString(self.passwordField.text!))
            DispatchQueue.main.async {
                self.updatingEnd()
            }
            if let error = error {
                DispatchQueue.main.async {
                    TJFTool.errorForCode(code: error.code)
                }
            }else {
                print("登录成功")
                EMClient.shared().options.isAutoLogin = true
                self.saveUserInformation()
                DispatchQueue.main.async {
                   self.changeRootViewConrroller() 
                }
                
                
            }
        }
    }
    
    private func changeRootViewConrroller() {
        TJFTool.setRootVCInitialViewController(storyboardName: "Main")
       
    }
    
    private func saveUserInformation() {
        
        if let userName = EMClient.shared().currentUsername, userName.characters.count > 0{
             UserDefaults.standard.setValue(userName, forKey: USERNAME)
             UserDefaults.standard.synchronize()
        }
        
    }
    
    private func createErrorShowRetrue() ->Bool {
        if let str =  namefield.text {
            if str.isChenese() {
                 PAMBManager.sharedInstance.showBriefMessage(message: "账户不能输入中文字符")
                return false
            }
            
        }
        
        if TJFString.isEmptyString(namefield.text) {
            PAMBManager.sharedInstance.showBriefMessage(message: "账户为空")
            return false
        }
        
        if TJFString.isEmptyString(passwordField.text) {
            PAMBManager.sharedInstance.showBriefMessage(message: "密码为空")
            return false
        }
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
