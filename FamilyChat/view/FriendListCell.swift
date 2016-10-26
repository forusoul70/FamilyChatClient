//
//  FriendListCell.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 10. 26..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!    
    @IBOutlet weak var profileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
