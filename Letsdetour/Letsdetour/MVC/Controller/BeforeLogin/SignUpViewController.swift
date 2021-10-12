//
//  SignUpViewController.swift
//  Letsdetour
//
//  Created by Jaypreet on 24/08/21.
//

import UIKit
import FlagPhoneNumber
import IQKeyboardManagerSwift
import FBSDKLoginKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var viewAppleLogin: UIView!
    @IBOutlet weak var txtUserNamr: UITextField!
    
    @IBOutlet weak var btnTermstext: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var FBButton: FBLoginButton!
    @IBOutlet weak var txtPhone: FPNTextField!
    @IBOutlet weak var imgUser: UIImageView!
    
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
        btnTerms.setImage(#imageLiteral(resourceName: "ic_checkbox_selected"), for: .selected)
        self.imgUser.image = #imageLiteral(resourceName: "ic_default_user")
        btnTermstext.titleLabel?.numberOfLines = 2
//        txtPhone.displayMode = .list
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        GetCountryList()
        self.setUpSignInAppleButton(btn: viewAppleLogin)

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
    @IBAction func City(_ sender: UITextField) {
      
        
        if txtCountry.accessibilityHint != nil {
            sender.resignFirstResponder()
            IQKeyboardManager.shared.resignFirstResponder()

            self.GetCityList(id: Int(txtCountry.accessibilityHint ?? "1")!)

        }
    }
    @IBAction func Login(_ sender: Any) {
        Dismiss()
    }
    
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func AddImage(_ sender: UIButton) {
        imagePricker =  ImageController.init(viewController: self, sender: sender, configureCellBlock: { (img, url) in
            self.imgUser.image = img
        })
    }
    @IBAction func Google(_ sender: UIButton) {
        self.GoogleLogin(btn: sender)
    }
    @IBAction func FAceBook(_ sender: Any) {
        self.FaceBookLogin()

    }
    @IBAction func SignUp(_ sender: Any) {
        
        if txtUserNamr.CheckText() && txtEmail.CheckText(.Email) && txtPassword.CheckText(.Password) && txtPassword.MatchPassword(txt: txtConfirmPassword) && CheckTextField().CheckTermsAndConditions(isChecked: btnTerms.isSelected){
            SendOTPApi()
        }
        
        
        

    }
    
    @IBAction func OPenTerms(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TermsViewController") as! TermsViewController
        vc.SelectedType = 3
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Terms(_ sender: Any) {
        btnTerms.isSelected = !btnTerms.isSelected
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func GetCountryList()  {
        APIClients.GET_country_list( storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.CountryList = response.data
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
    func SendOTPApi() {
        let dict = [
            "email" : txtEmail.text!,
            "user_name" : txtUserNamr.text!,
            "password" : txtPassword.text!,
            "country" : txtCountry.text!,
            "city" : txtCity.text!,
            "phone" : txtPhone.text!,
            "country_code" : txtPhone.selectedCountry?.phoneCode ?? ""
        ]
        APIClients.RegisterProfile(parems: dict , imageKey: ["image"] , image: [imgUser.image!],storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    let vc = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                    vc.modalPresentationStyle = .fullScreen
                    if self.isAppDevelopment(){
                        vc.OTP = "\(response.otp ?? 0)"
                    }
                    vc.Phone = self.txtPhone.text!
                    vc.Country_Code = self.txtPhone.selectedCountry?.phoneCode ?? ""
                    vc.Email = self.txtEmail.text!

                    self.present(vc, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)

           
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
        }

    }

}
