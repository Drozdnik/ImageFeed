//
//  ProfileModels.swift
//  imageFeed
//
//  Created by Михаил  on 25.02.2024.
//

import Foundation

struct ProfileResult: Decodable{
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

struct Profile{
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = profileResult.firstName + " " + profileResult.lastName
        self.loginName = "@" + username
        self.bio = profileResult.bio ?? " "
    }
}
