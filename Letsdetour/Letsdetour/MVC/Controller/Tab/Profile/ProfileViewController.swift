//
//  ProfileViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCountFollower: UILabel!
    @IBOutlet weak var lblCountFollowing: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblUnderCheckIn: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblNoCheckIn: UILabel!
    
    @IBOutlet weak var lblUnderPosts: UILabel!
    @IBOutlet weak var lblPosts: UILabel!
    @IBOutlet weak var lblNoPosts: UILabel!
    var DataUser : M_User_Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("FeedTableViewCell")
        SeletedTab(tab : 1)
        NotificationCenter.default.addObserver(self, selector: #selector(SetProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        GetUSerData()

    }
    @objc func SetProfile()  {
        imgCover.getImage(url: DataUser.cover_image ?? "")
        imgUser.getImage(url: DataUser.image ?? "", isUser: true)
        lblName.text = DataUser.user_name
        lblBio.text = DataUser.bio
        lblNoPosts.text = "\(DataUser.feeds.count) Posts"
        lblCountFollower.text = "\(DataUser.followers.count)"
        lblCountFollowing.text = "\(DataUser.followings.count)"

        tableView.reloadData()
        

    }
    func GetUSerData()  {
        let dict = ["user_id" : Constants.CurrentUserData.id,
                    
                    ] as [String : Any]
        

        APIClients.POST_user_otheruserDetail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.DataUser = response.user
                self.SetProfile()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                }
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }

    }
    @IBAction func Setting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func More(_ sender: UIButton) {
            
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        vc.view.backgroundColor = UIColor.clear
        vc.modalPresentationStyle = .popover
      
        vc.preferredContentSize = CGSize(width: 200, height: 400)
         
          let ppc = vc.popoverPresentationController
          ppc?.permittedArrowDirections = .any
          ppc?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
          ppc?.delegate = self
          ppc?.sourceView = sender
          present(vc, animated: true, completion: nil)
    }
    
    @IBAction func TabPosts(_ sender: Any) {
        SeletedTab(tab : 1)
    }
    @IBAction func Followings(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "FollowersViewController") as! FollowersViewController
        vc.modalPresentationStyle = .fullScreen
        vc.selectedTag = 1
        vc.FollowerList = DataUser.followers
        vc.FollowingList = DataUser.followings
        vc.DataUser = DataUser
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Followers(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "FollowersViewController") as! FollowersViewController
        vc.modalPresentationStyle = .fullScreen
        vc.selectedTag = 0
        vc.FollowerList = DataUser.followers
        vc.FollowingList = DataUser.followings
        vc.DataUser = DataUser

        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func TabCheckins(_ sender: Any) {
        SeletedTab(tab : 2)
    }
    
    func SeletedTab(tab : Int)  {
        switch tab {
        case 1:
            tableView.isHidden = false
            mapView.isHidden = true
            
            lblPosts.textColor = .Secondary
            lblNoPosts.textColor = .Secondary
            lblUnderPosts.backgroundColor = .Secondary
            
            lblCheckIn.textColor = .Primary
            lblNoCheckIn.textColor = .Primary
            lblUnderCheckIn.backgroundColor = .Primary
            
        case 2:
            tableView.isHidden = true
            mapView.isHidden = false
            
            lblPosts.textColor = .Primary
            lblNoPosts.textColor = .Primary
            lblUnderPosts.backgroundColor = .Primary
            
            lblCheckIn.textColor = .Secondary
            lblNoCheckIn.textColor = .Secondary
            lblUnderCheckIn.backgroundColor = .Secondary
        default:
            break
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
extension ProfileViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (DataUser == nil){
            return 0
        }
        return DataUser.feeds.count
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
            cell.selectionStyle = .none
            cell.lblName.text = DataUser.feeds[indexPath.row].user_name
            cell.imgUser.getImage(url: DataUser.feeds[indexPath.row].user_image)
            cell.lblDetail.text = DataUser.feeds[indexPath.row].detail
            cell.imgFeed.getImage(url: DataUser.feeds[indexPath.row].image)
            cell.lblDate.text = DataUser.feeds[indexPath.row].created_at.getTimeAgo()
            tableView.updateFocusIfNeeded()
            view.updateFocusIfNeeded()

            cell.lblNumberOfLikes.text = "\(DataUser.feeds[indexPath.row].total_likes) Likes"
            cell.lblNumberOfComments.text = "\(DataUser.feeds[indexPath.row].total_comments) Comments"
            cell.btnLike.addTarget(self, action: #selector(self.LikeUnlike(_:)), for: .touchDown)
            cell.btnLike.tag = indexPath.row
            cell.btnLike.accessibilityLabel = "\(DataUser.feeds[indexPath.row].like_status)"
            
            cell.btnFollow.addTarget(self, action: #selector(self.FollowUnFollow(_:)), for: .touchDown)
            cell.btnFollow.tag = indexPath.row
            cell.btnFollow.accessibilityLabel = "\(DataUser.feeds[indexPath.row].follow_status)"
            cell.btnShare.addTarget(self, action: #selector(self.Share(_:)), for: .touchDown)
            cell.btnShare.tag = indexPath.row
            cell.btnComment.addTarget(self, action: #selector(self.Comment(_:)), for: .touchDown)
            cell.btnComment.tag = indexPath.row
            
            if DataUser.feeds[indexPath.row].follow_status == "1"{
                cell.btnFollow.setTitle("Unfollow", for: .normal)
            }
            else if DataUser.feeds[indexPath.row].follow_status == "2"{
                cell.btnFollow.setTitle("Requested", for: .normal)
            }
            else{
                cell.btnFollow.setTitle("Follow", for: .normal)

            }
            cell.btnFollow.isHidden = true
            if DataUser.feeds[indexPath.row].like_status == 1{
                cell.lblLike.text = "Unlike"
                cell.imgLike.image = #imageLiteral(resourceName: "ic_like_selected")
              
            }
            else{
                cell.imgLike.image = #imageLiteral(resourceName: "ic_like_normal")

                cell.lblLike.text = "Like"

            }
            if DataUser.feeds[indexPath.row].user_id == Constants.CurrentUserData.id{
                cell.btnFollow.isHidden = true
            }
            else{
                cell.btnFollow.isHidden = false

            }
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = storyboard?.instantiateViewController(identifier: "CommentViewController") as! CommentViewController
            vc.modalPresentationStyle = .fullScreen
            vc.FeedData = DataUser.feeds[indexPath.row]
            present(vc, animated: true, completion: nil)
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            tableView.updateFocusIfNeeded()
            view.updateFocusIfNeeded()
        }
        func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            tableView.updateFocusIfNeeded()
            view.updateFocusIfNeeded()

        }
     
        @IBAction func LikeUnlike(_ sender: UIButton) {
            if DataUser.feeds[sender.tag].like_status == 1{
                ApiLike(status: 0, feed_id: DataUser.feeds[sender.tag].id)
            }
            else{
                ApiLike(status: 1, feed_id: DataUser.feeds[sender.tag].id)
            }
            
        }
        @IBAction func FollowUnFollow(_ sender: UIButton) {
            if DataUser.feeds[sender.tag].follow_status == "1" || DataUser.feeds[sender.tag].follow_status == "2"{
                ApiFollow(status: 0, follower_id: DataUser.feeds[sender.tag].user_id)
            }
            else{
                ApiFollow(status: 1, follower_id: DataUser.feeds[sender.tag].user_id)
            }
        }
        @IBAction func Share(_ sender: UIButton) {
            buildFDLLink(RequestID: "\(DataUser.feeds[sender.tag].id)", text: "Check Feed", type: 1)

        }
        @IBAction func Comment(_ sender: UIButton) {
            let vc = storyboard?.instantiateViewController(identifier: "CommentViewController") as! CommentViewController
            vc.modalPresentationStyle = .fullScreen
            vc.FeedData = DataUser.feeds[sender.tag]
            present(vc, animated: true, completion: nil)
            
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
                        self.GetUSerData()

                    }
                    
                    
                    
                   
                case .failure(let error):
                    print(error)
                }
                
            } failure: { (error) in
                
            }
        }
        func ApiFollow(status : Int , follower_id : Int)  {
            let dict = ["status" : status,
                        "follower_id" : follower_id,
                        ] as [String : Any]
            

            APIClients.POST_user_addFollow(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    Constants.Toast.MyToast(message: response.message   )

                    let when = DispatchTime.now() + 0
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        self.GetUSerData()

                    }

                   
                case .failure(let error):
                    print(error)
                }
                
            } failure: { (error) in
                
            }
        }
        
    }
extension ProfileViewController :  UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func setAlphaOfBackgroundViews(alpha: CGFloat) {
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        UIView.animate(withDuration: 0.2) {
            statusBarWindow?.alpha = alpha;
            self.view.alpha = alpha;
            self.navigationController?.navigationBar.alpha = alpha;
        }
    }
}
