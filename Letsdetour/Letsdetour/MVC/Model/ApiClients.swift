//
//  ApiClients.swift
//  PinBy
//
//  Created by Jaypreet on 30/12/19.
//  Copyright © 2019 Jaipreet. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import Alamofire


class APIClients : NSObject {


    func getIPAddress() -> String {
        
    
        
        var address: String = ""
//        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr?.pointee.ifa_next }
//                
//                let interface = ptr?.pointee
//                let addrFamily = interface?.ifa_addr.pointee.sa_family
//                if  addrFamily == UInt8(AF_INET6) {
//                    
//                      if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
//                        address = String(cString: hostname)
//                        print(address)
//                     }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
         return address
    }
    func getHeader() -> HTTPHeaders {

        let headers: HTTPHeaders = ["Accept": "application/json",
                      "Authorization" : "Bearer " + DataManager.Auth_Token!,
                      "lang" : DataManager.CurrentAppLanguage!,
        ]
        print(headers)
        return headers
    }
    
    //MARK:  loginWithEmail
    static func RegisterAndUpdateProfile(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_RegisterUser ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    
    static func POST_user_createPlan(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_createPlan ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }

    static func POST_user_addRoute(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_addRoute, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    static func POST_user_updatePlan(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_updatePlan, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    static func POST_user_deletePlan(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_deletePlan ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_deleteRoute(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_deleteRoute ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_deletePlanImage(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_deletePlanImage ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_follower_list(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Follower>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_follower_list ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_addPlanFollower(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_addPlanFollower ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    //MARK:  loginWithEmail
    static func RegisterProfile(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_RegisterUser, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    static func CreatePost(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],
        loader : Bool = true,
        alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_createFeed, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey, loader : loader,alert : alert,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }

    static func UpdateProfile(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],
        loader : Bool = true,
        alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_update_profile, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey, loader : loader,alert : alert,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    //MARK:  loginWithEmail
    static func loginWithEmail(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_CurrentUserData>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_Login ,  method: .post , params : parems as! [String : String], headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_otheruserDetail(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_User>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_otheruserDetail ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_social_login(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_CurrentUserData>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_social_login ,  method: .post , params : parems as! [String : String], headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  POST_country_list
    static func GET_country_list(
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Country>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_country_list ,  method: .get , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  GET_City_list
    static func GET_state_list(
        parems: [String : Any],

        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_State>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_state_list ,  method: .post , params : parems, headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_place_list(
        parems: [String : Any],

        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Place>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_place_list ,  method: .post , params : parems, headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_pages(
        parems: [String : Any],

        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Page>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_pages ,  method: .post , params : parems, headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_GiveRating(
        parems: [String : Any],

        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_GiveRating ,  method: .post , params : parems, headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    
    
    static func POST_PlaceDetail(
        parems: [String : Any],

        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Place_Detail>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_PlaceDetail ,  method: .post , params : parems, headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  loginWithEmail
//    static func Home(
//        parems: [String : Any],
//        storyBoard : UIStoryboard,
//        navigation : UIViewController,
//        successResponse: @escaping (Result<M_Home>)->Void,
//        failure: @escaping (Result<String>) -> Void
//        ) {
//       
//        DataModelCode().GetApi(Url: Constants.API.POST_home ,  method: .get , params : parems as! [String : String], headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
//      
//    }
    //MARK:  loginWithEmail
    static func SendOTP(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_OTP>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_Login ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  loginWithEmail
    static func SendLoginOTP(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_CurrentUserData>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_Login ,  method: .post , params : parems as! [String : String], headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  loginWithEmail
    static func VerifyOTP(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_CurrentUserData>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_otp_verify ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func resendOTP(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_OTP>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_resend_otp ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  loginWithEmail
    static func ForgotPassword(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_ForgotPassword ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }

    

    static func ChangePassword(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_ChangePassword ,  method: .post , params : parems as! [String : String], headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    //MARK:  loginWithEmail
    static func POST_Homedata(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Home>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_Homedata ,  method: .get , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func GET_PlanList(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Plan>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.GET_PlanList ,  method: .get , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func GET_planDetail(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Plan_Detail>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.GET_planDetail ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_addLike(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_addLike ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_feedDetail(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Feed>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_feedDetail ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_addFollowPlace(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_addFollowPlace ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_receiveFollowRequest(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_receiveFollowRequest ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_contactAdmin(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_contactAdmin ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_addComment(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_addComment ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_notification_list(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Notofiaction>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_notification_list ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    static func POST_user_addFollow(
        parems: [String : Any],
        storyBoard : UIStoryboard,
        navigation : UIViewController,
        successResponse: @escaping (Result<M_Message>)->Void,
        failure: @escaping (Result<String>) -> Void
        ) {
       
        DataModelCode().GetApi(Url: Constants.API.POST_user_addFollow ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
      
    }
    

}
