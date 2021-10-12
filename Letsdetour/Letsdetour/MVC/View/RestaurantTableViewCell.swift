//
//  RestaurantTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 09/09/21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
