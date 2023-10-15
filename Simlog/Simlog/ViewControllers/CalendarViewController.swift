//
//  ViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/25.
//

import UIKit

class CalendarViewController: BaseViewController {

    let addButton = {
        let btn = UIButton()
        
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.baseForegroundColor = Constants.BaseColor.reverseText
        config.baseBackgroundColor = Constants.BaseColor.accent
        btn.configuration = config
        
        btn.layer.cornerRadius = btn.frame.width * 0.5
        btn.clipsToBounds = true
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureView() {
        super.configureView()
        
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        [addButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.size.equalTo(50)
        }
    }
    
}

extension CalendarViewController {
    
    @objc private func addButtonClicked() {
        let vc = UINavigationController(rootViewController: AddDailyLogViewController())
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}
