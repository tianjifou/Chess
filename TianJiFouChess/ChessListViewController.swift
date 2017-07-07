//
//  ChessListViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/7/7.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

class ChessListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var  arrData:[String] = ["五子棋","六洲棋"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String.init(describing: UITableViewCell.self))
        tableView.rowHeight = 44
        
        title = "游戏列表"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

extension ChessListViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = arrData[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch arrData[indexPath.row] {
        case "五子棋":
            self.performSegue(withIdentifier: "pushFiveInRowChessViewController", sender: "五子棋")
        case "六洲棋":
            self.performSegue(withIdentifier: "pushViewController", sender: "六洲棋")
        default:
            ()
        }
    }
}
