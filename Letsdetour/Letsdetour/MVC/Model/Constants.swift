//
//  Constants.swift
//  FavBites
//
//  Created by jatin-pc on 8/30/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import UIKit

enum Config {
    static let screenSize = UIScreen.main.bounds
    static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let googleMapKey = "AIzaSyDM6e1w0fFfBoXTC994G86vsqxMECXKnx8"
    static let googleClientID = "223929033945-73b1uu43bc2oc6q9bs6rd92ildj2msme.apps.googleusercontent.com"

    
    //
}
class CommonInfoData {
    
    static let sharedInstance = CommonInfoData()
    private init(){}
}


struct SystemFont {
    static let FontFamilyName = "BarlowCondensed-Regular"
    static let FontFamilyNameBold = "BarlowCondensed-Bold"
    static let FontFamilyNameMedium = "BarlowCondensed-Medium"
    static let FontFamilyNameLight = "BarlowCondensed-Light"
}

enum UserType  {
    
    case Normal
    case Facebook
    case Google
    case Twiter
    case Apple

    
    func get() -> String{
        
        switch self {
            
        case .Normal : return "1"
        case .Facebook : return "2"
        case .Google : return "3"
        case .Twiter : return "4"
        case .Apple : return "5"

            
        }
    }
}

enum FilterSearchType  {
    
    case Restaurants
    case Accommodation
    case ATTractions
    case Nightlife

    
    func get() -> [String]{
        
        switch self {
            
        case .Restaurants : return ["restaurant","bakery","bar","cafe"]
        case .Accommodation : return ["restaurant"]
        case .ATTractions : return ["amusement_park","aquarium","art_gallery","casino","tourist_attraction","museum"]
        case .Nightlife : return ["night_club"]

            
        }
    }
}


enum DateFormat  {
    
    case yyyy_MM_dd
    case yyyy_MMM_dd
    case dd_MMM_yyyy
    case MMM_dd_yyyy
    case MMM_dd

    case hh_mm_a
    case HH_mm
    case hh_mm_ss_a
    case HH_mm_ss
    case yyyy_MM_dd_hh_mm_a
    case yyyy_MM_dd_hh_mm_a2
    case fullDataWithday
    
    func get() -> String{
        
        switch self {
            
        case .yyyy_MM_dd : return "yyyy-MM-dd"
        case .yyyy_MMM_dd : return "yyyy MMM dd"
        case .dd_MMM_yyyy : return "dd MMM yyyy"
        case .MMM_dd_yyyy : return "MMM dd yyyy"
        case .MMM_dd : return "MMM dd"

        case .hh_mm_a : return "hh:mm a"
        case .HH_mm : return "HH:mm"
        case .HH_mm_ss : return "HH:mm:ss"
        case .hh_mm_ss_a : return   "h:mm:ss a "
        case .yyyy_MM_dd_hh_mm_a : return "yyyy-MM-dd HH:mm:ss"
        case .yyyy_MM_dd_hh_mm_a2 : return "MMM dd yyyy, hh:mm a"
        case .fullDataWithday : return "E, d MMM yyyy, hh:mm a"
            
        }
    }
}


struct Constants {
    // Common Class
    static let Toast = AlertToast()

    static let timeFormat = TimeFormat()
    static let checkTextField = CheckTextField()
	static let userDefault = UserDefaults.standard
    static let Loader = ApiLoader()
    static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    // Common Font

   

    // Common Header


    // Common Time Format

