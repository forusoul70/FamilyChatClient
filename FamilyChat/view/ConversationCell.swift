//
//  ConversationCell.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 19..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
