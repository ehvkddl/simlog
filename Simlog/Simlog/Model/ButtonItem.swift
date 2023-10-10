//
//  ButtonItem.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/11.
//

import Foundation

struct ButtonItem: Hashable {
    let id = UUID().uuidString
    var type: WeatherType
    var imageName: String
    var label: String
    var isSelect: Bool
}
