//
//  TabViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for item in self.tabBar.items!{
            if item.tag == 2 {
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
                item.image = item.image?.withRenderingMode(.alwaysOriginal)
            }
        }
        // Do any additional setup after loading the view.
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
