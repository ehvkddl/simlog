//
//  AddDiaryTestViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit
import PhotosUI
import Loaf

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
    
    var saveButtonClickedClosure: (() -> Void)?
    
    let editComponent: [CellType] = [.mood, .weather, .sleep, .photo, .diary]
    
    lazy var phpicker = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
    lazy var tableView = {
        let view = UITableView()
        
        view.delegate = self
        view.dataSource = self
        
        view.register(cellType: AddDailyLogTableViewCell.self)
        view.register(cellType: AddMoodTableViewCell.self)
        view.register(cellType: AddWeatherTableViewCell.self)
        view.register(cellType: AddPhotoTableViewCell.self)
        
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
        
        title = DateFormatterManager.shared.formatter(for: .monthDayWeek, locale: "ko_KR").string(from: vm.dailylog.value.date)
    }
    
    override func configureView() {
        view.backgroundColor = Constants.BaseColor.grayBackground
        
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        
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
        showAlert(
            title: "일기 작성을 종료하시겠어요?",
            message: "아직 내용이 저장되지 않았어요!") {
                self.dismiss(animated: true)
            }
    }
    
    @objc private func saveButtonClicked() {
        do {
            try vm.saveDailyLog()
            saveButtonClickedClosure?()
            dismiss(animated: true)
        } catch {
            Loaf(error.localizedDescription, state: .error, location: .top, sender: self).show()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
}

extension AddDailyLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editComponent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editType = editComponent[indexPath.row]
        
        switch editType {
        case .mood:
            let cell = tableView.dequeueReusableCell(withClass: AddMoodTableViewCell.self, for: indexPath)
            cell.apply(type: editType, title: editType.title)
            cell.sliderValueChangedClosure = { value in
                self.vm.dailylog.value.mood = value
            }
            
            if let mood = vm.dailylog.value.mood {
                cell.slider.value = Float(mood)
                cell.slider.setLabelTextColor()
            }
            
            return cell
            
        case .weather:
            let cell = tableView.dequeueReusableCell(withClass: AddWeatherTableViewCell.self, for: indexPath)
            cell.apply(type: editType, title: editType.title)
            cell.cellButtonClickedClosure = { weathers in
                self.vm.dailylog.value.weather = weathers
            }
            
            if let weather = vm.dailylog.value.weather {
                weather.forEach {
                    cell.buttons[$0.rawValue].isSelect = true
                }
                
                cell.vm.weather.value = Set(weather)
            }
            
            return cell
            
        case .meal:
            let cell = tableView.dequeueReusableCell(withClass: AddDailyLogTableViewCell.self, for: indexPath)
            cell.apply(type: editType, title: editType.title, buttonTitle: editType.buttonTitle)
            return cell
            
        case .sleep:
            let cell = tableView.dequeueReusableCell(withClass: AddDailyLogTableViewCell.self, for: indexPath)
            cell.apply(type: editType, title: editType.title, buttonTitle: editType.buttonTitle)
            cell.addButtonClosure = {
                let vc = BedTimeViewController()
                vc.vm.sleep.value = self.vm.dailylog.value.sleep
                vc.saveButtonClosure = { sleep, text in
                    cell.addButton.setTitle(text, for: .normal)
                    self.vm.dailylog.value.sleep = sleep
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
            
            if let sleep = vm.dailylog.value.sleep {
                let bedTime = Date(timeIntervalSinceReferenceDate: sleep.bedTime)
                let bedTimeStr = DateFormatterManager.shared.formatter(for: .timeWithMeridiem, timeZone: "UTC").string(from: bedTime)
                
                let wakeTime = Date(timeIntervalSinceReferenceDate: sleep.wakeupTime)
                let wakeTimeStr = DateFormatterManager.shared.formatter(for: .timeWithMeridiem, timeZone: "UTC").string(from: wakeTime)
                
                let duration = Date(timeIntervalSinceReferenceDate: sleep.sleepTime)
                let durationStr = DateFormatterManager.shared.formatter(for: .timeWithLanguage, timeZone: "UTC").string(from: duration)
                
                let text = "\(bedTimeStr) ~ \(wakeTimeStr)"
                
                cell.addButton.setTitle(text, for: .normal)
            }
            
            return cell
            
        case .todo:
            return UITableViewCell()
            
        case .photo:
            let cell = tableView.dequeueReusableCell(withClass: AddPhotoTableViewCell.self, for: indexPath)
            cell.apply(type: editType, title: editType.title)
            cell.photoButtonClosure = {
                self.present(self.phpicker, animated: true)
            }
            
            if let photos = vm.dailylog.value.photo, let photo = photos.first {
                let date = DateFormatterManager.shared.formatter(for: .year).string(from: vm.dailylog.value.date)
                let image = PhotoManager.shared.loadImageFromDocument(date: date, fileName: photo.fileName)
                cell.photoButton.setImage(image, for: .normal)
            }
            
            return cell
            
        case .diary:
            let cell = tableView.dequeueReusableCell(withClass: AddDailyLogTableViewCell.self, for: indexPath)
            cell.apply(type: editType, title: editType.title, buttonTitle: editType.buttonTitle)
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
            
            if let diary = vm.dailylog.value.diary {
                cell.addButton.setTitle(diary, for: .normal)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AddDailyLogViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let image = object as? UIImage {
                NotificationCenter.default.post(name: NSNotification.Name("sendPhoto"),
                                                object: image)
                
                guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                self.vm.dailylog.value.photo = [Photo(image: data, fileName: UUID().uuidString)]
            }
            
        }
        
        picker.dismiss(animated: true)
    }
    
}
