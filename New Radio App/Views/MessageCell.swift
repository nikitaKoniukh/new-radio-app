//
//  MessageCell.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 05/04/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var dateMessage: UILabel!
    @IBOutlet weak var nameMessage: UILabel!
    @IBOutlet weak var textMessage: UILabel!
}
