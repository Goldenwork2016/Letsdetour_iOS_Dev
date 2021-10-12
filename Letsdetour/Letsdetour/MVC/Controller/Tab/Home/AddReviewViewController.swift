//
//  AddReviewViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import IQKeyboardManagerSwift
import Cosmos

class AddReviewViewController: UIViewController {
    @IBOutlet weak var txtReview: IQTextView!
    @IBOutlet weak var viewRate: CosmosView!
    var Place_id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Done(_ sender: Any) {
        if CheckTextField().CheckText(text: txtReview.text, String_type: "review")  {
            ApiReview()
        }
    }
    
    func ApiReview()  {
        let dict = ["rating" : viewRate.rating,
                    "place_id" : Place_id,
                    "comment" : txtReview.text!] as [String : Any]
       
        APIClients.POST_GiveRating(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )


                let when = DispatchTime.now() + 0
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
