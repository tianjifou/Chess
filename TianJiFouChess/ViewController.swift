//
//  ViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 17/4/28.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate


class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    @IBAction func gameExplain(_ sender: Any) {
        let vc =  WebViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func logOutAction(_ sender: Any) {
        EMClient.shared().logout(true) { (error) in
            if let error = error {
                TJFTool.errorForCode(code: error.code)
            }else {
                TJFTool.setRootVCInitialViewController(storyboardName: "Login")
            }
            
        }
    }
    
    @IBAction func manAndMachineFighting(_ sender: Any) {
        self.performSegue(withIdentifier: "pushChessViewController", sender: "manAndMachineFighting")
    }
    
    @IBAction func bluetoothFighting(_ sender: Any) {
        
        let bluetooth = BluetoothTool.blueTooth
        bluetooth.setupBrowserVC()
        bluetooth.browserBlock = { [weak self] in
            self?.performSegue(withIdentifier: "pushChessViewController", sender: "bluetoothFighting")
        }
        self.present(bluetooth.browser!, animated: true, completion: nil)
    }
    
    @IBAction func onlineFighting(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FriendViewControllerId")
       vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushChessViewController" {
            switch sender as! String {
            case "manAndMachineFighting":
                let vc = segue.destination as! ChessViewController
                vc.viewType = .manAnMachine
            case "bluetoothFighting":
                let vc = segue.destination as! ChessViewController
                vc.viewType = .bluetooth
            case "onlineFighting":
                let vc = segue.destination as! ChessViewController
                vc.viewType = .online
            default:
                ()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

