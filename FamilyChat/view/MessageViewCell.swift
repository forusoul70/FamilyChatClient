//
//  MessageViewCell.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 21..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var sendContainer: UIView!
    @IBOutlet weak var receivedContainer: UIView!
    
    @IBOutlet weak var receivedBody: UILabel!
    @IBOutlet weak var receivedTiimestamp: UILabel!
    @IBOutlet weak var sendBody: UILabel!
    @IBOutlet weak var sendTimestamp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
