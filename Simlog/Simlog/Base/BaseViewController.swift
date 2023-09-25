//
//  BaseViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/26.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = Constants.BaseColor.background
    }
    
    func setConstraints() {}
    
}
