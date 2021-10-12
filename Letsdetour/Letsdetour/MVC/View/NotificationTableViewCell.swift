//
//  NotificationTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 27/09/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewCheck: UIView!
    @IBOutlet weak var lblNotification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
