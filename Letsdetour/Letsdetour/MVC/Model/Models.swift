//
//  Models.swift
//  GoRINSE
//
//  Created by Jaypreet on 24/08/18.
//  Copyright © 2018 Jaypreet. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces



// MARK: - Success Message
struct M_Message: Codable {
    let message: String
}
// MARK: - Other


// MARK: - MTopicDetail
struct M_Terms: Codable {
    let data: M_record


}
// MARK: - MTopicDetail
struct M_record: Codable {
    let content , title: String


}
struct M_Country: Codable {
//    let message : String
    let data : [M_Country_data]

}
struct M_Country_data: Codable {
    let name  , sortname: String
    let id , phonecode : Int
}
struct M_State: Codable {
//    let message : String
    let data : [M_State_data]

}
struct M_State_data: Codable {
    let name : String
    let id  : Int
    let country_id : Int
}
struct M_OTP: Codable {
    let data : M_OTP_data
    let message : String

}
struct M_OTP_data: Codable {
    let otp : Int
}
struct M_Place: Codable {
    let data : [M_Place_data]
      let message : String

}
struct M_Place_data: Codable {
    let id : Int
    let distance : Double
    let image : String
    let lat : String?
    let lng : String?
    let location : String?
    let name : String?
    let type : Int
    let avg_rating : String

    
    
}

struct M_Place_Detail: Codable {
    let data : M_Place_Detail_data
      let message : String

}
struct M_Place_Detail_data: Codable {
    let id : Int
    let distance : Double
    let image : String
    let lat : String?
    let lng : String?
    let location : String?
    let name : String?
    let type  : Int
    let avg_rating , follow_status : String

    let ratings : [M_Place_Rate]
    
    
    
}
struct M_Place_Rate: Codable {
    let comment  ,created_at , user_image , user_name: String
    let id , place_id  , user_id : Int
    let rating : String
    
}
struct M_Page: Codable {
    let data : M_Page_data
      let message : String

}
struct M_Page_data: Codable {
    let content  , title: String
  
    
}
struct M_Home: Codable {
    let data : M_Home_data
      let message : String

}
struct M_Home_data: Codable {
    let feeds  : [M_Feed_Data]
    let places : [M_Place_data]
  
    
}
struct M_Feed_Data: Codable {
//    let new : Int
    let address  ,created_at , detail  , image , lat , lng  , user_image , user_name : String
    let id   , user_id   , like_status , unlike_status  : Int
    let total_likes : String
    let total_unlikes : String
    let total_comments : String
    let follow_status : String
    let comments : [M_Feed_Comment]

}
struct M_Feed_Comment: Codable {
    let comment  , created_at,  user_name , user_image: String
    let id , feed_id , user_id : Int
    
}
struct M_Feed: Codable {
    let data : M_Feed_Data
    let message : String
}

struct M_Plan: Codable {
    let data : [M_Plan_data]
    let message : String
}
struct M_Plan_data: Codable {
    let address : String
    let updated_at : String
    let end_date : String
    let start_date : String
    let lat : String
    let lng : String
    let id : Int
    let user_id : Int
    let permission : Int
    let images : [M_Plan_Detail_data_Images]

}


struct M_Plan_Detail: Codable {
    let data : M_Plan_Detail_data
    let message : String
//    let new : Int
}

struct M_Plan_Detail_data: Codable {
    let address : String
    let updated_at : String
    let end_date : String
    let start_date : String
    let lat : String
    let lng : String
    let id : Int
    let user_id : Int
    let permission : Int
    let images : [M_Plan_Detail_data_Images]
    let dates : [M_Plan_Detail_data_dates]
    let followers : [M_Follower_Data]
}

struct M_Plan_Detail_data_Images: Codable {
    let image : String
    let id : Int
}
struct M_Plan_Detail_data_dates: Codable {
    let plan_date : String
    let plan_id : Int
    let id : Int
    let routes : [M_Plan_Detail_data_dates_routes]
}
struct M_Plan_Detail_data_dates_routes: Codable {
    let address : String
    let created_at : String
    let image : String
    let lat : String
    let lng : String
    let name : String
    let route_time : String
    let updated_at : String

