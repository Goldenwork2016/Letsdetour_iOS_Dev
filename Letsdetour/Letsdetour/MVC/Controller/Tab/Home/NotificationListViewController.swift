//
//  NotificationListViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 27/09/21.
//

import UIKit

class NotificationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var NotificationList = [M_Notofiaction_Data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("NotificationTableViewCell")
        ApiNotificationList()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    func ApiNotificationList() {
        let dict = ["" : "",
                    ] as [String : Any]
        

        APIClients.POST_user_notification_list(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.NotificationList = response.data
                self.tableView.reloadData()
//                Constants.Toast.MyToast(message: response.message   )


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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NotificationListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.selectionStyle = .none
        cell.viewCheck.isHidden = true
        cell.viewAccept.isHidden = true
        cell.viewCancel.isHidden = true

        switch NotificationList[indexPath.row].type {
        case 1:
            cell.img.image = #imageLiteral(resourceName: "icon-76")
            cell.lblNotification.text = "Admin " + NotificationList[indexPath.row].description
        case 4:
            cell.img.getImage(url: NotificationList[indexPath.row].user_image ?? "")
            cell.lblNotification.text = NotificationList[indexPath.row].user_name ?? "" + " " + NotificationList[indexPath.row].description
            if NotificationList[indexPath.row].status != 0{
                cell.viewAccept.isHidden = false
                cell.viewCancel.isHidden = false
            }
        case 5,6:
            cell.img.getImage(url: NotificationList[indexPath.row].user_image ?? "")
            cell.lblNotification.text = NotificationList[indexPath.row].user_name ?? "" + " " + NotificationList[indexPath.row].description
        case 7:
            cell.img.getImage(url: NotificationList[indexPath.row].user_image ?? "")
            cell.lblNotification.text = NotificationList[indexPath.row].user_name ?? "" + " " + NotificationList[indexPath.row].description
            cell.viewCheck.isHidden = false
     
        default:
            break
        }
        
        cell.btnAccept.addTarget(self, action: #selector(self.Accept(_:)), for: .touchDown)
        cell.btnAccept.tag = indexPath.row
        
        cell.btnCancel.addTarget(self, action: #selector(self.Reject(_:)), for: .touchDown)
        cell.btnCancel.tag = indexPath.row
        
        cell.btnCheck.addTarget(self, action: #selector(self.Check(_:)), for: .touchDown)
        cell.btnCheck.tag = indexPath.row
     
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @IBAction func Accept(_ sender: UIButton) {
        ApiFollowRequest(status: 1, request_id: NotificationList[sender.tag].status_id ?? 0)
        
    }
    @IBAction func Reject(_ sender: UIButton) {
        ApiFollowRequest(status: 0, request_id: NotificationList[sender.tag].status_id ?? 0)

    }
    @IBAction func Check(_ sender: UIButton) {
    }
    func ApiFollowRequest(status : Int , request_id : Int)  {
        let dict = ["status" : status,
                    "request_id" : request_id,
                    ] as [String : Any]
        

        APIClients.POST_user_receiveFollowRequest(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message   )

                let when = DispatchTime.now() + 0
                DispatchQueue.main.asyncAfter(deadline: when)
                {
//                    self.GetPlaceDetail()

                }

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }
    }
    
}
