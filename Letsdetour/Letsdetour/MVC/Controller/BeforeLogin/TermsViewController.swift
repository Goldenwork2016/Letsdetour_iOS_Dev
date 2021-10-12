//
//  TermsViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    var SelectedType : Int = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        GetPlaceList()
        self.lblTitle.text = ""
        self.txtDetail.text = ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    func GetPlaceList()  {
        let dict = ["type" : SelectedType,
                    ] as [String : Any]
        

        APIClients.POST_pages(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.lblTitle.text = response.data.title
                self.txtDetail.attributedText = response.data.content.HTMLtextToString()
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
