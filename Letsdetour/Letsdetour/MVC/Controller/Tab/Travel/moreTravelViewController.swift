//
//  moreTravelViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 04/10/21.
//

import UIKit

protocol moreTravelDelegate {
    func moreClose(action : Int)
}


class moreTravelViewController: UIViewController {
    var PlanDetail : M_Plan_data!
    var delegate : moreTravelDelegate!
    @IBOutlet weak var viewEdit: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEdit.isHidden = true
        print(PlanDetail)
        if PlanDetail.id == Constants.CurrentUserData.id || PlanDetail.permission == 2{
            viewEdit.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Share(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate.moreClose(action: 3)
        }
    }
    
    @IBAction func Edit(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate.moreClose(action: 2)
        }

    }
    @IBAction func Delete(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate.moreClose(action: 1)
        }

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
