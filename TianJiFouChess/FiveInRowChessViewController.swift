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
    @IBAction func bluetoothActon(_ sender: Any) {
        let bluetooth = BluetoothTool.blueTooth
        bluetooth.setupBrowserVC()
        bluetooth.browserBlock = { [weak self] in
            self?.performSegue(withIdentifier: "pushFiveChess", sender: "bluetoothFighting")
        }
        self.present(bluetooth.browser!, animated: true, completion: nil)
    }
    @IBAction func onlineAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FriendViewControllerId")as! FriendViewController
        vc.hidesBottomBarWhenPushed = true
        vc.gameType = .fiveInRowChess
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushChessViewController" {
            let vc = segue.destination as! ChessViewController
            vc.gameType = .fiveInRowChess
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
