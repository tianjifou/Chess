//
//  SearchFriendViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/18.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

class SearchFriendViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrayFriend:[UserModel]?
    var dataArray:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "AddFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendTableViewCell")
        let btn = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchFriend))
        self.navigationItem.rightBarButtonItem = btn
        
        searchBar.delegate = self
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(taprecongnizer))
        tableView.addGestureRecognizer(tap)
    }
    func taprecongnizer() {
        self.view.endEditing(true)
    }
    
    func searchFriend(){
        if let str = searchBar.text,str.isChenese() {
             PAMBManager.sharedInstance.showBriefMessage(message: "账号不能出现中文字符")
            return
        }
        
        if TJFString.isEmptyString(searchBar.text) {
            PAMBManager.sharedInstance.showBriefMessage(message: "账号不能为空")
            return
        }
        
        if let str = searchBar.text,(str as NSString).range(of: " ").location != NSNotFound{
            PAMBManager.sharedInstance.showBriefMessage(message: "账号不能有空格")
            return
        }
        
        if !filterUserName() {
            let user = UserModel()
            user.userName = searchBar.text!
            user.type = 1
            dataArray.append(user)
            tableView.reloadData()
        }
        
    }
    
    func filterUserName() ->Bool{
        guard let str = searchBar.text else {
            return false
        }
        guard let friendArray = arrayFriend  else {
            return false
        }
        
        let predicate = NSPredicate.init(format: "userName == %@",str)
        
        let arr = (friendArray as NSArray).filtered(using: predicate)
        if arr.count > 0 {
             PAMBManager.sharedInstance.showBriefMessage(message: "此人已是好友")
            return true
        }
        return false
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
extension SearchFriendViewController :UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchFriend()
        self.view.endEditing(true)
    }
}
extension SearchFriendViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendTableViewCell", for: indexPath) as! AddFriendTableViewCell
        
        cell.makeCell(model: self.dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
