//
//  ChangePasswordViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var lblCurrentPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Update(_ sender: Any) {
        if lblCurrentPassword.CheckText(.Password) && txtNewPassword.CheckText(.Password) && txtConfirmPassword.CheckText(.Password) && txtNewPassword.MatchPassword(txt: txtConfirmPassword){
            GetChangePassword()
        }
    }
    func GetChangePassword()  {
        let dict = ["current_password" : lblCurrentPassword.text!,
                    "new_password" : txtNewPassword.text!,
                    "new_confirm_password" : txtConfirmPassword.text!
                    ] as [String : Any]
        

        APIClients.ChangePassword(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.Dismiss()
                }
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
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
