//
//  ReviewTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import Cosmos
class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var viewRate: CosmosView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
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
