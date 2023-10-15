//
//  BaseViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/26.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        configureNavigationBar()
    }
    
    func configureView() {
        view.backgroundColor = Constants.BaseColor.background
    }
    
    func setConstraints() {}
    
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.BaseColor.accent
    }
    
}
