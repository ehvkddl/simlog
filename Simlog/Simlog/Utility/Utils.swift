//
//  Utils.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/23.
//

import UIKit

class Utils {
    
    static func safeAreaTopInset() -> CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return 0 }
        let top = window.safeAreaInsets.top
        print(top)
        return top
    }
    
}
