//
//  MessageViewCell.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 21..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var receivedText: UILabel!
    @IBOutlet weak var sendText: UILabel!
    @IBOutlet weak var receivedData: UILabel!
    @IBOutlet weak var sendDate: UILabel!
    
    @IBOutlet weak var receivedContainer: UIStackView!
    @IBOutlet weak var sendContainer: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
