//
//  ForwordEmailViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 08/09/21.
//

import UIKit

class ForwordEmailViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func Copy(_ sender: Any) {
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