    static let StrandredDateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
    static let StrandredDateFormatApi = "yyyy-MM-dd HH:mm:ss ZZZZZ"
	static var DeviceToken = DataManager.device_token
    static let DeviceType = "ios"
    static let AppName = "LetsDetour"
    static let AppLogo : UIImage  = #imageLiteral(resourceName: "logo_original")
    static let AppColor : UIColor  = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)

    static let UserType = "1"
    static let CurrentLanguage = "1"
    static let ApiTimeOutTime = 3000
    static let TimeIntervalForSlot = 30 * 60
    

    static var ApiToken : String  = UserDefaults.standard.value(forKey: "LoginToken") as! String
    static var CurrentUserLat = ""
    static var CurrentUserLng = ""
    static var CurrentUserData : User!
    

    
    struct LoginType {
        static let   Google : String = "2"
        static let   Facebook : String = "2"
        static let   SignUp : String = "1"
    }
    
    struct OrderStatus {
    
        static let Created =  "0"
        static let Accepted_Provider =  "1"
        static let Rejected_Provider =  "2"
        static let ontheway =  "3"
        static let complete =  "4"
        static let Cancel_customer =  "6"
        static let Cancel_Provider =  "5"

     
    }
    struct NotificationStatus {
        static let   Request : String = "1"
        static let   Estimate : String = "2"
        static let   Simple : String = "0"
    }
    
    struct VIEW_IDENTIFIER {
        // Common View Controller
        static let InfoViewController = "InfoViewController"
        static let LoginViewController = "LoginViewController"
        static let SignUpViewController = "RegisterViewController"
        static let ForgotPasswordViewController = "ForgotPasswordViewController"
        static let TermsAndConditionsViewController = "TermsAndConditionsViewController"
        static let SettingViewController = "SettingViewController"
        static let HomeViewController = "HomeViewController"
        static let ChangePasswordViewController = "ChangePasswordViewController"
        static let ContactUsViewController = "ContactUsViewController"
        static let ProfileViewController = "ProfileViewController"
        static let HomeNavigationViewController = "HomeNavigationViewController"
        static let OTPViewController = "OtpViewController"
        static let TabViewController = "TabViewController"
        static let ReviewViewController = "ReviewViewController"
        // Custom View Controller
        

    }
    
    
    enum Language : String {
        case English = "1"
        case Arabic = "2"
    }

    struct API {
        static var Server_URL = "https://dev.appmantechnologies.com"
//        static var Server_URL = "https://stopdiggingapp.co.nz"
        static var BASE_URL = Server_URL + "/letsdetour/api/"
        static var IMAGE_BASE_URL = Server_URL + "/public/storage/"
        static let POST_Common : String = BASE_URL + "common"
        static let POST_country_list : String = BASE_URL + "country_list"
        static let POST_state_list : String = BASE_URL + "state_list"

        static let POST_RegisterUser : String = BASE_URL + "register"
        static let POST_update_profile : String = BASE_URL + "user/update_profile"
        static let POST_createFeed : String = BASE_URL + "user/createFeed"

        static let POST_Login : String = BASE_URL + "login"
        static let POST_social_login : String = BASE_URL + "social_login"

        static let POST_otp_verify : String = BASE_URL + "verifyOtp"
        static let POST_resend_otp : String = BASE_URL + "resend_otp"

        static let POST_home : String = BASE_URL + "user/home"
        
        static let POST_place_list : String = BASE_URL + "user/place_list"
        static let POST_GiveRating : String = BASE_URL + "user/giveRating"
        static let POST_PlaceDetail : String = BASE_URL + "user/placeDetail"

        
        static let POST_Logout : String = BASE_URL + "user/logout"
        static let POST_ForgotPassword : String = BASE_URL + "forgot_password"
        static let POST_ChangePassword : String = BASE_URL + "user/change_password"
        static let POST_Homedata : String = BASE_URL + "user/homedata"
        static let GET_PlanList : String = BASE_URL + "user/planList"
        static let GET_planDetail : String = BASE_URL + "user/planDetail"

        static let POST_user_addLike : String = BASE_URL + "user/addLike"
        static let POST_user_addFollow : String = BASE_URL + "user/addFollow"
        static let POST_user_addComment : String = BASE_URL + "user/addComment"
        static let POST_user_feedDetail : String = BASE_URL + "user/feedDetail"
        static let POST_user_notification_list : String = BASE_URL + "user/notification_list"

        static let POST_user_addFollowPlace : String = BASE_URL + "user/addFollowPlace"
        static let POST_user_contactAdmin : String = BASE_URL + "user/contactAdmin"
        static let POST_user_createPlan : String = BASE_URL + "user/createPlan"
        static let POST_user_deletePlan : String = BASE_URL + "user/deleteplan"
        static let POST_user_updatePlan : String = BASE_URL + "user/updatePlan"
        static let POST_user_addRoute : String = BASE_URL + "user/addRoute"
        
        static let POST_user_deleteRoute : String = BASE_URL + "user/deleteRoute"
        static let POST_user_deletePlanImage : String = BASE_URL + "user/deletePlanImage"
        static let POST_user_follower_list : String = BASE_URL + "user/follower_list"
        static let POST_user_addPlanFollower : String = BASE_URL + "user/addPlanFollower"
        static let POST_user_otheruserDetail : String = BASE_URL + "user/otheruserDetail"
        static let POST_user_receiveFollowRequest : String = BASE_URL + "user/receiveFollowRequest"

        static let POST_pages : String = BASE_URL + "pages"

        static let GET_Place_api =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json"


        static let GET_LocationAddressApi =  "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?"
    }
    enum OrderStatus_Code : String {
 
        
        case Created = "Created"
        case Verify = "Waiting For Conformation"
        case Accept = "In Kitchen"
        case Process = "In Process"
        case Ready = "Ready To Deliver"
        case Delivered = "Delivered"
        case Complete = "Complete"
        case Pending = "Payment Pending"
        case Cancel_by_customer = "Cancel by customer"
        case Cancel_By_Waiter = "Cancel By Waiter"
        case Cancel_By_Chef = "Cancel By Chef"
        func day() ->String {
            
            
            return self.rawValue
            
        }
        
        }
    

    static var countryDictionary  = ["AF":"93","AL":"355","DZ":"213","AS":"1","AD":"376","AO":"244",
                                     "AI":"1",
                                     "AG":"1",
                                     "AR":"54",
                                     "AM":"374",
                                     "AW":"297",
                                     "AU":"61",
                                     "AT":"43",
                                     "AZ":"994",
                                     "BS":"1",
                                     "BH":"973",
                                     "BD":"880",
                                     "BB":"1",
                                     "BY":"375",
                                     "BE":"32",
                                     "BZ":"501",
                                     "BJ":"229",
                                     "BM":"1",
                                     "BT":"975",
                                     "BA":"387",
                                     "BW":"267",
                                     "BR":"55",
                                     "IO":"246",
                                     "BG":"359",
                                     "BF":"226",
                                     "BI":"257",
                                     "KH":"855",
                                     "CM":"237",
                                     "CA":"1",
                                     "CV":"238",
                                     "KY":"345",
                                     "CF":"236",
                                     "TD":"235",
                                     "CL":"56",
                                     "CN":"86",
                                     "CX":"61",
                                     "CO":"57",
                                     "KM":"269",
                                     "CG":"242",
                                     "CK":"682",
                                     "CR":"506",
                                     "HR":"385",
                                     "CU":"53",
                                     "CY":"537",
                                     "CZ":"420",
                                     "DK":"45",
                                     "DJ":"253",
                                     "DM":"1",
                                     "DO":"1",
                                     "EC":"593",
                                     "EG":"20",
                                     "SV":"503",
                                     "GQ":"240",
                                     "ER":"291",
                                     "EE":"372",
                                     "ET":"251",
                                     "FO":"298",
                                     "FJ":"679",
                                     "FI":"358",
                                     "FR":"33",
                                     "GF":"594",
                                     "PF":"689",
                                     "GA":"241",
                                     "GM":"220",
                                     "GE":"995",
                                     "DE":"49",
                                     "GH":"233",
                                     "GI":"350",
                                     "GR":"30",
                                     "GL":"299",
                                     "GD":"1",
                                     "GP":"590",
                                     "GU":"1",
                                     "GT":"502",
                                     "GN":"224",
                                     "GW":"245",
                                     "GY":"595",
                                     "HT":"509",
                                     "HN":"504",
                                     "HU":"36",
                                     "IS":"354",
                                     "IN":"91",
                                     "ID":"62",
                                     "IQ":"964",
                                     "IE":"353",
                                     "IL":"972",
                                     "IT":"39",
                                     "JM":"1",
                                     "JP":"81",
                                     "JO":"962",
                                     "KZ":"77",
                                     "KE":"254",
                                     "KI":"686",
                                     "KW":"965",
                                     "KG":"996",
                                     "LV":"371",
                                     "LB":"961",
                                     "LS":"266",
                                     "LR":"231",
                                     "LI":"423",
                                     "LT":"370",
                                     "LU":"352",
                                     "MG":"261",
                                     "MW":"265",
                                     "MY":"60",
                                     "MV":"960",
                                     "ML":"223",
                                     "MT":"356",
                                     "MH":"692",
                                     "MQ":"596",
                                     "MR":"222",
                                     "MU":"230",
                                     "YT":"262",
                                     "MX":"52",
                                     "MC":"377",
                                     "MN":"976",
                                     "ME":"382",
                                     "MS":"1",
                                     "MA":"212",
                                     "MM":"95",
                                     "NA":"264",
                                     "NR":"674",
                                     "NP":"977",
                                     "NL":"31",
                                     "AN":"599",
                                     "NC":"687",
                                     "NZ":"64",
                                     "NI":"505",
                                     "NE":"227",
                                     "NG":"234",
                                     "NU":"683",
                                     "NF":"672",
                                     "MP":"1",
                                     "NO":"47",
                                     "OM":"968",
                                     "PK":"92",
                                     "PW":"680",
                                     "PA":"507",
                                     "PG":"675",
                                     "PY":"595",
                                     "PE":"51",
                                     "PH":"63",
                                     "PL":"48",
                                     "PT":"351",
                                     "PR":"1",
                                     "QA":"974",
                                     "RO":"40",
                                     "RW":"250",
                                     "WS":"685",
                                     "SM":"378",
                                     "SA":"966",
                                     "SN":"221",
                                     "RS":"381",
                                     "SC":"248",
                                     "SL":"232",
                                     "SG":"65",
                                     "SK":"421",
                                     "SI":"386",
                                     "SB":"677",
                                     "ZA":"27",
                                     "GS":"500",
                                     "ES":"34",
                                     "LK":"94",
                                     "SD":"249",
                                     "SR":"597",
                                     "SZ":"268",
                                     "SE":"46",
                                     "CH":"41",
                                     "TJ":"992",
                                     "TH":"66",
                                     "TG":"228",
                                     "TK":"690",
                                     "TO":"676",
                                     "TT":"1",
                                     "TN":"216",
                                     "TR":"90",
                                     "TM":"993",
                                     "TC":"1",
                                     "TV":"688",
                                     "UG":"256",
                                     "UA":"380",
                                     "AE":"971",
                                     "GB":"44",
                                     "US":"1",
                                     "UY":"598",
                                     "UZ":"998",
                                     "VU":"678",
                                     "WF":"681",
                                     "YE":"967",
                                     "ZM":"260",
                                     "ZW":"263",
                                     "BO":"591",
                                     "BN":"673",
                                     "CC":"61",
                                     "CD":"243",
                                     "CI":"225",
                                     "FK":"500",
                                     "GG":"44",
                                     "VA":"379",
                                     "HK":"852",
                                     "IR":"98",
                                     "IM":"44",
                                     "JE":"44",
                                     "KP":"850",
                                     "KR":"82",
                                     "LA":"856",
                                     "LY":"218",
                                     "MO":"853",
                                     "MK":"389",
                                     "FM":"691",
                                     "MD":"373",
                                     "MZ":"258",
                                     "PS":"970",
                                     "PN":"872",
                                     "RE":"262",
                                     "RU":"7",
                                     "BL":"590",
                                     "SH":"290",
                                     "KN":"1",
                                     "LC":"1",
                                     "MF":"590",
                                     "PM":"508",
                                     "VC":"1",
                                     "ST":"239",
                                     "SO":"252",
                                     "SJ":"47",
                                     "SY":"963",
                                     "TW":"886",
                                     "TZ":"255",
                                     "TL":"670",
                                     "VE":"58",
                                     "VN":"84",
                                     "VG":"284",
                                     "VI":"340"]  as NSDictionary
    
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    var hasNotch: Bool {
          let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
          return bottom > 0
      }
}
