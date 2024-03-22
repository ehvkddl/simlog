//
//  UITableView+.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/12.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: T.description())
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.description(), for: indexPath) as? T else {
            return T()
        }
        
        return cell
    }
    
}
