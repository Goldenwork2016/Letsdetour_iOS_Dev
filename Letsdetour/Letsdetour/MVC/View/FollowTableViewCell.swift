//
//  FollowTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 27/08/21.
//

import UIKit

class FollowTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
