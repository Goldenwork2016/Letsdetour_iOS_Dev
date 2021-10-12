//
//  WelcomeViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 24/08/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 1.7
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            print( DataManager.CurrentUserData)
            if DataManager.CurrentUserData != nil{
                Constants.CurrentUserData = DataManager.CurrentUserData
                self.PresentViewController(identifier: "TabViewController")
            }
            else{
                self.PushToWelcome()
            }
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

