//
//  ListFeedViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit

class ListFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var SelectedHeader : Int = 0
    var Filter = [String]()
    var CollectionPlaces = [M_Google_Nearby]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("RestaurantTableViewCell")
        
        switch  SelectedHeader{
        case 0:
            Filter = FilterSearchType.Restaurants.get()
        case 1:
            Filter = FilterSearchType.Accommodation.get()
        case 2:
            Filter = FilterSearchType.ATTractions.get()
        case 3:
            Filter = FilterSearchType.Nightlife.get()
        default:
            break
        }
        
        
        
        for i in Filter{
            Get_Google_Data(filter: i)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func AddPost(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CreateTravelPlanViewController") as! CreateTravelPlanViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func Get_Google_Data(filter : String)  {
        let header = ["" : ""]


        DataModelCode().GetApiJson(Url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Current_lat),\(Current_lng)&type=\(filter)&key=\(Config.googleMapKey)&keyword=\(filter)&sensor=true&rankby=distance", method: .get, params: header, headers: header, storyBoard: storyboard!, navigation: self) { (data, error, status) in
            if status == 200{
                print(data)
                let results = data.value(forKey: "results") as! [[String : Any]]
                for i in results{

                    let dict = M_Google_Nearby.init(dict: i)
                    
                    self.CollectionPlaces.append(dict)

                }
                self.CollectionPlaces = self.CollectionPlaces.sorted(by: { $0.Distance < $1.Distance })
                 
                
                self.tableView.reloadData()
                
            }
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
extension ListFeedViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionPlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        cell.selectionStyle = .none
        cell.img.image = #imageLiteral(resourceName: "default_upload_image")
        if CollectionPlaces[indexPath.row].photo_reference.count != 0{
            GooglePlaceImage(id: CollectionPlaces[indexPath.row].place_id, img: cell.img)
          
        }
        else{
            cell.img.getImage(url: CollectionPlaces[indexPath.row].icon)

        }
        cell.lblName.text = CollectionPlaces[indexPath.row].name
        cell.lblDetail.text = CollectionPlaces[indexPath.row].vicinity
        cell.lblRate.text = "\(CollectionPlaces[indexPath.row].rating)/\(CollectionPlaces[indexPath.row].user_ratings_total)"
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "FeedDetailViewController") as! FeedDetailViewController
        vc.modalPresentationStyle = .fullScreen
        vc.Place_id = CollectionPlaces[indexPath.row].place_id
        present(vc, animated: true, completion: nil)
    }
}
extension ListFeedViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath)
        let lbl = cell.viewWithTag(1) as! UILabel
        let lbl1 = cell.viewWithTag(2) as! UILabel
        lbl1.isHidden = true
        lbl.textColor = .Primary
        switch indexPath.row {
        case 0:
            lbl.text = "Restaurants".uppercased()
        case 1:
            lbl.text = "Accommodations".uppercased()
        case 2:
            lbl.text = "ATTractions".uppercased()
        case 3:
            lbl.text = "Nightlife".uppercased()
        default:
            lbl.text = ""
        }
        if SelectedHeader == indexPath.row{
            lbl1.isHidden = false
            lbl.textColor = .Secondary
        }
        

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.CollectionPlaces.removeAll()
        self.tableView.reloadData()
        SelectedHeader = indexPath.row
        if SelectedHeader == 0{
            Filter = FilterSearchType.Restaurants.get()
            for i in Filter {
                Get_Google_Data(filter: i)
            }

        }
        if SelectedHeader == 1{
            Filter = FilterSearchType.Accommodation.get()
            for i in Filter {
                Get_Google_Data(filter: i)
            }
        }

        if SelectedHeader == 2{
            Filter = FilterSearchType.ATTractions.get()
            for i in Filter {
                Get_Google_Data(filter: i)
            }
        }

        if SelectedHeader == 3{
            Filter = FilterSearchType.Nightlife.get()
            for i in Filter {
                Get_Google_Data(filter: i)
            }
  

        }
        
        collectionView.reloadData()
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}
