//
//  CurrentUser.swift
//  Snatchem
//
//  Created by Apple on 07/03/18.
//  Copyright © 2018 OREM TECH. All rights reserved.
//

import Foundation





// MARK: - CurrentUserData
struct M_CurrentUserData: Codable {
    let message: String?
    let user: User
    let token: String?
    let otp : Int?
}

// MARK: - User
struct User: Codable {

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


    





    

}


