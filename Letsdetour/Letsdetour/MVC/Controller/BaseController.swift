//
//  BaseController.swift
//  Letsdetour
//
//  Created by Jaypreet on 25/08/21.
//

import Foundation
import UIKit
import CoreLocation
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import GooglePlaces
import  FirebaseDynamicLinks



var Current_lat  : String = ""
var Current_lng  : String = ""

extension UIViewController : ASAuthorizationControllerDelegate {

    func isAppDevelopment() -> Bool {
        #if DEBUG
            return true
        #else
           return false
        #endif
    }

    
   
    
    
    func Dismiss(_ animation : Bool = true , _ complition : (()->Void)? = nil)  {
        self.dismiss(animated: animation, completion: complition)
    }
    func PushToWelcome()  {
        let vc = storyboard?.instantiateViewController(identifier: "InfoViewController") as! InfoViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    func PushToSelectOption()  {
        let vc = storyboard?.instantiateViewController(identifier: "SelectOptionViewController") as! SelectOptionViewController
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: false, completion: nil)
    }
    func PresentViewController(identifier : String)  {
        let vc = storyboard?.instantiateViewController(identifier: identifier)
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: false, completion: nil)
    }
    func buildFDLLink(RequestID : String , text : String , type : Int) {

        
        var Link : String = ""
        switch type {
        case 1:
            Link = "feed=\(RequestID)"
            break
        case 2:
            Link = "inviteBy=\(RequestID)"
            break
        case 3:
            Link = "travel=\(RequestID)"
            break
        default:
            break
        }
        
        

        guard let link = URL(string: "https://letsDetour.com?\(Link )") else { return }
        let dynamicLinksDomainURIPrefix = "https://letsdetour.page.link/XktS"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.orem.Letsdetour")
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.orem.Letsdetour")

        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink)")
//        ShareURL = "\(longDynamicLink)"
        ShareText(text: text, link: longDynamicLink)
 
   }
    
    func ShareText(text : String , link : URL)  {
               
             
            let objectsToShare = [text , link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
 
    func ShowDirection(lat : String , lng : String)  {
        let alert = UIAlertController.init(title: "Select Map", message: "", preferredStyle: .alert)
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!){
            let google = UIAlertAction.init(title: "Google Map", style: .default) { (action) in
                UIApplication.shared.open(URL(string:
                    "comgooglemaps://?center=\(lat),\(lng)&zoom=14&views=traffic")!)
            }
            alert.addAction(google)
        }
        let apple = UIAlertAction.init(title: "Apple Map", style: .default) { (action) in
            
            UIApplication.shared.open(URL(string:
                "http://maps.apple.com/?q=\(lat),\(lng)")!)
        }
        alert.addAction(apple)
        
        let Cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(Cancel)
        present(alert, animated: true, completion: nil)

        
    }
    
    func UpdateProfile() {
        let dict = [
            "device_token" : DataManager.device_token,
            "device_type" : "ios",
            
            
        ]
        APIClients.UpdateProfile(parems: dict as [String : Any] , imageKey: [] , image: [] , loader : false  , alert : false ,storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                DataManager.CurrentUserData = response.user
                Constants.CurrentUserData = response.user
                NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])
                
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
        }

    }
    
    func GetLocationFromPicker(vc : UIViewController, _ complition : ((String , String , String , String)->Void)? = nil)  {
        
    }
    
    func GooglePlaceImages(id : String, _ complition : ((GMSPlace)->Void)? = nil)   {
        

        let placesClient = GMSPlacesClient()
        
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))

        placesClient.fetchPlace(fromPlaceID: id,
                                 placeFields: fields,
                                 sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
            complition!(place!)
 
        })
        
    }
    func GooglePlaceImage(id : String, img : UIImageView)  {
        
//        DataModelCode().GetApidata(Url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(view.bounds.width)&photo_reference=\(id)&key=\(Config.googleMapKey)") { (data, error, status) in
//            if status == 200{
//                print(data)
//                img.image = UIImage(data: data as Data)
//            }
//        }
        let placesClient = GMSPlacesClient()
        
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))

        placesClient.fetchPlace(fromPlaceID: id,
                                 placeFields: fields,
                                 sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
          if let place = place {
            // Get the metadata for the first photo in the place photo metadata list.
            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]

            // Call loadPlacePhoto to display the bitmap and attribution.
            placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
              if let error = error {
                // TODO: Handle the error.
                print("Error loading photo metadata: \(error.localizedDescription)")
                return
              } else {
                // Display the first image and its attributions.
                img.image = photo;
              }
            })
          }
        })
        
    }
    func setUpSignInAppleButton(btn : UIView) {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.mask = .none
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.layer.cornerRadius = 27
        authorizationButton.frame = btn.frame
        authorizationButton.layer.masksToBounds = true
        btn.backgroundColor = .clear
        btn.addSubview(authorizationButton)
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email ]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self

        authorizationController.performRequests()
    }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
