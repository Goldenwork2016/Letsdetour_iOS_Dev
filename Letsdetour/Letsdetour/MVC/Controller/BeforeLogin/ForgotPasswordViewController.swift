//
//  ForgotPasswordViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 24/08/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController , CloseMessagePopupDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Send(_ sender: Any) {
        if txtEmail.CheckText(.Email){
            ApiForgotPassword()
        }
    }
    @IBAction func back(_ sender: Any) {
        Dismiss()
    }
    func ApiForgotPassword()  {
        let dict = ["email" : txtEmail.text!,
                    ]
        APIClients.ForgotPassword(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.OpenPopupMessage(msg: response.message)
            
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func OpenPopupMessage(msg : String )  {
        let vc = storyboard?.instantiateViewController(identifier: "PopupMessageViewController") as! PopupMessageViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.Message = msg
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }

    /*
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func CloseMessagePopup() {
        self.dismiss(animated: false, completion: nil)
    }

}
