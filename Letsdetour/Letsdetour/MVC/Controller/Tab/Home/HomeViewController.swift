//
//  HomeViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit
import CoreLocation
import GooglePlaces

class HomeViewController: UIViewController , CLLocationManagerDelegate  {
    @IBOutlet weak var viewNightlife: UIView!
    
    @IBOutlet weak var c_FeedHeight: NSLayoutConstraint!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var viewFeed: UIView!
    @IBOutlet weak var nightlifeCollectionView: UICollectionView!
    @IBOutlet weak var attractionsCollectionView: UICollectionView!
    @IBOutlet weak var viewAttractions: UIView!
    @IBOutlet weak var viewRestaurants: UIView!
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    @IBOutlet weak var accommodationsCollectionView: UICollectionView!
    @IBOutlet weak var viewAccommodations: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!
    var locationManager = CLLocationManager()
    var IsLocationGet : Bool = false
    var CollectionFeed  = [M_Feed_Data]()
    var CollectionNightlife  = [M_Google_Nearby]()
    var CollectionAttractions  = [M_Google_Nearby]()
    var CollectionRestaurants  = [M_Google_Nearby]()
    var CollectionAccommodations  = [M_Google_Nearby]()
    var SearchLat : String = ""
    var SearchLng : String = ""
    var FilterType : String = FilterSearchType.Restaurants.get().first ?? ""
    var FilterTypetemp : String = "0"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.RegisterTableCell("FeedTableViewCell")
        nightlifeCollectionView.RegisterTableCell("FeedCollectionViewCell")
        attractionsCollectionView.RegisterTableCell("FeedCollectionViewCell")
        restaurantsCollectionView.RegisterTableCell("FeedCollectionViewCell")
        accommodationsCollectionView.RegisterTableCell("FeedCollectionViewCell")
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        nightlifeCollectionView.delegate = self
        nightlifeCollectionView.dataSource = self
        
        attractionsCollectionView.delegate = self
        attractionsCollectionView.dataSource = self
        
        restaurantsCollectionView.delegate = self
        restaurantsCollectionView.dataSource = self
        
