//
//  UserTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 06/09/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
