//
//  CommentViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 28/08/21.
//

import UIKit
import IQKeyboardManagerSwift

class CommentViewController: UIViewController {
    @IBOutlet weak var lblNoOfComments: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var c_table_h: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var c_Bottom_h: NSLayoutConstraint!
    var FeedData : M_Feed_Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("CommentTableViewCell")
        SetFeedData()
        GetFeed()
        // Do any additional setup after loading the view.
    }
    func SetFeedData()  {
        lblName.text = FeedData.user_name
        imgUser.getImage(url: FeedData.user_image)
        lblLocation.text = FeedData.address
        lblNoOfComments.text = "\(FeedData.total_comments) Comments"
        lblDetail.text = FeedData.detail
        if FeedData.like_status == 1{
            lblLike.text = "Unlike"
            imgLike.image = #imageLiteral(resourceName: "ic_like_selected")

        }
        else{
            lblLike.text = "Like"
            imgLike.image = #imageLiteral(resourceName: "ic_like_normal")


        }
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        c_table_h.constant = tableView.contentSize.height
        tableView.updateFocusIfNeeded()
        view.updateFocusIfNeeded()

    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func SendComment(_ sender: Any) {
        if txtComment.CheckText(){
            ApiComments(status: 0, feed_id: FeedData.id)
        }
    }
    
    @IBAction func like(_ sender: Any) {
        if FeedData.like_status == 1{
            ApiLike(status: 0, feed_id: FeedData.id)
        }
        else{
            ApiLike(status: 1, feed_id: FeedData.id)
        }
    }
    @IBAction func Comments(_ sender: Any) {
       
    }
    @IBAction func Share(_ sender: Any) {
        buildFDLLink(RequestID: "\(FeedData.id)", text: "Check Feed", type: 1)

    }
    func GetFeed()  {
        let dict = [
            "feed_id" : FeedData.id,
                    ] as [String : Any]
        

        APIClients.POST_user_feedDetail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.FeedData = response.data
                self.SetFeedData()
                self.txtComment.text = ""
//                Constants.Toast.MyToast(message: response.message   )


             


                
               
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }
    }
    func ApiLike(status : Int , feed_id : Int)  {
        let dict = ["status" : status,
                    "feed_id" : feed_id,
                    ] as [String : Any]
        

        APIClients.POST_user_addLike(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )


                let when = DispatchTime.now() + 0
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.GetFeed()

                }

//                if status == 1{
//                    self.FeedData.total_likes += 1
//                }
//                else{
//                    self.FeedData.total_likes -= 1
//
//                }
                
               
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }
    }
    func ApiComments(status : Int , feed_id : Int)  {
        let dict = ["comment" : txtComment.text!,
                    "feed_id" : feed_id,
                    ] as [String : Any]
        

        APIClients.POST_user_addComment(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                Constants.Toast.MyToast(message: response.message   )


                let when = DispatchTime.now() + 0
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.GetFeed()

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
extension CommentViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedData.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.selectionStyle = .none
        cell.lblName.text = FeedData.comments[indexPath.row].user_name
        cell.lblDetail.text = FeedData.comments[indexPath.row].comment
        cell.imgUser.getImage(url: FeedData.comments[indexPath.row].user_image)
        c_table_h.constant = tableView.contentSize.height
        tableView.updateFocusIfNeeded()
        view.updateFocusIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        c_table_h.constant = tableView.contentSize.height
        tableView.updateFocusIfNeeded()
        view.updateFocusIfNeeded()

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CommentViewController : UITextViewDelegate{
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
//        IQKeyboardManager.shared.enableAutoToolbar = false
           registerKeyboardNotifications()
//        SetUserOnlineOrOffline(status: true)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 0
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        deRegisterKeyboardNotifications()
        txtComment.resignFirstResponder()
//        SetUserOnlineOrOffline(status: false)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10

    }

    //MARK: - Keyboard notification observer Methods
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc  fileprivate func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        
        // this method will get called even if a system generated alert with keyboard appears over the current VC.
        //            let info: NSDictionary = notification.userInfo! as NSDictionary
        //            let value: NSValue = info.value(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as! NSValue
        //            let keyboardSize: CGSize = value.cgRectValue.size
        //
        //            c_text_h.constant = keyboardSize.height + 20
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            c_Bottom_h.constant = keyboardSize.height
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
       
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        let contentInsets: UIEdgeInsets = .zero
        c_Bottom_h.constant = 8
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
}
