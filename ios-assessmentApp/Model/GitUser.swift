//
//  GitUser.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import Foundation

struct GitUser: Codable {
    let avatar_url: String?
    let login: String
    let name: String?
    let description: String?
    let followers: Int?
    let following: Int?
}
