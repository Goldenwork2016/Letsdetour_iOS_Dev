//
//  ShareTravelViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 06/09/21.
//

import UIKit

class ShareTravelViewController: UIViewController {
    var PlanData : M_Plan_Detail_data!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var FollowList: UIView!
    @IBAction func ContactList(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "FollowerListViewController") as! FollowerListViewController
        vc.modalPresentationStyle = .fullScreen
        vc.ViewFrom = "Contact"
        vc.PlanData = PlanData

        present(vc, animated: true, completion: nil)
    }
    @IBAction func FollowList(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "FollowerListViewController") as! FollowerListViewController
        vc.modalPresentationStyle = .fullScreen
        vc.ViewFrom = "Follow"
        vc.PlanData = PlanData

        present(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
