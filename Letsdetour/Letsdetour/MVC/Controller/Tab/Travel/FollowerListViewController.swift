//
//  FollowerListViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 06/09/21.
//

import UIKit
import ContactsUI

protocol ContactViewDelegate {
    func GetNumbers(numbers : [String])
}
struct C_Contact {
    var Name : String = ""
    var Phone : String = ""
    var Image : String = ""

}

class FollowerListViewController: UIViewController, UISearchBarDelegate {
    
    var contacts = [CNContact]()
    var contactsTemp = [CNContact]()
    var Collection = [C_Contact]()
    var CollectionTemp = [C_Contact]()
    var SeletedPhone = [String]()

    
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblAllFollow: UILabel!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var ViewFrom : String = ""
    var PlanData : M_Plan_Detail_data!
    var Follower_List = [M_Follower_Data]()
    var tempFollower_List = [M_Follower_Data]()

    var CheckedIDs : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("UserTableViewCell")
        lblAllFollow.text = ""
        txtSearch.delegate = self
        if ViewFrom == "Follow"{
            lblTitle.text = "Follower List"
            lblAllFollow.text = "All Followers"
            ApiFollowerList()
        }
        else if ViewFrom == "Followed"{
            lblTitle.text = "User List"
            lblAllFollow.text = "User Follow Plan"

            Follower_List = PlanData.followers
            tempFollower_List = PlanData.followers
            viewShare.isHidden = true
        }
        else{
            lblTitle.text = "User List"
            lblAllFollow.text = "Contact List"
            Contacts()

        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Share(_ sender: Any) {
        if CheckedIDs.count != 0 && ViewFrom == "Follow"{
            ApiAddFollower()
        }
        if SeletedPhone.count != 0 && ViewFrom == "Contact"{
            ApiAddFollower()
        }

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if ViewFrom == "Follow"{
            if searchText.count == 0{
                Follower_List = tempFollower_List
            }
            else{
                Follower_List = tempFollower_List.filter({ ($0.user_name.uppercased().contains(searchText.uppercased())  )})
                
            }
            self.Follower_List.sort {
                $0.user_name < $1.user_name
            }

        }
        else if ViewFrom == "Followed"{
            if searchText.count == 0{
                Follower_List = tempFollower_List
            }
            else{
                Follower_List = tempFollower_List.filter({ ($0.user_name.uppercased().contains(searchText.uppercased())  )})
                
            }
            self.Follower_List.sort {
                $0.user_name < $1.user_name
            }


        }
        else{
            if searchText.count == 0{
                Collection = CollectionTemp
            }
            else{
                Collection = CollectionTemp.filter({ ($0.Name.contains(searchText) || $0.Phone.contains(searchText) )})
                
            }
            self.Collection.sort {
                $0.Name < $1.Name
            }
        }
        tableView.reloadData()
    }
    
    func Contacts()  {
        let contactStore = CNContactStore()
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey,
                    CNContactThumbnailImageDataKey] as [Any]

                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch {
                    print("Error fetching containers")
                }

                var results: [CNContact] = []

                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        results.append(contentsOf: containerResults)
                    } catch {
                        print("Error fetching containers")
                    }
                }
        self.contacts = results
        self.contactsTemp = results
        self.Collection.removeAll()
        self.CollectionTemp.removeAll()

        for i in results{
            if i.phoneNumbers.count != 0{
                for j in  i.phoneNumbers{
                    self.Collection.append(C_Contact.init(Name: i.givenName + " " + i.familyName, Phone:  j.value.stringValue))
                    self.CollectionTemp.append(C_Contact.init(Name: i.givenName + " " + i.familyName, Phone:  j.value.stringValue))
                }
            }
        }
