//
//  FriendViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/17.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
import MJRefresh

class FriendViewController: BaseViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var friendArray:[UserModel] = []
    var textField:UITextField!
    var chessType:GameType?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "AddFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendTableViewCell")
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.setData()
            
        })
        
        ChatHelpTool.share.reloadFriendList = {
            self.setData()
        }
        
        

    }
    @IBAction func addFriends(_ sender: Any) {
        self.performSegue(withIdentifier: "pushSearchFriendViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushSearchFriendViewController" {
            let vc = segue.destination as! SearchFriendViewController
            vc.arrayFriend = self.friendArray
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    fileprivate func setData() {
        self.updating(withMessage: "")
        let error: AutoreleasingUnsafeMutablePointer<EMError?>? = nil
        DispatchQueue.global().async {
          let arr =  EMClient.shared().contactManager.getContactsFromServerWithError(error)
            DispatchQueue.main.async {
                self.updatingEnd()  
            }
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
          
            if let _ = error {
                
                self.getLocalData()
                
            }else{
                self.friendArray.removeAll()
                arr?.forEach({ (str) in
                    if let str = str as? String {
                        let user = UserModel()
                        user.userName = str
                        self.friendArray.append(user)
                    }
                    
                })
            }
            
            if self.friendArray.count == 0 {
               self.getLocalData()
               
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    fileprivate func getLocalData() {
        let arr = EMClient.shared().contactManager.getContacts()
        self.friendArray.removeAll()
        arr?.forEach({ (str) in
            if let str = str as? String {
                let user = UserModel()
                user.userName = str
                self.friendArray.append(user)
            }
        })
        if self.friendArray.count == 0 {
            DispatchQueue.main.async {
                self.nothing(withMessage: "一个好友也没有",buttonTitle:"去添加好友吧" ,action: {
                    self.performSegue(withIdentifier: "pushSearchFriendViewController", sender: nil)
                })
            }
            
        }
    }
    
    fileprivate func showAlertView(userName:String) {
        let alertView = UIAlertController.init(title: "挑战", message: "向\(userName)发起挑战？", preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertView.addTextField { (textField) in
            self.textField = textField
        }
        alertView.addAction(alertAction)
        let challengeAction = UIAlertAction.init(title: "挑战", style: .default) { (action) in
            
            let dic = ["gameType":"1","challengeList":["from":EMClient.shared().currentUsername,"to":userName,"message": self.textField.text.noneNull],"chessType":self.chessType == .fiveInRowChess ? "1" : "2"] as [String : Any]
            guard let message = ChatHelpTool.sendTextMessage(text: "games", toUser: userName, messageType: EMChatTypeChat, messageExt: dic)else{
                return
            }
            ChatHelpTool.senMessage(aMessage: message, progress: nil, completion: { (message, error) in
                if let error = error {
                    TJFTool.errorForCode(code: error.code)
                }else{
                    PAMBManager.sharedInstance.showBriefMessage(message: "发送成功")
                }
                print(message ?? "",error ?? "")
            })
        }
        alertView.addAction(challengeAction)
        self.view.window?.rootViewController?.present(alertView, animated: true, completion: nil)
    }

}

extension FriendViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendTableViewCell", for: indexPath) as! AddFriendTableViewCell
       
        cell.makeCell(model: self.friendArray[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userName = self.friendArray[indexPath.row].userName else {
            return
        }
        
        if self.chessType == nil {
            let view = UIAlertController.init(title: "棋型", message: "", preferredStyle: .actionSheet)
             let alertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let fiveAction = UIAlertAction.init(title: "五子棋", style: .default, handler: {(action) in
              self.chessType = .fiveInRowChess
                self.showAlertView(userName: userName)
            })
            let LiuAction = UIAlertAction.init(title: "六洲棋", style: .default, handler: {(action) in
                self.chessType = .LiuZhouChess
                self.showAlertView(userName: userName)
            })
            view.addAction(alertAction)
            view.addAction(fiveAction)
            view.addAction(LiuAction)
            self.view.window?.rootViewController?.present(view, animated: true, completion: nil)
            self.chessType = nil
        }else {
            self.showAlertView(userName: userName)
        }
        
       
    }
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        EMClient.shared().contactManager.deleteContact(self.friendArray[indexPath.row].userName, isDeleteConversation: true) { (str, error) in
            if error != nil {
                TJFTool.errorForCode(code: error!.code)
            }else {
                self.friendArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .none)
                PAMBManager.sharedInstance.showBriefMessage(message: "成功删除好友")
            }
        }
        
        
    }
}
