//
//  OTPViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 08/09/21.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var txtOTP: UITextField!
    
    var Country_Code : String = ""
    var Phone : String = ""
    var Email : String = ""
    var OTP : String = ""
    var isLogin : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        txtOTP.text = OTP

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if isLogin{
            ApiResendOTP()
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func Done(_ sender: Any) {
        if txtOTP.CheckText(){
            ApiVerifyOTP()
        }
        
    }
    @IBAction func Resend(_ sender: Any) {
        ApiResendOTP()
    }
    func ApiVerifyOTP()  {
        let dict = ["email" : Email,
                    "country_code" : Country_Code,
                    "phone" : Phone,
                    "otp" : txtOTP.text!,
                    "type" : 1
        ] as [String : Any]
        APIClients.VerifyOTP(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.PresentViewController(identifier: "LoginViewController")

                }
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }

    }
    func ApiResendOTP()  {
        let dict = ["email" : Email,
                    "country_code" : Country_Code,
                    "phone" : Phone,
                    
                    ]
        APIClients.resendOTP(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message  )

                
                if self.isAppDevelopment(){
                    self.txtOTP.text = "\(response.data.otp)"
                }
            
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
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
