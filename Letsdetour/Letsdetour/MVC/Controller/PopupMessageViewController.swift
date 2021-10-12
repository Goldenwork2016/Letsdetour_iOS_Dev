//
//  PopupMessageViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 13/09/21.
//

import UIKit

protocol CloseMessagePopupDelegate {
    func CloseMessagePopup()
}

class PopupMessageViewController: UIViewController {
    var Message : String = ""
    var delegate : CloseMessagePopupDelegate!
    @IBOutlet weak var lblMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.text = Message
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BAck(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate.CloseMessagePopup()
        }
    }
    @IBAction func OK(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate.CloseMessagePopup()
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
