//
//  FiveInRowChessViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/7/7.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

class FiveInRowChessViewController: BaseViewController {
    
    @IBAction func aiAnHumAction(_ sender: Any) {
        self.performSegue(withIdentifier: "pushFiveChess", sender: "aiGame")
    }
   
    @IBAction func sameFighting(_ sender: Any) {
        self.performSegue(withIdentifier: "pushFiveChess", sender: "manAndMachineFighting")
    }
    var condition1 = false
    var condition2 = false
    @IBAction func bluetoothActon(_ sender: Any) {
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
            messageVo.chessType = 1
            
            BluetoothTool.blueTooth.sendData(messageVo, successBlock: nil) { (error) in
                PAMBManager.sharedInstance.showBriefMessage(message: "\(error)")
            }
          weakSelf.condition1 = true
          weakSelf.pishFiveChessVC()
          
        }
        self.present(browser, animated: true, completion: nil)
    }
    @IBAction func onlineAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FriendViewControllerId")as! FriendViewController
        vc.hidesBottomBarWhenPushed = true
        vc.chessType = .fiveInRowChess
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if model.chessType == 1{
                weakSelf.condition2 = true
                weakSelf.pishFiveChessVC()
            }else if model.chessType == 2 {
                PAMBManager.sharedInstance.showBriefMessage(message: "你与对方游戏类型不匹配")
            }
            
        }
    }
    
    private func pishFiveChessVC(){
        if condition1 && condition2 {
           self.performSegue(withIdentifier: "pushFiveChess", sender: "bluetoothFighting")
            condition1 = false
            condition2 = false
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushFiveChess" {
            let vc = segue.destination as! ChessViewController
            vc.chessType = .fiveInRowChess
            switch sender as! String {
            case "aiGame":
                vc.viewType = .aiGame
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


}
