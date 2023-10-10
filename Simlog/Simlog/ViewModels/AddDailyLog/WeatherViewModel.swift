//
//  WeatherViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/11.
//

import Foundation

class WeatherViewModel {
    
    var weather: Observable<Set<WeatherType>> = Observable([])
    
    func buttonClicked(type: WeatherType, isSelect: Bool) {
        if isSelect {
            weather.value.insert(type)
        } else {
            weather.value.remove(type)
        }
    }
    
}
