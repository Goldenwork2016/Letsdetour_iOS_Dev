//
//  PlaceHeaderTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 04/09/21.
//

import UIKit

class PlaceHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var btnRoute: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
