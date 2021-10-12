//
//  MoreViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 02/09/21.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AccountDetail(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AccountDetailViewController") as! AccountDetailViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func ContactUS(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ContactUSViewController") as! ContactUSViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Share(_ sender: Any) {
        buildFDLLink(RequestID: "\(Constants.CurrentUserData.id)", text: "", type: 2)

    }
    @IBAction func Terms(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TermsViewController") as! TermsViewController
        vc.SelectedType = 3
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func AboutUS(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedType = 1

        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Privacy(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedType = 2

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