//        AppleLogin(source: appleIDCredential)
            var name: String = appleIDCredential.email ?? ""
            if let nameProvided = appleIDCredential.fullName {
                let firstName = nameProvided.givenName ?? ""
                let lastName = nameProvided.familyName ?? ""
                name = "\(firstName) \(lastName)"
            } else {
                name = ""
            }
            if name == " "{
                name = ""
            }
            self.SocalSignUp(social_id: userIdentifier, Name: name, email: email ?? "", login_type: "1", Image: "")
        
        }
    }
    
    
    func GoogleLogin(btn : UIButton)  {
        let signInConfig = GIDConfiguration.init(clientID: Config.googleClientID)

        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            self.SocalSignUp(social_id: "\(user?.userID ?? "")", Name: user?.profile?.name ?? "", email: user?.profile?.email ?? "", login_type: "1", Image: user?.profile?.imageURL(withDimension: 120)?.absoluteString ?? "" )

            // If sign in succeeded, display the app's main content View.
          }
    }
    func FaceBookLogin( ) {

        let loginManager = LoginManager()
            
            if let _ = AccessToken.current {
                // Access token available -- user already logged in
                // Perform log out
                
                // 2
                loginManager.logOut()
                
            } else {
                // Access token not available -- user already logged out
                // Perform log in
                
                // 3
                loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                    
                    // 4
                    // Check for error
                    guard error == nil else {
                        // Error occurred
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // 5
                    // Check for cancel
                    guard let result = result, !result.isCancelled else {
                        print("User cancelled login")
                        return
                    }
                  
                
                    Profile.loadCurrentProfile { (profile, error) in
                        
                        
                        if profile?.email == nil {
                            self?.SocalSignUp(social_id: "\(profile?.userID ?? "")", Name: profile?.name ?? "", email: "\(profile?.userID ?? "")".appending("@facebook.com"), login_type: "1", Image: profile?.imageURL?.absoluteString ?? "" )
                           
                        }
                        else{
                            self?.SocalSignUp(social_id: "\(profile?.userID ?? "")", Name: profile?.name ?? "", email: profile?.email ?? "", login_type: "1", Image: profile?.imageURL?.absoluteString ?? "" )
                        }
                    }
                }
            }
    }

    func SocalSignUp( social_id : String , Name : String , email: String , login_type : String , Image : String ) {
        let dict = ["social_id" :social_id,
                    "social_type" : login_type,
                    "email" : email,
                    "country_code" : "",
                    "phone" : "",
                    "user_name" : Name
                    
                    ]
        APIClients.POST_social_login(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""  )

                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    Constants.Toast.MyToast(message: response.message ?? ""  )
                    DataManager.Auth_Token = response.token
                    DataManager.CurrentUserData = response.user
                    Constants.CurrentUserData = response.user
                    print( DataManager.CurrentUserData!)
                    self.PresentViewController(identifier: "TabViewController")

                }
             
                
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }

    }
}
