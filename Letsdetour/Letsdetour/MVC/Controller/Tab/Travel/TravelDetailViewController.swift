//
//  TravelDetailViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 02/09/21.
//

import UIKit
import IQKeyboardManagerSwift
class planImageCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btnDelete: UIButton!
}

class TravelDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnImportDetail: UIButton!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var lblPageController: UIPageControl!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var txtCheckConfromation: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var viewOverView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblUnderOverview: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    @IBOutlet weak var lblUnderItinerary: UILabel!
    @IBOutlet weak var lblItinerary: UILabel!
    var imagePricker : ImageController!
    var ImageCollection : NSMutableArray = []
    var PlanData : M_Plan_data!
    var PlanDetail : M_Plan_Detail_data!
    override func viewDidLoad() {
        super.viewDidLoad()
        SeletedTab(tab : 0)
        
        tableView.RegisterTableCell("PlaceHeaderTableViewCell")
        tableView.RegisterTableCell("PlaceTableViewCell")
        tableView.RegisterTableCell("PlaceFooterTableViewCell")
        collectionView.collectionViewLayout = CollectionViewOverlappingLayout()
//        imgCollectionView.collectionViewLayout = CollectionViewOverlappingLayout()

        lblPageController.hidesForSinglePage = true
        lblPageController.numberOfPages = ImageCollection.count
        imgCollectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(Get_PlanDetail), name: Notification.Name.NotificationUpdatePlan, object: [:])

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Get_PlanDetail()

    }
    @objc func Get_PlanDetail()  {
        let dict = ["plan_id" : PlanData.id,
                    ] as [String : Any]
        
        APIClients.GET_planDetail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.PlanDetail = response.data
                self.SetDetail()
            case .failure(let error):
                print(error)
            }
        } failure: { (error) in
            
        }

    }
    func SetDetail() {
        lblName.text = "\(PlanDetail.start_date.getTimeFromTime(currentFormat: DateFormat.yyyy_MM_dd.get(), requiredFormat: DateFormat.MMM_dd.get())) to \(PlanDetail.end_date.getTimeFromTime(currentFormat: DateFormat.yyyy_MM_dd.get(), requiredFormat: DateFormat.MMM_dd.get()))"
        lblDate.text = "In " + PlanDetail.start_date.getAge() + " days"
        lblTitle.text = PlanDetail.address
        tableView.reloadData()
        imgCollectionView.reloadData()
        lblPageController.numberOfPages = PlanDetail.images.count
        if PlanData.permission == 2 || PlanData.user_id == Constants.CurrentUserData.id{
            self.btnAddImage.isHidden = false
        }
        else{
            self.btnAddImage.isHidden = true
        }
        txtCheckConfromation.isHidden = true
        collectionView.reloadData()
        
        
    }
    @IBAction func Confromation(_ sender: Any) {
 
    }
    @IBAction func By(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func ImportDetail(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailPopupViewController") as! EmailPopupViewController
        vc.view.backgroundColor = UIColor.clear
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    @IBAction func Share(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareTravelViewController") as! ShareTravelViewController
        vc.view.backgroundColor = UIColor.clear
        vc.modalPresentationStyle = .popover
        vc.PlanData = PlanDetail

        vc.preferredContentSize = CGSize(width: 200, height: 170)
         
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ppc?.delegate = self
        ppc?.sourceView = sender
        
        present(vc, animated: true, completion: nil)
//        buildFDLLink(RequestID: "\(PlanDetail.id)", text: "Check Travel Plan", type: 3)
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func AddPlace(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self, sender: sender, configureCellBlock: { (img, url) in
            self.ApiUpdatePlan(img: img)
        })
    }
    
    @IBAction func More(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "moreTravelViewController") as! moreTravelViewController
        vc.PlanDetail = PlanData
        vc.delegate = self
        if PlanData.permission == 2 || PlanData.id == Constants.CurrentUserData.id {
            vc.preferredContentSize = CGSize(width: 200, height: 210)
        }
        else{
            vc.preferredContentSize = CGSize(width: 200, height: 140)
        }
        vc.view.backgroundColor = UIColor.clear
        vc.modalPresentationStyle = .popover
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ppc?.delegate = self
        ppc?.sourceView = sender
        present(vc, animated: true, completion: nil)
    }
    @IBAction func UpDate(_ sender: Any) {
    }
    @IBAction func OverView(_ sender: Any) {
        SeletedTab(tab : 0)

    }
    
    @IBAction func Itinerary(_ sender: Any) {
        SeletedTab(tab : 1)

    }
    func SeletedTab(tab : Int)  {
        switch tab {
        case 0:
            lblOverview.textColor = .Secondary
            lblUnderOverview.backgroundColor = .Secondary
            lblItinerary.textColor = .Primary
            lblUnderItinerary.backgroundColor = .Primary
            viewOverView.isHidden = false
            tableView.isHidden = true
        case 1:
            lblOverview.textColor = .Primary
            lblUnderOverview.backgroundColor = .Primary
            lblItinerary.textColor = .Secondary
            lblUnderItinerary.backgroundColor = .Secondary
            viewOverView.isHidden = true
            tableView.isHidden = false
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

    func ApiUpdatePlan(img : UIImage)  {
       
        let dict = [
           
            "plan_id" : PlanData.id
            
        ] as [String : Any]
        view.isUserInteractionEnabled = false
        APIClients.POST_user_updatePlan(parems: dict as [String : Any], imageKey: ["images[]"], image: [img], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
                Constants.Toast.MyToast(message: response.message   )
                self.Get_PlanDetail()

            case .failure(let error):
                print(error)
                self.view.isUserInteractionEnabled = true
            }
        } failure: { (error) in
            self.view.isUserInteractionEnabled = true
        } progressUpload: { (pre) in
        }


    }

}
extension TravelDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if (PlanDetail != nil){
            return PlanDetail.dates.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceHeaderTableViewCell") as! PlaceHeaderTableViewCell
        cell.lblDate.text = PlanDetail.dates[section].plan_date
        if PlanDetail.dates[section].routes.count == 0{
            cell.btnRoute.isHidden = true
        }
        else{
            cell.btnRoute.isHidden = false
        }
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.btnRoute.addTarget(self, action: #selector(self.Route(_:)), for: .touchDown)
        cell.btnRoute.tag = section
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlanDetail.dates[section].routes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        cell.selectionStyle = .none
        let dict = PlanDetail.dates[indexPath.section].routes[indexPath.row]
        cell.lblTime.text = dict.route_time
        cell.lblDetail.text = dict.name
        cell.img.getImage(url: dict.image)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ImagesViewController") as! ImagesViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isURL = true
        let dict = PlanDetail.dates[indexPath.section].routes[indexPath.row]

        vc.ImagesURL = [dict.image]
        vc.SelectedIndex = indexPath.row
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if PlanData.permission == 2 || PlanData.user_id == Constants.CurrentUserData.id{

            let filterAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
                print("Swiped to filter")
                self.ApiDeleteRoute(id: self.PlanDetail.dates[indexPath.section].routes[indexPath.row].id)
            }
            filterAction.backgroundColor = UIColor.red

            return UISwipeActionsConfiguration(actions: [filterAction])
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceFooterTableViewCell") as! PlaceFooterTableViewCell
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.Add.addTarget(self, action: #selector(self.AddTime(_:)), for: .touchDown)
        cell.Add.tag = section
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if PlanData.permission == 2 || PlanData.user_id == Constants.CurrentUserData.id{
            return 50

        }
        return 0

    }
    @IBAction func Route(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "TravelRouteViewController") as! TravelRouteViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedHeader = sender.tag
        vc.PlanDetail = PlanDetail
        present(vc, animated: true, completion: nil)

    }
    @IBAction func AddTime(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddRouteViewController") as! AddRouteViewController
        vc.modalPresentationStyle = .fullScreen
        vc.PlanDetail = self.PlanDetail.dates[sender.tag]
        present(vc, animated: true, completion: nil)

    }
    func ApiDeleteRoute(id : Int)  {
        
     
            let dict = [
                "route_id" : id
            ] as [String : Any]
            view.isUserInteractionEnabled = false
            APIClients.POST_user_deleteRoute(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    self.view.isUserInteractionEnabled = true
                    Constants.Toast.MyToast(message: response.message   )

                    let when = DispatchTime.now() + 1.7
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        self.Get_PlanDetail()
                    }
                case .failure(let error):
                    print(error)
                    self.view.isUserInteractionEnabled = true
                }
                
            } failure: { (error) in
                self.view.isUserInteractionEnabled = true

            }
        }
}

