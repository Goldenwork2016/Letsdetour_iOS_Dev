//
//  CreatePostViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import LocationPicker
import MapKit


class CreatePostViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDetail: IQTextView!
    var imagePricker : ImageController!
    let locationPicker = LocationPickerViewController()

    var PostLat : String = ""
    var PostLng : String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        PostLat = Current_lat
        PostLng = Current_lng

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Create(_ sender: UIButton) {
        if txtLocation.CheckText() && CheckTextField().CheckText(text: txtDetail.text!, String_type: "Description"){
            ApiCreatePost()
        }
   
    }
    
    @IBAction func location(_ sender: UITextField) {
        sender.resignFirstResponder()
        SearchLocation()
        
    }
    @IBAction func AddPhoto(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self, sender: sender, configureCellBlock: { (img, url) in
            self.img.image = img
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func LocationFromMap(_ sender: Any) {
        SearchLocation()

    }
    func ApiCreatePost()  {
        let dict = [
            "detail" : txtDetail.text!,
            "address" : txtLocation.text!,
            "lat" : PostLat,
            "lng" : PostLng,
            
        ]
        view.isUserInteractionEnabled = false
        APIClients.CreatePost(parems: dict as [String : Any] , imageKey: ["image"] , image: [img.image!] , loader : true  , alert : true ,storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true

                Constants.Toast.MyToast(message: response.message   )
                let when = DispatchTime.now() + 1.7
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.tabBarController?.selectedIndex = 0                    
                }
            case .failure(let error):
                print(error)
                self.view.isUserInteractionEnabled = true
            }
            
        } failure: { (error) in
            self.view.isUserInteractionEnabled = true

        } progressUpload: { (per) in
            print(per)
        }
    }

}
extension CreatePostViewController: GMSAutocompleteViewControllerDelegate {

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
    txtLocation.text = place.name
    PostLat = "\(place.coordinate.latitude)"
    PostLng = "\(place.coordinate.longitude)"

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
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//            UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter
//
//        // Display the autocomplete view controller.
//        present(autocompleteController, animated: true, completion: nil)
    }
}
