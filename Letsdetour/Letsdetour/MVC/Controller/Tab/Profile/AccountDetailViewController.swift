//
//  AccountDetailViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 26/08/21.
//

import UIKit
import FlagPhoneNumber
import IQKeyboardManagerSwift

class AccountDetailViewController: UIViewController {

    @IBOutlet weak var txtPhon: FPNTextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var txtBio: IQTextView!

    
    var imagePricker : ImageController!
    var CountryList = [M_Country_data]()
    var StateList = [M_State_data]()
    var gradePicker: UIPickerView!
    var textPicker : ActionPickerController? {
        didSet{
            gradePicker?.dataSource = textPicker
            gradePicker?.delegate = textPicker
            gradePicker?.reloadAllComponents()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(SetProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        GetCountryList()

    }
    
    @objc func SetProfile()  {
        imgCover.getImage(url: Constants.CurrentUserData.cover_image ?? "")
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "", isUser: true)
        txtUserName.text = Constants.CurrentUserData.user_name
        txtPhon.text = Constants.CurrentUserData.phone
        txtEmail.text = Constants.CurrentUserData.email
        txtEmail.isUserInteractionEnabled = false
        txtCountry.text = Constants.CurrentUserData.country
        txtCity.text = Constants.CurrentUserData.city
        txtBio.text = Constants.CurrentUserData.bio

        txtPhon.text = Constants.CurrentUserData.phone
        let repository: FPNCountryRepository = txtPhon.countryRepository
        print("\(Constants.CurrentUserData.country_code)")
        if repository.countries.filter({ ($0.phoneCode == "\(Constants.CurrentUserData.country_code)")}).count != 0{
            let i = repository.countries.filter({ ($0.phoneCode == txtPhon.selectedCountry?.phoneCode)})[0].phoneCode
            print(i)

            txtPhon.setFlag(countryCode: FPNCountryCode(rawValue: i)!)
            
        }
        else{
            
        }
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Update(_ sender: Any) {
        UpdateProfileApi()
    }
    @IBAction func City(_ sender: UITextField) {
        if txtCountry.accessibilityHint != nil {
            sender.resignFirstResponder()
            IQKeyboardManager.shared.resignFirstResponder()

            self.GetCityList(id: Int(txtCountry.accessibilityHint ?? "1")!)

        }
    }
    @IBAction func Country(_ sender: UITextField) {
        if CountryList.count != 0{
            sender.resignFirstResponder()
            IQKeyboardManager.shared.resignFirstResponder()
            textPicker = ActionPickerController.init(array: [CountryList.map({ ($0.name)})], title: sender.placeholder ?? "", picker: gradePicker, viewController: self, sender: sender, configureCellBlock: { (arr, index, status) in
                if status == "Done"{
                    sender.text = self.CountryList[index ?? 0].name
                    sender.accessibilityHint = "\(self.CountryList[index ?? 0].id)"
                    self.txtCity.text = ""
                    
               
                    
                }
            })
           
        }
    }
    @IBAction func AddPhoto(_ sender: UIButton) {
        if sender.tag == 1{
            imagePricker =  ImageController.init(viewController: self, sender: sender, configureCellBlock: { (img, url) in
                self.imgCover.image = img
            })
        }
        else{
            imagePricker =  ImageController.init(viewController: self, sender: sender, configureCellBlock: { (img, url) in
                self.imgUser.image = img
            })
        }
    }
    
    
    func GetCountryList()  {
        APIClients.GET_country_list( storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.CountryList = response.data
                let cont = self.CountryList.filter { ($0.name == Constants.CurrentUserData.country)}
                if cont.count != 0{
                    self.txtCountry.accessibilityHint = cont[0].name
                }
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }

    }
    func GetCityList(id: Int)  {
        let dict = ["country_id" : id]
        APIClients.GET_state_list(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.StateList = response.data
                self.textPicker = ActionPickerController.init(array: [self.StateList.map({ ($0.name)})], title: self.txtCity.placeholder ?? "", picker: self.gradePicker, viewController: self, sender: self.txtCity, configureCellBlock: { (arr, index, status) in
                    if status == "Done"{
                        self.txtCity.text = self.StateList[index ?? 0].name
                       
                    }
                })

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        }

    }
    func UpdateProfileApi() {
        let dict = [
            "email" : txtEmail.text!,
            "user_name" : txtUserName.text!,
            "country" : txtCountry.text!,
            "city" : txtCity.text!,
            "phone" : txtPhon.text!,
            "country_code" : txtPhon.selectedCountry?.phoneCode ?? "",
            "bio" : txtBio.text!
            
        ]
        APIClients.UpdateProfile(parems: dict , imageKey: ["image", "cover_image"] , image: [imgUser.image!, imgCover.image!],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    DataManager.CurrentUserData = response.user
                    Constants.CurrentUserData = response.user
                    NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])
                    self.Dismiss()
                    
                }
         
                
            case .failure(let error):
                print(error)

           
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
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