extension TravelDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imgCollectionView{
            if (PlanDetail != nil) {
                return PlanDetail.images.count
            }
            return 0
        }
        if (PlanDetail != nil) {
            return PlanDetail.followers.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imgCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! planImageCollectionViewCell
            let lbl = cell.img!
            let btn = cell.btnDelete!
//            btn.isHidden = true
            btn.addTarget(self, action: #selector(self.DeleteImage(_:)), for: .touchDown)
            btn.tag = indexPath.row

            lbl.getImage(url: PlanDetail.images[indexPath.row].image)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath)
        let lbl = cell.viewWithTag(1) as! UIImageView
        lbl.getImage(url: PlanDetail.followers[indexPath.row].user_image)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imgCollectionView{
            let vc = storyboard?.instantiateViewController(identifier: "ImagesViewController") as! ImagesViewController
            vc.modalPresentationStyle = .fullScreen
            vc.isURL = true
            vc.ImagesURL = PlanDetail.images.map({ ($0.image)})
            vc.SelectedIndex = indexPath.row
            present(vc, animated: true, completion: nil)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "FollowerListViewController") as! FollowerListViewController
            vc.modalPresentationStyle = .fullScreen
            vc.ViewFrom = "Followed"
            vc.PlanData = PlanDetail

            present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func DeleteImage(_ sender: UIButton) {
        ApiDeleteImage(id: PlanDetail.images[sender.tag].id)
    }
    
    func ApiDeleteImage(id : Int)  {
        
     
            let dict = [
                "plan_id" : PlanDetail.id,
                "image_id" : id
            ] as [String : Any]
            view.isUserInteractionEnabled = false
            APIClients.POST_user_deletePlanImage(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    self.view.isUserInteractionEnabled = true
                    Constants.Toast.MyToast(message: response.message   )
                    self.Get_PlanDetail()
                    
                case .failure(let error):
                    print(error)
                    self.view.isUserInteractionEnabled = true
                }
                
            } failure: { (error) in
                self.view.isUserInteractionEnabled = true

            }
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imgCollectionView{
            return CGSize.init(width: imgCollectionView.frame.width, height: imgCollectionView.frame.height)
        }
        return CGSize.init(width: 30, height: 30)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        if (scrollView.viewWithTag(11) != nil){
            lblPageController.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
    }
}
extension TravelDetailViewController :  UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        Get_PlanDetail()
        
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
extension TravelDetailViewController : moreTravelDelegate{
    func moreClose(action: Int) {
        switch action {
        case 1:
            Delete()
            break
        case 2:
            Edit()
            break
        case 3:
            Share()
            break
        default:
            break
        }
    }
     func Edit() {
        let vc = storyboard?.instantiateViewController(identifier: "CreateTravelPlanViewController") as! CreateTravelPlanViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isEdit = true
        vc.PlanData = PlanData
        present(vc, animated: true, completion: nil)
    }
    
     func Delete() {
        ApiDeletePlan(id: PlanData.id)
    }
    
     func Share() {
        buildFDLLink(RequestID: "\(PlanData.id)", text: "Check Travel Plan", type: 3)

    }
    func ApiDeletePlan(id : Int)  {
        
     
            let dict = [
              
                "id" : id
                
            ] as [String : Any]
            view.isUserInteractionEnabled = false
            APIClients.POST_user_deletePlan(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    self.view.isUserInteractionEnabled = true
                    Constants.Toast.MyToast(message: response.message   )

                    let when = DispatchTime.now() + 1.7
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        self.Get_PlanDetail()
                    }
                case .failure(let error):
                    print(error)
                    self.view.isUserInteractionEnabled = true
                }
                
            } failure: { (error) in
                self.view.isUserInteractionEnabled = true

            }
        }

    
}
