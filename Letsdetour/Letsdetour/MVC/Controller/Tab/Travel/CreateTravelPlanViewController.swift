//
//  CreateTravelPlanViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 08/09/21.
//

import UIKit
import GooglePlaces
import LocationPicker
import MapKit
import CoreLocation

class CreateTravelPlanViewController: UIViewController {
    @IBOutlet weak var lblPermission: UILabel!
    @IBOutlet weak var btnStartPlan: UIButton!
    @IBOutlet weak var dateEnd: UIDatePicker!
    @IBOutlet weak var dateStart: UIDatePicker!
    
    @IBOutlet weak var txtWhereTo: UITextField!
    var imagePricker : ImageController!
    let locationPicker = LocationPickerViewController()
    var Address : String = ""

    var PostLat : String = ""
    var PostLng : String = ""
    var EndDate : String = ""
    var StartDate : String = ""
    var Premission : Int = 1
    var isEdit : Bool = false
    var isFromDetail : Bool = false

    var PlanData : M_Plan_data!
    var Detail : M_Google_Nearby!
    var Photos : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromDetail == false{
            PostLat = Current_lat
            PostLng = Current_lng
        }
        else{
            txtWhereTo.text = Address
        }
        dateStart.minimumDate = Date()
        self.Premission = 1
        self.lblPermission.text = "View"
        if isEdit{
            SetEditView()
            self.GetPlaceDetail()

        }
        // Do any additional setup after loading the view.
    }
    func SetEditView()  {
        dateEnd.isUserInteractionEnabled = true

        txtWhereTo.text = PlanData.address
        Premission = PlanData.permission
        if Premission == 1{
            lblPermission.text = "View"
        }
        if Premission == 2{
            lblPermission.text = "Edit"
        }
        btnStartPlan.setTitle("Update Plan", for: .normal)
        StartDate = PlanData.start_date
        EndDate = PlanData.end_date
        
        dateStart.date =  PlanData.start_date.GetDateFromString(format: DateFormat.yyyy_MM_dd.get())
        dateEnd.date =  PlanData.end_date.GetDateFromString(format: DateFormat.yyyy_MM_dd.get())

    }
    @IBAction func BtnLocation(_ sender: Any) {
        SearchLocation()
    }
    @IBAction func StartDate(_ sender: UIDatePicker) {
        dateEnd.minimumDate = sender.date
        dateEnd.isUserInteractionEnabled = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  DateFormat.yyyy_MM_dd.get()

        StartDate = dateFormatter.string(from: sender.date)
        EndDate = dateFormatter.string(from: sender.date)

    }
    
    @IBAction func EndDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  DateFormat.yyyy_MM_dd.get()
        EndDate = dateFormatter.string(from: sender.date)
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    func ApiCreatePlan()  {
     
        let dict = [
            "address" : txtWhereTo.text!,
            "lat" : PostLat,
            "lng" : PostLng,
            "start_date" : StartDate,
            "end_date" : EndDate,
            "permission" : Premission,
            "photo_reference" :  Photos.componentsJoined(by: ",")
            
        ] as [String : Any]
        view.isUserInteractionEnabled = false
        APIClients.POST_user_createPlan(parems: dict as [String : Any], storyBoard: storyboard!, navigation: self)  { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
                Constants.Toast.MyToast(message: response.message   )

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

        }
    }
    func ApiUpdatePlan()  {
       
        let dict = [
            "address" : txtWhereTo.text!,
            "lat" : PostLat,
            "lng" : PostLng,
            "start_date" : StartDate,
            "end_date" : EndDate,
            "permission" : Premission,
            "plan_id" : PlanData.id,
            "photo_reference" : Photos.componentsJoined(by: ",")

            
        ] as [String : Any]
        view.isUserInteractionEnabled = false
        APIClients.POST_user_updatePlan(parems: dict as [String : Any], imageKey: [], image: [], storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.view.isUserInteractionEnabled = true
                Constants.Toast.MyToast(message: response.message   )

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
    @IBAction func setLocation(_ sender: UITextField) {
       

    }
    
    @IBAction func Promssion(_ sender: Any) {
        let alert = UIAlertController.init(title: "Set Premission", message: "", preferredStyle: .actionSheet)
        let view = UIAlertAction.init(title: "View", style: .default) { (act) in
            self.Premission = 1
            self.lblPermission.text = "View"
        }
        alert.addAction(view)
        let Edit = UIAlertAction.init(title: "Edit", style: .default) { (act) in
            self.Premission = 2
            self.lblPermission.text = "Edit"

        }
        alert.addAction(Edit)

        let Cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (act) in
            
        }
        alert.addAction(Cancel)
        present(alert, animated: true, completion: nil)

    }
    @IBAction func StartPlan(_ sender: Any) {
        if txtWhereTo.CheckText() && CheckTextField().CheckText(text: StartDate, String_type: "start Date") && CheckTextField().CheckText(text: EndDate, String_type: "end Date") {
            if isEdit{
                ApiUpdatePlan()
            }
            else{
                ApiCreatePlan()
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
     
            self.txtWhereTo.text = location?.address ?? ""
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

    }
    func GetPlaceDetail() {
            let header = ["" : ""]
            
            DataModelCode().GetApiJson(Url: "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(self.txtWhereTo.text!)&key=\(Config.googleMapKey)&inputtype=textquery", method: .get, params: header, headers: header, storyBoard: storyboard!, navigation: self) { (data, error, status) in
                if status == 200{
                    print(data)
                    
                    let results = data.value(forKey: "candidates") as! [[String : Any]]
                    for i in results{
                        
                        let Place_id = M_Plan_ID.init(dict: i)
                        self.GetPlaceImages(place_id: Place_id.place_id)
              
                    }

                    
                    
                }
            }
        }
    func GetPlaceImages(place_id: String)  {
        let header = ["" : ""]
    

        DataModelCode().GetApiJson(Url: "https://maps.googleapis.com/maps/api/place/details/json?location=\(Current_lat),\(Current_lng)&place_id=\(place_id)&key=\(Config.googleMapKey)", method: .get, params: header, headers: header, storyBoard: storyboard!, navigation: self) { (data, error, status) in
            if status == 200{
                print(data)
                self.Detail = M_Google_Nearby.init(dict: data.value(forKey: "result") as! [String : Any])
            
                self.Photos = NSMutableArray.init(array: self.Detail.photo_reference)
                


                
                
            }
        }
    }
    
    
}
