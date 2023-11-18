//
//  ViewController+.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/04.
//

import UIKit

extension UIViewController {
    
    var screenWidth: CGFloat {
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return 0 }
            
            return window.screen.bounds.width
        } else {
            return UIScreen.main.bounds.width
        }
    }
    
    var screenHeight: CGFloat {
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return 0 }
            
            return window.screen.bounds.height
        } else {
            return UIScreen.main.bounds.height
        }
    }
    
    func showAlert(
        title: String,
        message: String,
        okHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "아니요", style: .cancel)
        let ok = UIAlertAction(title: "네", style: .destructive) { _ in
            okHandler?()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}
