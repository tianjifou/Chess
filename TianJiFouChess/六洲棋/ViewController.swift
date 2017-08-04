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
    var condition1 = false
    var condition2 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BluetoothTool.blueTooth.getMessageBlock = {[weak self](message) in
            guard let weakSelf = self else {
                return
            }
            guard let model = message as? ChallengeMessage  else {
                return
            }
            if model.chessType == 2{
                weakSelf.condition2 = true
                weakSelf.pishFiveChessVC()
            }else if model.chessType == 1 {
                PAMBManager.sharedInstance.showBriefMessage(message: "你与对方游戏类型不匹配")
            }
           
            
        }
    }
    private func pishFiveChessVC(){
        if condition1 && condition2 {
            self.performSegue(withIdentifier: "pushChessViewController", sender: "bluetoothFighting")
            condition1 = false
            condition2 = false
        }
        
    }
     
    @IBAction func logOutAction(_ sender: Any) {
        let vc =  WebViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func manAndMachineFighting(_ sender: Any) {
        self.performSegue(withIdentifier: "pushChessViewController", sender: "manAndMachineFighting")
    }
    
    @IBAction func bluetoothFighting(_ sender: Any) {
        
        let bluetooth = BluetoothTool.blueTooth
         bluetooth.start()
        guard  let browser =  bluetooth.setupBrowserVC() else {return}
        bluetooth.browserBlock = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let messageVo = ChallengeMessage()
            messageVo.from = UIDevice.current.name
            messageVo.to = (BluetoothTool.blueTooth.myPeer?.displayName).noneNull
            messageVo.chessType = 2
            
            BluetoothTool.blueTooth.sendData(messageVo, successBlock: nil) { (error) in
                PAMBManager.sharedInstance.showBriefMessage(message: "\(error)")
            }
            weakSelf.condition1 = true
            weakSelf.pishFiveChessVC()
        }
        self.present(browser, animated: true, completion: nil)
    }
    
    @IBAction func onlineFighting(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FriendViewControllerId") as! FriendViewController
            vc.hidesBottomBarWhenPushed = true
             vc.chessType = .LiuZhouChess
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
  
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushChessViewController" {
            let vc = segue.destination as! ChessViewController
            vc.chessType = .LiuZhouChess
            switch sender as! String {
            case "manAndMachineFighting":
                vc.viewType = .manAnMachine
            case "bluetoothFighting":
                vc.viewType = .bluetooth
            case "onlineFighting":
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

