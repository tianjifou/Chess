//
//  AddFriendTableViewCell.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/18.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    private var model:UserModel?
    var addFriendMessage:((String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func makeCell(model:UserModel) {
        self.model = model
        nameLabel.text = model.userName.noneNull == "tianjifou" ? "tianjifou(\("作者"))" : model.userName.noneNull
        rejectBtn.isHidden = false
        addBtn.isHidden = false
        if model.type == 0 {
          rejectBtn.isHidden = true
            addBtn.isHidden = true
        }else if model.type == 1 {
            rejectBtn.isHidden = true
            addBtn.isHidden = false
        }
        
    }
    @IBAction func addFriendAction(_ sender: Any) {
        guard let name = self.model?.userName else {
            return
        }
        if self.model?.type == 1 {
           addFriendMessage?(name)
        }else{
            EMClient.shared().contactManager.acceptInvitation(forUsername: name)
        }
        
       
    }

    @IBAction func rejectAction(_ sender: Any) {
        guard let name = self.model?.userName else {
            return
        }
        EMClient.shared().contactManager.declineInvitation(forUsername: name)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
