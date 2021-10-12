//
//  ChatMoreViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 09/09/21.
//

import UIKit

class ChatMoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Deletechat(_ sender: Any) {
    }
    
    @IBAction func Archivechat(_ sender: Any) {
        
    }
    
    @IBAction func MemberList(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MemberListViewController") as! MemberListViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Mute(_ sender: Any) {
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
