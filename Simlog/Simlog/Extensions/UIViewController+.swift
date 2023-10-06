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
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
}

extension UIViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                  let keyboardRectangle = keyboardFrame.cgRectValue
                  let keyboardHeight = keyboardRectangle.height
              UIView.animate(withDuration: 1) {
                  self.view.window?.frame.origin.y -= keyboardHeight
              }
          }
      }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.view.window?.frame.origin.y += keyboardHeight
                }
            }
        }
    }
    
}
