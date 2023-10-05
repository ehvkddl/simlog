//
//  AddDiaryTestViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class AddDiaryTestViewController: BaseViewController {

    lazy var tableView = {
        let view = UITableView()
        
        view.delegate = self
        view.dataSource = self
        
        view.register(AddDiaryTestTableViewCell.self, forCellReuseIdentifier: "AddDiaryTestTableViewCell")
        
        view.rowHeight = UITableView.automaticDimension
        
        view.backgroundColor = Constants.BaseColor.grayBackground
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = Constants.BaseColor.grayBackground
        
        [tableView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }

}

extension AddDiaryTestViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}

extension AddDiaryTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryTestTableViewCell") as? AddDiaryTestTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = Constants.BaseColor.grayBackground
        cell.titleLabel.text = "title"
        cell.addButtonClosure = {
            let vc = BedTimeViewController()
            vc.vm.sleep.value = nil
            vc.saveButtonClosure = { bedTime, wakeupTime, sleepTime in
                print(bedTime, wakeupTime, sleepTime)
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
