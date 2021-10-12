//
//  AddRouteViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 02/09/21.
//

import UIKit
import LocationPicker
import MapKit
import CoreLocation
import GooglePlaces

class AddRouteViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var picker: UIDatePicker!
    
    var imagePricker : ImageController!
    let locationPicker = LocationPickerViewController()

    var PostLat : String = ""
    var PostLng : String = ""
    var PlanDetail : M_Plan_Detail_data_dates!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PostLat = Current_lat
        PostLng = Current_lng
        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func LocationBtn(_ sender: Any) {
//        AskLocationPicker()
        SearchLocation()

    }
    @IBAction func setlocation(_ sender: UITextField) {
     
    }
    @IBAction func AddMiage(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self, sender: sender, configureCellBlock: { (img, url) in
            self.img.image = img
        })
    }
    @IBAction func Update(_ sender: Any) {
        if lblName.CheckText() && txtLocation.CheckText() {
            ApiRoutePlan()
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
    func ApiRoutePlan()  {
        var time : String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  DateFormat.HH_mm.get()

        time = dateFormatter.string(from: picker.date)
        let dict = [
            "name" : lblName.text!,
            "address" : txtLocation.text!,
            "lat" : PostLat,
            "lng" : PostLng,
            "date_id" : PlanDetail.id,
            "route_time" : time,
            
        ] as [String : Any]
        view.isUserInteractionEnabled = false
        
        APIClients.POST_user_addRoute(parems: dict as [String : Any], imageKey: ["image"], image: [img.image!], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
                Constants.Toast.MyToast(message: response.message ?? ""   )

                let when = DispatchTime.now() + 1.7
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

        } progressUpload: { (pre) in
            
        }

        
        
    }

    func GetPlaceDetail() {
            let header = ["" : ""]
            
            DataModelCode().GetApiJson(Url: "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(self.txtLocation.text!)&key=\(Config.googleMapKey)&inputtype=textquery", method: .get, params: header, headers: header, storyBoard: storyboard!, navigation: self) { (data, error, status) in
                if status == 200{
                    print(data)
                    let placesClient = GMSPlacesClient()

                    let results = data.value(forKey: "candidates") as! [[String : Any]]
                    for i in results{
                        
                        let Place_id = M_Plan_ID.init(dict: i)
                        self.GooglePlaceImages(id: Place_id.place_id) { (place) in
                                if (place.photos != nil){
                                    
                                    if place.photos?.count == 0 {
                                        return
                                    }
                                    
                                    let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                                        // Call loadPlacePhoto to display the bitmap and attribution.
                                        placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                                          if let error = error {
                                            // TODO: Handle the error.
                                            print("Error loading photo metadata: \(error.localizedDescription)")
                                            return
                                          } else {
                                            print("Items")
                                            self.img.image = photo
                                            // Display the first image and its attributions.
                                          }
                                            
                                        })

                                    
                                }
                            
                        }

                    }

                    
                    
                }
            }
        }
}
extension AddRouteViewController : GMSAutocompleteViewControllerDelegate {
    func AskLocationPicker()  {
        let alert = UIAlertController.init(title: "Select Option", message: "", preferredStyle: .alert)
        let google = UIAlertAction.init(title: "Google Search", style: .default) { (action) in
            self.GoogleLocationPicker()
                
        }
        alert.addAction(google)
        
        let apple = UIAlertAction.init(title: "Apple Map", style: .default) { (action) in
            self.SearchLocation()
        }
        alert.addAction(apple)
        
        let Cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(Cancel)
        present(alert, animated: true, completion: nil)
    }
    func SearchLocation(){
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(PostLat ) ?? 0.0, longitude: Double(PostLng ) ?? 0.0), addressDictionary: nil)
        
        let location = Location(name: "", location: nil, placemark: placemark)
        locationPicker.location = location

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .blue

        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { location in
            // do some awesome stuff with location
     
            self.txtLocation.text = location?.address ?? ""
            self.PostLat = "\(location?.location.coordinate.latitude ?? 0.0)"
            self.PostLng = "\(location?.location.coordinate.longitude ?? 0.0)"
            self.GetPlaceDetail()
        }
        let navi = UINavigationController.init(rootViewController: locationPicker)
        if #available(iOS 14.0, *) {
            navi.navigationItem.backButtonDisplayMode = .default
        } else {
            // Fallback on earlier versions
        }
        navi.navigationItem.hidesBackButton = false
        navi.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navi.navigationBar.isHidden = false
        present(navi, animated: true, completion: nil)
//        navigationController?.pushViewController(locationPicker, animated: true)

    }
    func GoogleLocationPicker()  {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
                // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.photos.rawValue))
        autocompleteController.placeFields = fields
        
                // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
                // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
      txtLocation.text = place.name
      PostLat = "\(place.coordinate.latitude)"
      PostLng = "\(place.coordinate.longitude)"
        let placesClient = GMSPlacesClient()
        if (place.photos != nil) {
            if place.photos?.count == 0{
                return
            }
        
            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                            // Call loadPlacePhoto to display the bitmap and attribution.
            placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                if let error = error {
                                    // TODO: Handle the error.
                    print("Error loading photo metadata: \(error.localizedDescription)")
                    return
                } else {
                    print("Items")
                    self.img.image = photo
                                    // Display the first image and its attributions.
                }
            })
        }
        
        
        
        
//        self.GooglePlaceImages(id: place.placeID!) { (place) in
//                if (place.photos != nil){
//
//                    if place.photos?.count == 0 {
//                        return
//                    }
//                    let placesClient = GMSPlacesClient()
//
////
//
//                }
//        }
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
