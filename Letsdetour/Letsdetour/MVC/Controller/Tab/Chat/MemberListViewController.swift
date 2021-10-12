//
//  MemberListViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 09/09/21.
//

import UIKit

class MemberListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("FollowTableViewCell")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        Dismiss()
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
extension MemberListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        cell.selectionStyle = .none
        cell.btnFollow.setTitle("Remove", for: .normal)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
