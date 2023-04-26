//
//  Person.swift
//  Person-list
//
//  Created by Cora on 24/04/23.
//

import Foundation

struct Person: Decodable {
    let id: Int
    let name: String
    let phone: String?
}

struct Contact: Encodable {
    let name: String
    let phone: String?
}


