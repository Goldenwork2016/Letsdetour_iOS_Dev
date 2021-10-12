//
//  CloseAccountViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 20/09/21.
//

import UIKit
import IQKeyboardManagerSwift

class CloseAccountViewController: UIViewController  , CloseMessagePopupDelegate{

    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var c_table_h: NSLayoutConstraint!
    @IBOutlet weak var txtOther: IQTextView!
    @IBOutlet weak var tableView: UITableView!
    var ReasonDelete = ["Appliaction is not usefull", "I accidentally created another account" , "I'm concerned about privacy", "Find another application" ,"Other"]
    var ReasonDeactivate = ["Appliaction is not usefull", "I accidentally created another account" , "I'm concerned about privacy", "Find another application","Other"]

    var selectedReason : String = ""
    var ViewType : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if ViewType == "delete"{
            lblTitel.text = "Delete Account"
            lblTitle1.text = "Are you sure you want to delete your account?"
            lblTitle2.text = "Please let us know the reason why you are leaving"
        }
        else{
            lblTitel.text = "Deactivate Account"
            lblTitle1.text = "Are you sure you want to deactivate your account?"
            lblTitle2.text = "Please let us know the reason why you are leaving"
        }
        c_table_h.constant = 200

        txtOther.isHidden = true
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Done(_ sender: Any) {
        OpenPopupMessage( )
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
extension CloseAccountViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ViewType == "delete"{

            return ReasonDelete.count
        }
        return ReasonDeactivate.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.init(name: SystemFont.FontFamilyNameMedium, size: 16)
        if ViewType == "delete"{

            cell.textLabel?.text = ReasonDelete[indexPath.row]
            if ReasonDelete[indexPath.row] == selectedReason{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none

            }
            return cell
        }
        else{
            cell.textLabel?.text = ReasonDeactivate[indexPath.row]

            if ReasonDeactivate[indexPath.row] == selectedReason{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none

            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ViewType == "delete"{

            selectedReason = ReasonDelete[indexPath.row]
        }
        else{
            selectedReason = ReasonDeactivate[indexPath.row]

        }
        tableView.reloadData()
        if selectedReason == "Other"{
            txtOther.isHidden = false
        }
        else{
            txtOther.isHidden = true

        }

    }
    func OpenPopupMessage( )  {
        let vc = storyboard?.instantiateViewController(identifier: "PopupMessageViewController") as! PopupMessageViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.Message = lblTitle1.text!
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }
    func CloseMessagePopup() {
        self.dismiss(animated: false, completion: nil)
    }
}