//        self.Collection.sort(by: { ($0.Phone)})
        self.Collection.sort {
            $0.Name < $1.Name
        }
        

    }
    func ApiFollowerList()  {
        
        
        let dict = [
            "type" : 1,
        ] as [String : Any]
        view.isUserInteractionEnabled = false
        APIClients.POST_user_follower_list(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
                self.Follower_List = response.data
                self.tempFollower_List = response.data

                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                self.view.isUserInteractionEnabled = true
            }
            
        } failure: { (error) in
            self.view.isUserInteractionEnabled = true

        }
    }
    func ApiAddFollower()  {
        
        
        let dict = [
            "plan_id" : PlanData.id,
            "follower_id" : CheckedIDs.componentsJoined(by: ","),
            "status" : 1
        ] as [String : Any] as [String : Any]
        view.isUserInteractionEnabled = false
        APIClients.POST_user_addPlanFollower(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
//                Constants.Toast.MyToast(message: response.message   )

                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.Dismiss()
                }

            case .failure(let error):
                print(error)
                self.view.isUserInteractionEnabled = true
            }
            
        } failure: { (error) in
            self.view.isUserInteractionEnabled = true

        }
    }
    
    func ApiRemoveFollower(id : Int)  {
        
        
        let dict = [
            "plan_id" : PlanData.id,
            "follower_id" : id,
            "status" : 0
        ] as [String : Any] as [String : Any]
        view.isUserInteractionEnabled = false
        APIClients.POST_user_addPlanFollower(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
                Constants.Toast.MyToast(message: response.message   )

                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    if id == Constants.CurrentUserData.id{
                        self.PresentViewController(identifier: "TabViewController")
                    }
                    else{
                        self.Dismiss()
                    }
                }

            case .failure(let error):
                print(error)
                self.view.isUserInteractionEnabled = true
            }
            
        } failure: { (error) in
            self.view.isUserInteractionEnabled = true

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
extension FollowerListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if ViewFrom == "Follow"{
            return Follower_List.count

         }
        else if ViewFrom == "Followed"{
            return PlanData.followers.count

        }
        return Collection.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.selectionStyle = .none

        cell.btnCheck.addTarget(self, action: #selector(self.Check(_:)), for: .touchDown)
        cell.btnCheck.tag = indexPath.row
      
        if ViewFrom == "Follow"{
            cell.imgUser.getImage(url: Follower_List[indexPath.row].user_image)
            cell.lblName.text = Follower_List[indexPath.row].user_name
            if CheckedIDs.contains(Follower_List[indexPath.row].user_id){
                cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .normal)
            }
            else{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_round_checkbox_normal"), for: .normal)
            }
        }
       else if ViewFrom == "Followed"{
        cell.imgUser.getImage(url: PlanData.followers[indexPath.row].user_image)
        cell.lblName.text = PlanData.followers[indexPath.row].user_name
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_delete_red"), for: .normal)
        cell.btnCheck.isHidden = true

        if PlanData.permission == 2 || PlanData.followers[indexPath.row].user_id == Constants.CurrentUserData.id{
            cell.btnCheck.isHidden = false
        }
       }
       else{
            cell.lblName.text = Collection[indexPath.row].Name + "\n\(Collection[indexPath.row].Phone)"
            if SeletedPhone.contains(Collection[indexPath.row].Phone){
                cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .normal)
            }
            else{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_round_checkbox_normal"), for: .normal)
            }
       }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ViewFrom == "Follow"{

            let vc = storyboard?.instantiateViewController(identifier: "OtherUserViewController") as! OtherUserViewController
            vc.modalPresentationStyle = .fullScreen
            vc.user_id = Follower_List[indexPath.row].user_id
            present(vc, animated: true, completion: nil)
        }
        else if ViewFrom == "Followed"{
            let vc = storyboard?.instantiateViewController(identifier: "OtherUserViewController") as! OtherUserViewController
            vc.modalPresentationStyle = .fullScreen
            vc.user_id = PlanData.followers[indexPath.row].user_id
            present(vc, animated: true, completion: nil)
        }
        else{
            
        }
    }
    @IBAction func Check(_ sender: UIButton) {
        if ViewFrom == "Follow"{
            if CheckedIDs.contains(Follower_List[sender.tag].user_id){
                CheckedIDs.remove(Follower_List[sender.tag].user_id)
            }
            else{
                CheckedIDs.add(Follower_List[sender.tag].user_id)

            }
        }
       else if ViewFrom == "Followed"{
            ApiRemoveFollower(id: Follower_List[sender.tag].user_id)
            
       }
       else{
            
            if SeletedPhone.contains(Collection[sender.tag].Phone){
                SeletedPhone.remove(at: SeletedPhone.firstIndex(of: Collection[sender.tag].Phone)!)
            }
            else{
                if SeletedPhone.count <= 10{
                    SeletedPhone.append(Collection[sender.tag].Phone)
                }
            }
       }
        
        tableView.reloadData()


    }
    func Get_PlanDetail()  {
        let dict = ["plan_id" : PlanData.id,
                    ] as [String : Any]
        
        APIClients.GET_planDetail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.PlanData = response.data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        } failure: { (error) in
            
        }

    }
}
