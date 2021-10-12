//
//  EmailPopupViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 08/09/21.
//

import UIKit

class EmailPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        Dismiss(false)
    }
    @IBAction func Email(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ForwordEmailViewController") as! ForwordEmailViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Sync(_ sender: Any) {
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
