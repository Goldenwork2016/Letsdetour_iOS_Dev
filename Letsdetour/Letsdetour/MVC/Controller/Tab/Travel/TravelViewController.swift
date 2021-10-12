//
//  TravelViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit

class TravelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedIndex : Int = -1
    var CollectionPlan = [M_Plan_data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("TravelPlanTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Get_Planlist()

    }
    
    @IBAction func Add(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CreateTravelPlanViewController") as! CreateTravelPlanViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func Get_Planlist()  {
        
//        https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters

        
        let dict = ["" : "",
                    ] as [String : Any]
        
       

        APIClients.GET_PlanList(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                self.CollectionPlan = response.data
                self.tableView.reloadData()
                

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
extension TravelViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionPlan.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelPlanTableViewCell", for: indexPath) as! TravelPlanTableViewCell
        cell.selectionStyle = .none
        cell.More.addTarget(self, action: #selector(More(_:)), for: .touchDown)
        cell.More.tag = indexPath.row
        cell.viewMore.isHidden = true

        if selectedIndex == indexPath.row{
            cell.viewMore.isHidden = false
        }
        cell.lblName.text = CollectionPlan[indexPath.row].address
        cell.lblDetail.text = "\(CollectionPlan[indexPath.row].start_date.getTimeFromTime(currentFormat: DateFormat.yyyy_MM_dd.get(), requiredFormat: DateFormat.MMM_dd.get())) to \(CollectionPlan[indexPath.row].end_date.getTimeFromTime(currentFormat: DateFormat.yyyy_MM_dd.get(), requiredFormat: DateFormat.MMM_dd.get()))"
        cell.lblDate.text = "In " + CollectionPlan[indexPath.row].start_date.getAge() + " days"
        cell.Edit.addTarget(self, action: #selector(self.Edit(_:)), for: .touchDown)
        cell.Edit.tag = indexPath.row
        cell.Delete.addTarget(self, action: #selector(self.Delete(_:)), for: .touchDown)
        cell.Delete.tag = indexPath.row
        cell.Share.addTarget(self, action: #selector(self.Share(_:)), for: .touchDown)
        cell.Share.tag = indexPath.row
        if CollectionPlan[indexPath.row].images.count != 0{
            cell.img.getImage(url: CollectionPlan[indexPath.row].images[0].image)
        }
        else{
            cell.img.image = #imageLiteral(resourceName: "default_upload_image")

        }
        if CollectionPlan[indexPath.row].permission == 2 || CollectionPlan[indexPath.row].user_id == Constants.CurrentUserData.id{
            cell.Edit.isHidden = false
        }
        else{
            cell.Edit.isHidden = true

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "TravelDetailViewController") as! TravelDetailViewController
        vc.modalPresentationStyle = .fullScreen
        vc.PlanData = CollectionPlan[indexPath.row]
        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func More(_ sender: UIButton) {
        if selectedIndex == sender.tag{
            selectedIndex = -1
        }
        else{
            selectedIndex = sender.tag
        }
        tableView.reloadData()
    }
    
    @IBAction func Edit(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "CreateTravelPlanViewController") as! CreateTravelPlanViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isEdit = true
        vc.PlanData = CollectionPlan[sender.tag]
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Delete(_ sender: UIButton) {
        ApiDeletePlan(id: CollectionPlan[sender.tag].id)
    }
    
    @IBAction func Share(_ sender: UIButton) {
        buildFDLLink(RequestID: "\(CollectionPlan[sender.tag].id)", text: "Check Travel Plan", type: 3)

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
                        self.Get_Planlist()
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
class CollectionViewOverlappingLayout: UICollectionViewFlowLayout {

  var overlap: CGFloat = 14


  override init() {
    super.init()
    self.sharedInit()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.sharedInit()
  }
  func sharedInit(){
    self.scrollDirection = .horizontal
    self.minimumInteritemSpacing = 0
  }

  override var collectionViewContentSize: CGSize{
    let xSize = CGFloat(self.collectionView!.numberOfItems(inSection: 0)) * self.itemSize.width
    let ySize = CGFloat(self.collectionView!.numberOfSections) * self.itemSize.height

    var contentSize = CGSize(width: xSize, height: ySize)

    if self.collectionView!.bounds.size.width > contentSize.width {
      contentSize.width = self.collectionView!.bounds.size.width
    }

    if self.collectionView!.bounds.size.height > contentSize.height {
      contentSize.height = self.collectionView!.bounds.size.height
    }

    return contentSize
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    let attributesArray = super.layoutAttributesForElements(in: rect)
    let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)

    for attributes in attributesArray! {
      var xPosition = attributes.center.x
      let yPosition = attributes.center.y

      if attributes.indexPath.row == 0 {
        attributes.zIndex = Int(INT_MAX) // Put the first cell on top of the stack
      } else {
        xPosition -= self.overlap * CGFloat(attributes.indexPath.row)
        attributes.zIndex = numberOfItems - attributes.indexPath.row //Other cells below the first one
      }

      attributes.center = CGPoint(x: xPosition, y: yPosition)
    }

    return attributesArray
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return UICollectionViewLayoutAttributes(forCellWith: indexPath)
  }
}
