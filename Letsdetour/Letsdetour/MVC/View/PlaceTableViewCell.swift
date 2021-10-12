//
//  PlaceTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 04/09/21.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
