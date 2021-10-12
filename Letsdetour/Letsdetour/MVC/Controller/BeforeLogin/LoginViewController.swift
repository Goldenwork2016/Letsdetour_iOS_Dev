//
//  LoginViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 24/08/21.
//

import UIKit

class LoginViewController: UIViewController , CloseMessagePopupDelegate{

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var LoginUser : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.text = "ios@orem.com"
        txtPassword.text = "Qwerty@1"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    

    @IBAction func ForgotPassword(_ sender: Any) {
        self.PresentViewController(identifier: "ForgotPasswordViewController")

    }
    @IBAction func SignUp(_ sender: Any) {
        self.PresentViewController(identifier: "SignUpViewController")

    }
    
    
    @IBAction func Login(_ sender: Any) {
        if txtUsername.CheckText(.Email) && txtPassword.CheckText(){
            ApiLogin()
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
    func ApiLogin()  {
        let dict = ["email" : txtUsername.text!,
                    "password" : txtPassword.text!]
        APIClients.loginWithEmail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""   )


                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    if response.user.verify == 0{
                        let vc = self.storyboard?.instantiateViewController(identifier: "PopupMessageViewController") as! PopupMessageViewController
                        vc.modalPresentationStyle = .overFullScreen
                        vc.Message = response.message ?? ""
                        vc.delegate = self
                        self.LoginUser =  response.user
                        self.present(vc, animated: false, completion: nil)
                    }
                    else{
                        Constants.Toast.MyToast(message: response.message ?? ""  )
                        DataManager.Auth_Token = response.token
                        DataManager.CurrentUserData = response.user
                        Constants.CurrentUserData = response.user
                        print( DataManager.CurrentUserData)
                        self.PresentViewController(identifier: "TabViewController")
                    }
                }


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }

    }
    func CloseMessagePopup() {
        let vc = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
        vc.modalPresentationStyle = .fullScreen
        vc.Phone = LoginUser.phone!
        vc.Country_Code = "\(LoginUser.country_code)"
        vc.Email = LoginUser.email!
        vc.isLogin = true
        self.present(vc, animated: true, completion: nil)
        
    }
}
