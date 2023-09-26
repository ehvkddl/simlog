//
//  AddDiaryViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/26.
//

import UIKit

class AddDiaryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }
    
}

extension AddDiaryViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}
