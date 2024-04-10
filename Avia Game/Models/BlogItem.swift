//
//  BlogItem.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import Foundation

struct BlogItem: Identifiable {
    var title: String
    var text: String
    var image: String
    var id: String = UUID().uuidString
}