        accommodationsCollectionView.delegate = self
        accommodationsCollectionView.dataSource = self
        SetProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(SetProfile), name: NSNotification.Name(rawValue: "NotificationUpdateProfile") , object: [:])
        self.UpdateProfile()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.GetCurrentLocation()
        if Current_lat != ""{
            POST_Homedata()
            Get_Google_Data(type: "0")
        }
    }
    func Get_Google_Data(type : String)  {
        let header = ["" : ""]
        self.viewNightlife.isHidden = true
        self.viewRestaurants.isHidden = true
        self.viewAccommodations.isHidden = true
        self.viewAttractions.isHidden = true

        DataModelCode().GetApiJson(Url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(SearchLat),\(SearchLng)&type=\(FilterType)&key=\(Config.googleMapKey)&keyword=\(FilterType)&sensor=true&rankby=distance", method: .get, params: header, headers: header, storyBoard: storyboard!, navigation: self) { (data, error, status) in
            if status == 200{
                print(data)
                
                let results = data.value(forKey: "results") as! [[String : Any]]
                for i in results{
                    
                    let dict = M_Google_Nearby.init(dict: i)
                   

                    if type == "0"{
                        self.CollectionRestaurants.append(dict)
                    }
                    if type == "1"{
                        self.CollectionAccommodations.append(dict)
                    }
                    if type == "2"{
                        self.CollectionAttractions.append(dict)
                    }
                    if type == "3"{
                        self.CollectionNightlife.append(dict)
                    }
                   
                  
             
                }

                
                
                
                
                if self.CollectionNightlife.count == 0{
                    self.viewNightlife.isHidden = true
                }
                else{
                    self.viewNightlife.isHidden = false
                    self.nightlifeCollectionView.reloadData()
                }
                if self.CollectionRestaurants.count == 0{
                    self.viewRestaurants.isHidden = true
                }
                else{
                    self.viewRestaurants.isHidden = false
                    self.restaurantsCollectionView.reloadData()
                }
                if self.CollectionAccommodations.count == 0{
                    self.viewAccommodations.isHidden = true
                }
                else{
                    self.viewAccommodations.isHidden = false
                    self.accommodationsCollectionView.reloadData()
                }
                if self.CollectionAttractions.count == 0{
                    self.viewAttractions.isHidden = true
                }
                else{
                    self.viewAttractions.isHidden = false
                    self.attractionsCollectionView.reloadData()
                }
                let arr = self.FilterTypetemp.components(separatedBy: ",")
                if !arr.contains("0"){
                    self.viewRestaurants.isHidden = true
                }
                if !arr.contains("1"){
                    self.viewAccommodations.isHidden = true

                }

                if !arr.contains("2"){
                    self.viewAttractions.isHidden = true


                }

                if !arr.contains("3"){
                    self.viewNightlife.isHidden = true

          

                }
                
            }
        }
    }
    func POST_Homedata()  {
        
//        https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters

        
        let dict = ["type" : FilterType,
                    "lat" : SearchLat,
                    "lng" : SearchLng] as [String : Any]
        

        APIClients.POST_Homedata(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                self.CollectionFeed = response.data.feeds
                self.feedTableView.reloadData()
                self.c_FeedHeight.constant = self.feedTableView.contentSize.height + 60
                self.view.updateFocusIfNeeded()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }

    }
    func GetCurrentLocation()  {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
            {
                
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
           print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_lat = "\(locValue.latitude)"
        Current_lng = "\(locValue.longitude)"
        SearchLat = Current_lat
        SearchLng = Current_lng
        if !IsLocationGet{
            IsLocationGet = true
            POST_Homedata()
            Get_Google_Data(type: "0")
        }

        manager.stopUpdatingLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
  

    @objc func SetProfile()  {
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "", isUser: true)
        lblName.text = Constants.CurrentUserData.user_name

    }
    override func viewDidLayoutSubviews() {
        c_FeedHeight.constant = feedTableView.contentSize.height + 60
        view.updateFocusIfNeeded()
    }
    override func viewLayoutMarginsDidChange() {
        c_FeedHeight.constant = feedTableView.contentSize.height + 60
        view.updateFocusIfNeeded()
    }
    override func viewWillLayoutSubviews() {
        c_FeedHeight.constant = feedTableView.contentSize.height + 60
        view.updateFocusIfNeeded()
    }
    @IBAction func Notification(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationListViewController") as! NotificationListViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Search(_ sender: UITextField) {
        sender.resignFirstResponder()
        autocompleteClicked(sender)
    }
    
    @IBAction func Filter(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Accommodations(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ListFeedViewController") as! ListFeedViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedHeader = 1
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Restaurants(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ListFeedViewController") as! ListFeedViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedHeader = 0
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Attractions(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ListFeedViewController") as! ListFeedViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedHeader = 2
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Nightlife(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ListFeedViewController") as! ListFeedViewController
        vc.modalPresentationStyle = .fullScreen
        vc.SelectedHeader = 3
        present(vc, animated: true, completion: nil)
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
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        c_FeedHeight.constant = feedTableView.contentSize.height + 60

        switch collectionView {
        case restaurantsCollectionView:
            return CollectionRestaurants.count
        case accommodationsCollectionView:
            return CollectionAccommodations.count
        case attractionsCollectionView:
            return CollectionAttractions.count
        case nightlifeCollectionView:
            return CollectionNightlife.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as! FeedCollectionViewCell
        var Dict : M_Google_Nearby!
        switch collectionView {
        case restaurantsCollectionView:
            Dict =  CollectionRestaurants[indexPath.row]
        case accommodationsCollectionView:
            Dict =  CollectionAccommodations[indexPath.row]

        case attractionsCollectionView:
            Dict =  CollectionAttractions[indexPath.row]

        case nightlifeCollectionView:
            Dict =  CollectionNightlife[indexPath.row]
        default:
            return cell
        }
        cell.img.image = #imageLiteral(resourceName: "default_upload_image")
        if Dict.photo_reference.count != 0{
            GooglePlaceImage(id: Dict.place_id, img: cell.img)
          
        }
        else{
            cell.img.getImage(url: Dict.icon)

        }
        cell.lblName.text = Dict.name
        cell.lblDetail.text = Dict.vicinity
        cell.lblRate.text = "\(Dict.rating)/\(Dict.user_ratings_total)"
        view.updateFocusIfNeeded()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var Dict : M_Google_Nearby!
        switch collectionView {
        case restaurantsCollectionView:
            Dict =  CollectionRestaurants[indexPath.row]
        case accommodationsCollectionView:
            Dict =  CollectionAccommodations[indexPath.row]

        case attractionsCollectionView:
            Dict =  CollectionAttractions[indexPath.row]

        case nightlifeCollectionView:
            Dict =  CollectionNightlife[indexPath.row]

        default:
            return
        }
        let vc = storyboard?.instantiateViewController(identifier: "FeedDetailViewController") as! FeedDetailViewController
        vc.modalPresentationStyle = .fullScreen
        vc.Place_id = Dict.place_id
        present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.size.width - 20, height: collectionView.bounds.size.height)
    }
}
extension HomeViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionFeed.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none
        cell.lblName.text = CollectionFeed[indexPath.row].user_name
        cell.imgUser.getImage(url: CollectionFeed[indexPath.row].user_image)
        cell.lblDetail.text = CollectionFeed[indexPath.row].detail
        cell.imgFeed.getImage(url: CollectionFeed[indexPath.row].image)
        cell.lblDate.text = CollectionFeed[indexPath.row].created_at.getTimeAgo()
        c_FeedHeight.constant = feedTableView.contentSize.height + 60
        tableView.updateFocusIfNeeded()
        view.updateFocusIfNeeded()

        cell.lblNumberOfLikes.text = "\(CollectionFeed[indexPath.row].total_likes) Likes"
        cell.lblNumberOfComments.text = "\(CollectionFeed[indexPath.row].total_comments) Comments"
        cell.btnLike.addTarget(self, action: #selector(self.LikeUnlike(_:)), for: .touchDown)
        cell.btnLike.tag = indexPath.row
        cell.btnLike.accessibilityLabel = "\(CollectionFeed[indexPath.row].like_status)"
        
        cell.btnFollow.addTarget(self, action: #selector(self.FollowUnFollow(_:)), for: .touchDown)
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.accessibilityLabel = "\(CollectionFeed[indexPath.row].follow_status)"
        cell.btnShare.addTarget(self, action: #selector(self.Share(_:)), for: .touchDown)
        cell.btnShare.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(self.Comment(_:)), for: .touchDown)
        cell.btnComment.tag = indexPath.row
        
        if CollectionFeed[indexPath.row].follow_status == "1"{
            cell.btnFollow.setTitle("Unfollow", for: .normal)
        }
        else if CollectionFeed[indexPath.row].follow_status == "2"{
            cell.btnFollow.setTitle("Requested", for: .normal)
        }
        else{
            cell.btnFollow.setTitle("Follow", for: .normal)

        }
        if CollectionFeed[indexPath.row].like_status == 1{
            cell.lblLike.text = "Unlike"
            cell.imgLike.image = #imageLiteral(resourceName: "ic_like_selected")
          
        }
        else{
            cell.imgLike.image = #imageLiteral(resourceName: "ic_like_normal")

            cell.lblLike.text = "Like"

        }
        if CollectionFeed[indexPath.row].user_id == Constants.CurrentUserData.id{
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
        vc.FeedData = CollectionFeed[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.updateFocusIfNeeded()
        view.updateFocusIfNeeded()
        c_FeedHeight.constant = feedTableView.contentSize.height + 60
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.updateFocusIfNeeded()
        view.updateFocusIfNeeded()
        c_FeedHeight.constant = feedTableView.contentSize.height + 60

    }
 
    @IBAction func LikeUnlike(_ sender: UIButton) {
        if CollectionFeed[sender.tag].like_status == 1{
            ApiLike(status: 0, feed_id: CollectionFeed[sender.tag].id)
        }
        else{
            ApiLike(status: 1, feed_id: CollectionFeed[sender.tag].id)
        }
        
    }
    @IBAction func FollowUnFollow(_ sender: UIButton) {
        if CollectionFeed[sender.tag].follow_status == "1" || CollectionFeed[sender.tag].follow_status == "2"{
            ApiFollow(status: 0, follower_id: CollectionFeed[sender.tag].user_id)
        }
        else{
            ApiFollow(status: 1, follower_id: CollectionFeed[sender.tag].user_id)
        }
    }
    @IBAction func Share(_ sender: UIButton) {
        buildFDLLink(RequestID: "\(CollectionFeed[sender.tag].id)", text: "Check Feed", type: 1)
    }
    @IBAction func Comment(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "CommentViewController") as! CommentViewController
        vc.modalPresentationStyle = .fullScreen
        vc.FeedData = CollectionFeed[sender.tag]
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
                    self.POST_Homedata()

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
                    self.POST_Homedata()

                }

               
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }
    }
    
}
extension HomeViewController : FilterDelegate{
    func SearchFilterRestult(lat: String, lng: String, location: String, type: String) {
        SearchLat = lat
        SearchLng = lng
        txtSearch.text = location
        FilterTypetemp = type
 
        for i in FilterTypetemp.components(separatedBy: ",") {
            Get_Google_Data(type: i)
        }
    }
    
    
}
extension HomeViewController: GMSAutocompleteViewControllerDelegate {

    func autocompleteClicked(_ sender: UITextField) {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue))
      autocompleteController.placeFields = fields

      // Specify a filter.
      let filter = GMSAutocompleteFilter()
      filter.type = .address
      autocompleteController.autocompleteFilter = filter

      // Display the autocomplete view controller.
      present(autocompleteController, animated: true, completion: nil)
    }

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    txtSearch.text = place.name
    SearchLat = "\(place.coordinate.latitude)"
    SearchLng = "\(place.coordinate.longitude)"
    POST_Homedata()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
