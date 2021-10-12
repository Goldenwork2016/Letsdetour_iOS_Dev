//
//  SettingViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import GoogleSignIn

class SettingViewController: UIViewController {
    @IBOutlet weak var btnNoOne: UIButton!
    @IBOutlet weak var btnFrinds: UIButton!
    
    @IBOutlet weak var btnPublic: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNoOne.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)
        btnFrinds.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)
        btnPublic.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)

        // Do any additional setup after loading the view.
    }
    @IBAction func Public(_ sender: Any) {
        btnFrinds.isSelected = false
        btnNoOne.isSelected = false
        btnPublic.isSelected = true

    }
    @IBAction func CloseAccount(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CloseAccountViewController") as! CloseAccountViewController
        vc.modalPresentationStyle = .fullScreen
        vc.ViewType = "delete"
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func DeactivateAccount(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CloseAccountViewController") as! CloseAccountViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func NoOne(_ sender: Any) {
        btnFrinds.isSelected = false
        btnNoOne.isSelected = true
        btnPublic.isSelected = false
    }
    @IBAction func onlyFriends(_ sender: Any) {
        btnFrinds.isSelected = true
        btnNoOne.isSelected = false
        btnPublic.isSelected = false
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func ChangePassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func LogOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()

        DataManager.Auth_Token = nil
        DataManager.CurrentUserData = nil
        Constants.CurrentUserData = nil
        let vc = storyboard?.instantiateViewController(identifier: "SelectOptionViewController") as! SelectOptionViewController
        vc.modalPresentationStyle = .fullScreen
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
