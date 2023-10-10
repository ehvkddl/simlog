//
//  AddDiaryTestViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

enum CellType {
    case mood
    case weather
    case meal
    case sleep
    case todo
    case photo
    case diary
    
    var title: String {
        switch self {
        case .mood: return "기분"
        case .weather: return "날씨"
        case .meal: return "식사"
        case .sleep: return "수면"
        case .todo: return "할일"
        case .photo: return "사진"
        case .diary: return "일기"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .mood, .weather: return ""
        case .meal: return "식사 추가하기"
        case .sleep: return "수면시간 기록하기"
        case .todo: return "할 일 추가하기"
        case .photo: return "사진 추가하기"
        case .diary: return "일기 작성하기"
        }
    }
}

class AddDailyLogViewController: BaseViewController {
    
    let vm = DailyLogViewModel()
    
    let editComponent: [CellType] = [.mood, .sleep, .diary]
    
    lazy var tableView = {
        let view = UITableView()
        
        view.delegate = self
        view.dataSource = self
        
        view.register(AddDailyLogTableViewCell.self, forCellReuseIdentifier: AddDailyLogTableViewCell.description())
        view.register(AddMoodTableViewCell.self, forCellReuseIdentifier: AddMoodTableViewCell.description())
        view.register(AddWeatherTableViewCell.self, forCellReuseIdentifier: AddWeatherTableViewCell.description())
        
        view.rowHeight = UITableView.automaticDimension
        
        view.backgroundColor = Constants.BaseColor.grayBackground
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    let saveButton = {
        let btn = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "저장하기"
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.boldSystemFont(ofSize: 20)
            return outgoing
        }
        config.titleTextAttributesTransformer = transformer
        config.baseForegroundColor = Constants.BaseColor.reverseText
        config.baseBackgroundColor = Constants.BaseColor.accent
        btn.configuration = config
        btn.layer.cornerRadius = Constants.cornerRadius
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = Constants.BaseColor.grayBackground
        
        [tableView, saveButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(saveButton.snp.top).offset(-8)
        }
        
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }

}

extension AddDailyLogViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}

extension AddDailyLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editComponent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch editComponent[indexPath.row] {
        case .mood:
            guard let cell = makeCell(tableView, type: editComponent[indexPath.row], indexPath: indexPath) as? AddMoodTableViewCell else { return UITableViewCell() }
            return cell
            
        case .weather:
            return UITableViewCell()
            
        case .meal:
            guard let cell = makeCell(tableView, type: editComponent[indexPath.row], indexPath: indexPath) as? AddDailyLogTableViewCell else { return UITableViewCell() }
            cell.setContent(by: editComponent[indexPath.row])
            return cell
            
        case .sleep:
            guard let cell = makeCell(tableView, type: editComponent[indexPath.row], indexPath: indexPath) as? AddDailyLogTableViewCell else { return UITableViewCell() }
            cell.setContent(by: editComponent[indexPath.row])
            cell.addButtonClosure = {
                let vc = BedTimeViewController()
                vc.vm.sleep.value = self.vm.dailylog.value.sleep
                vc.saveButtonClosure = { bedTime, wakeupTime, text in
                    cell.addButton.setTitle(text, for: .normal)
                    self.vm.dailylog.value.sleep = Sleep(bedTime: bedTime, wakeupTime: wakeupTime)
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
            return cell
            
        case .todo:
            return UITableViewCell()
            
        case .photo:
            return UITableViewCell()
            
        case .diary:
            guard let cell = makeCell(tableView, type: editComponent[indexPath.row], indexPath: indexPath) as? AddDailyLogTableViewCell else { return UITableViewCell() }
            cell.setContent(by: editComponent[indexPath.row])
            cell.addButtonClosure = {
                let vc = DiaryViewController()
                vc.textView.text = self.vm.dailylog.value.diary
                vc.saveButtonClosure = { diary in
                    tableView.beginUpdates()
                    cell.addButton.setTitle(diary.isEmpty ? self.editComponent[indexPath.row].buttonTitle : diary, for: .normal)
                    self.vm.dailylog.value.diary = diary
                    tableView.endUpdates()
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension AddDailyLogViewController {
    
    func makeCell(_ tableView: UITableView, type: CellType, indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .mood:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddMoodTableViewCell.description()) as? AddMoodTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = Constants.BaseColor.grayBackground
            cell.cellType = editComponent[indexPath.row]
            cell.titleLabel.text = editComponent[indexPath.row].title
            return cell
        case .weather:
            return UITableViewCell()
        case .meal, .sleep, .todo, .photo, .diary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddDailyLogTableViewCell.description()) as? AddDailyLogTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = Constants.BaseColor.grayBackground
            cell.cellType = type
            cell.titleLabel.text = editComponent[indexPath.row].title
            cell.addButton.setTitle(editComponent[indexPath.row].buttonTitle, for: .normal)
            return cell
        }
    }
    
}
