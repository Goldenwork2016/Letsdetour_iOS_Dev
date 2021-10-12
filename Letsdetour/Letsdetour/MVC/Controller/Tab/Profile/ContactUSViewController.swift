//
//  ContactUSViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import IQKeyboardManagerSwift

class ContactUSViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMessage: IQTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = Constants.CurrentUserData.user_name
        txtEmail.text = Constants.CurrentUserData.email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Send(_ sender: Any) {
        if txtName.CheckText() && txtEmail.CheckText(.Email) && CheckTextField().CheckText(text: txtMessage.text!, String_type: "Message"){
            PostContactAdmin()
        }
    }
    func PostContactAdmin()  {
        let dict = [
            "email" : txtEmail.text!,
            "message" : txtMessage.text!,
                    ] as [String : Any]
        

        APIClients.POST_user_contactAdmin(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
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
