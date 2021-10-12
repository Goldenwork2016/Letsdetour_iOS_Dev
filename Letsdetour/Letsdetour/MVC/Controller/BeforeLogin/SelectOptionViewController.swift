//
//  SelectOptionViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 24/08/21.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SelectOptionViewController: UIViewController {

    @IBOutlet weak var viewAppleLogin: UIView!
    @IBOutlet weak var btnFaceBook: FBLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setUpSignInAppleButton(btn: viewAppleLogin)
    }
    @IBAction func Facebook(_ sender: UIButton) {
        self.FaceBookLogin()
    }
    @IBAction func Google(_ sender: UIButton) {
        self.GoogleLogin(btn: sender)
    }
    

    @IBAction func Login(_ sender: Any) {
        self.PresentViewController(identifier: "LoginViewController")
    }
    @IBAction func SignUp(_ sender: Any) {
        self.PresentViewController(identifier: "SignUpViewController")

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
