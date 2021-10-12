//
//  FilterViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import GooglePlaces

protocol FilterDelegate {
    func SearchFilterRestult(lat : String , lng : String, location : String , type : String)
}

class FilterViewController: UIViewController {
    var delegate : FilterDelegate!
    @IBOutlet weak var btnNightlife: UIButton!
    @IBOutlet weak var Attraction: UIButton!
    @IBOutlet weak var btnAccommodation: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnRestaurant: UIButton!
    var SearchLat : String = ""
    var SearchLng : String = ""
    var ArrayFilter : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchLat = Current_lat
        SearchLng = Current_lng
        txtLocation.text = "Current Location"
        btnNightlife.setImage(#imageLiteral(resourceName: "ic_round_checkbox_normal"), for: .normal)
        Attraction.setImage(#imageLiteral(resourceName: "ic_round_checkbox_normal"), for: .normal)
        btnAccommodation.setImage(#imageLiteral(resourceName: "ic_round_checkbox_normal"), for: .normal)
        btnRestaurant.setImage(#imageLiteral(resourceName: "ic_round_checkbox_normal"), for: .normal)
        
        btnNightlife.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)
        Attraction.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)
        btnAccommodation.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)
        btnRestaurant.setImage(#imageLiteral(resourceName: "ic_round_checkbox_selected"), for: .selected)

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Filter(_ sender: UIButton) {
        if ArrayFilter.contains(sender.tag){
            ArrayFilter.remove(sender.tag)
        }
        else{
            ArrayFilter.add(sender.tag)
        }
        switch sender.tag {
        case 0:
            btnRestaurant.isSelected = !btnRestaurant.isSelected
        case 1:
            btnAccommodation.isSelected = !btnAccommodation.isSelected
        case 2:
            Attraction.isSelected = !Attraction.isSelected
        case 3:
            btnNightlife.isSelected = !btnNightlife.isSelected
        default:
            break
        }
    }
    
    @IBAction func Location(_ sender: UITextField) {
        autocompleteClicked(sender)
    }
    @IBAction func Apply(_ sender: Any) {
        Dismiss(true) {
            self.delegate.SearchFilterRestult(lat: self.SearchLat, lng: self.SearchLng, location:self.txtLocation.text!, type: self.ArrayFilter.componentsJoined(by: ","))
        }
    }
    @IBAction func Reset(_ sender: Any) {
        btnRestaurant.isSelected = true
        btnAccommodation.isSelected = false
        Attraction.isSelected = false
        btnNightlife.isSelected = false
        ArrayFilter.removeAllObjects()
        ArrayFilter.add(0)
        SearchLat = Current_lat
        SearchLng = Current_lng
        txtLocation.text = "Current Location"
    }
    func Filter()  {
        if ArrayFilter.contains(0){
            btnRestaurant.isSelected = true
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
extension FilterViewController: GMSAutocompleteViewControllerDelegate {

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
    SearchLat = "\(place.coordinate.latitude)"
    SearchLng = "\(place.coordinate.longitude)"
    
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
