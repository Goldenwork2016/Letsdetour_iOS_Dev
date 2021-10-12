//
//  FollowersViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit

class FollowersViewController: UIViewController {
    @IBOutlet weak var lblUnderFollower: UILabel!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var lblNoFollower: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var lblUnderFollowings: UILabel!
    @IBOutlet weak var lblFollowings: UILabel!
    @IBOutlet weak var lblNoFollowings: UILabel!

    @IBOutlet weak var tableView: UITableView!
    var FollowerList = [M_Follower_Data]()
    var tempFollowerList = [M_Follower_Data]()
    var FollowingList = [M_Follower_Data]()
    var tempFollowingList = [M_Follower_Data]()
    var selectedTag : Int = 0
    var DataUser : M_User_Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        tempFollowingList = FollowingList
        tempFollowerList = FollowerList
        SetProfile()
        tableView.RegisterTableCell("FollowTableViewCell")
        SeletedTab(tab: selectedTag)
        // Do any additional setup after loading the view.
    }
    func SetProfile()  {
        lblNoFollowings.text = "\(DataUser.followings.count) Followerings"
        lblNoFollower.text = "\(DataUser.followers.count) Followers"

    }
    
    func GetUSerData()  {
        let dict = ["user_id" : DataUser.id,
                    
                    ] as [String : Any]
        

        APIClients.POST_user_otheruserDetail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.DataUser = response.user
                self.FollowingList = response.user.followings
                self.FollowerList = response.user.followers
                self.tempFollowingList = self.FollowingList
                self.tempFollowerList = self.FollowerList
                self.SetProfile()
                self.tableView.reloadData()
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
    @IBAction func Follower(_ sender: Any) {
        selectedTag = 0
        SeletedTab(tab: selectedTag)

    }
    
    @IBAction func Followers(_ sender: Any) {
        selectedTag = 1
        SeletedTab(tab: selectedTag)

    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func Search(_ sender: UITextField) {
        if selectedTag == 0{
            if sender.text == ""{
                FollowerList = tempFollowerList
            }
            else{
                FollowerList = tempFollowerList.filter({ ($0.user_name.uppercased().contains(sender.text!.uppercased()))})
            }
        }
        else{
            if sender.text == ""{
                FollowingList = tempFollowingList
            }
            else{
                FollowingList = tempFollowingList.filter({ ($0.user_name.uppercased().contains(sender.text!.uppercased()))})
            }
        }
        tableView.reloadData()
        
    }
    func SeletedTab(tab : Int)  {
        switch tab {
        case 0:
            
            lblFollower.textColor = .Secondary
            lblNoFollower.textColor = .Secondary
            lblUnderFollower.backgroundColor = .Secondary
            
            lblFollowings.textColor = .Primary
            lblNoFollowings.textColor = .Primary
            lblUnderFollowings.backgroundColor = .Primary
            
        case 1:
            
            lblFollower.textColor = .Primary
            lblNoFollower.textColor = .Primary
            lblUnderFollower.backgroundColor = .Primary
            
            lblFollowings.textColor = .Secondary
            lblNoFollowings.textColor = .Secondary
            lblUnderFollowings.backgroundColor = .Secondary
        default:
            break
        }
        tableView.reloadData()
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
extension FollowersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTag == 0{
            return FollowerList.count

        }
        return FollowingList.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        cell.selectionStyle = .none
        if selectedTag == 0{
            cell.btnFollow.setTitle("Remove", for: .normal)
            cell.btnFollow.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
            cell.imgUser.getImage(url: FollowerList[indexPath.row].user_image)
            cell.lblName.text = FollowerList[indexPath.row].user_name
        }
        else{
            cell.btnFollow.setTitle("Unfollow", for: .normal)
            cell.btnFollow.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)

            cell.imgUser.getImage(url: FollowingList[indexPath.row].user_image)
            cell.lblName.text = FollowingList[indexPath.row].user_name
        }
        if DataUser.id == Constants.CurrentUserData.id{
            cell.btnFollow.isHidden = false
        }
        else{
            cell.btnFollow.isHidden = true

        }
        cell.btnFollow.addTarget(self, action: #selector(UnFollow(_:)), for: .touchDown)
        cell.btnFollow.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "OtherUserViewController") as! OtherUserViewController
        vc.modalPresentationStyle = .fullScreen
        vc.user_id = FollowingList[indexPath.row].user_id
        present(vc, animated: true, completion: nil)
    }
    @IBAction func UnFollow(_ sender: UIButton) {
        if selectedTag == 0{

            ApiFollow(status: 0, follower_id: FollowerList[sender.tag].user_id)
        }
        else{
            ApiFollow(status: 0, follower_id: FollowingList[sender.tag].user_id)

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

                }

               
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }
    }

}
