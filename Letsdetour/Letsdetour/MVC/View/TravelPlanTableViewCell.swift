//
//  TravelPlanTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 02/09/21.
//

import UIKit

class TravelPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var More: UIButton!
    @IBOutlet weak var Share: UIButton!
    @IBOutlet weak var Edit: UIButton!
    @IBOutlet weak var Delete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