    let date_id : Int
    let id : Int
    let user_id : Int

}
struct M_Google_Nearby {
    var business_status : String
    var icon : String
    var icon_background_color : String
    var name : String
    var place_id : String
    var reference : String
    var vicinity : String
    var user_ratings_total : Int
    var rating : Double
    var photo_reference = [String]()
    var lat : Double
    var lng : Double
    var reviews = [M_Google_review]()
//    var image : UIImage!
    var types  : NSMutableArray = []
    var Distance : Double = 0.0
    init(dict : [String : Any]) {
        
        
        business_status = ""
        if dict["business_status"] is String{
            business_status = dict["business_status"] as! String
        }
        icon = ""

        if dict["icon"] is String{
            icon = dict["icon"] as! String
        }
        icon_background_color = ""

        if dict["icon_background_color"] is String{

            icon_background_color = dict["icon_background_color"] as! String
        }
        name = ""

        if dict["name"] is String{
            name = dict["name"] as! String
        }
        place_id = ""

        if dict["place_id"] is String{
            place_id = dict["place_id"] as! String
        }
        reference = ""

        if dict["reference"] is String{
            reference = dict["reference"] as! String
        }
        vicinity = ""

        if dict["vicinity"] is String{
            vicinity = dict["vicinity"] as! String
        }
        user_ratings_total = 0

        if dict["user_ratings_total"] is Int{
            user_ratings_total = dict["user_ratings_total"] as! Int
        }
        rating = 0.0

        if dict["rating"] is Double{
            rating = dict["rating"] as! Double
        }
        if ((dict["photos"] as? [[String : Any]]) != nil){
            let photo = dict["photos"] as! [[String : Any]]
            for i in photo{
                photo_reference.append(i["photo_reference"] as! String)
            }
        }
        types = NSMutableArray.init(array: dict["types"] as! NSArray)
        let geometry = dict["geometry"] as! [String : Any]
        let location = geometry["location"] as! [String : Any]
        lat = location["lat"] as! Double
        lng = location["lng"] as! Double
        
        Distance = CLLocation.init(latitude: lat, longitude: lng).distance(from: CLLocation.init(latitude: Double(Current_lat) ?? lat, longitude: Double(Current_lng) ?? lng))
        
        
        if (dict["reviews"] != nil){
            for i in dict["reviews"] as! [[String : Any]]{
                reviews.append(M_Google_review.init(dict: i))
            }
        }
//        self.GooglePlaceImage(id: place_id) { (strimg) in
//            image = strimg
//
//        }
        
        
        
    }

    func GooglePlaceImage(id : String, _ complition : @escaping (UIImage)->Void)  {
        

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
            if place.photos == nil{
                return
            }
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
                complition(photo!)
              }
            })
          }
        })
        
    }
}


struct M_Google_review {
    let author_name : String
      let profile_photo_url : String
    let relative_time_description : String
    let text : String

    let rating : Double
    init(dict : [String : Any]) {
        author_name = dict["author_name"] as! String
        profile_photo_url = dict["profile_photo_url"] as! String
        relative_time_description = dict["relative_time_description"] as! String
        text = dict["text"] as! String
        rating = dict["rating"] as! Double

    }
}



struct M_Follower: Codable {
    let data : [M_Follower_Data]
}
struct M_Follower_Data: Codable {
    let user_name : String
    let user_image : String
    let follower_id : Int
    let id : Int
    let user_id : Int

}
struct M_User: Codable {
    let message: String?
    let user: M_User_Data

}

// MARK: - User
struct M_User_Data: Codable {
//    let new : Int
    let availability : Int
    let bio : String?
    let city : String?
    let country : String?
    let country_code  : Int
    let cover_image : String?
    let current_lat : String?
    let current_lng : String?
    let email : String?
    let id  : Int
    let image : String?
    let location : String?
    let notification  : Int
    let online  : Int
    let phone : String?
    let privacy  : Int
    let status  : Int
    let user_name : String?
    let verify  : Int
    let user_type  : Int
    let follow_status : String
    let feeds  : [M_Feed_Data]
    let followers  : [M_Follower_Data]
    let followings  : [M_Follower_Data]
}
struct M_Notofiaction: Codable {
    let message: String?
    let data: [M_Notofiaction_Data]
}
struct M_Notofiaction_Data: Codable {
//    let new : Int
    let description: String
    let title: String
    let user_name: String?
    let user_image: String?

    let id: Int
    let request_status: Int
    let sender_id: Int
    let status: Int
    let type: Int
    let user_id: Int
    let status_id : Int?

}
struct M_Plan_ID {
    let place_id : String
    init(dict : [String : Any]) {
        place_id = dict["place_id"] as! String
    }
}
