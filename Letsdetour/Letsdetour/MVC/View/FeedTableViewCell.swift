//
//  FeedTableViewCell.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var imgFeed: UIImageView!
    @IBOutlet weak var lblNumberOfComments: UILabel!
    @IBOutlet weak var lblNumberOfLikes: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
