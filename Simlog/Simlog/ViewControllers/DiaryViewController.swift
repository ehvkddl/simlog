//
//  DiaryViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class DiaryViewController: BaseViewController {
    
    var saveButtonClosure: (() -> Void)?

    lazy var backgroundView = {
        let view = UIImageView()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
        return view
    }()
    
    let contentsView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.containerBackground
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    let closeButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark")
        config.baseForegroundColor = Constants.BaseColor.accent
        btn.configuration = config
        return btn
    }()
    
    let textView = {
        let view = UITextView()
        view.text = "일기 작성"
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    let saveButton = {
        let btn = UIButton()
        
        var config = UIButton.Configuration.filled() // apple system button
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    override func configureView() {
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        tapGestureRecognizer.addTarget(self, action: #selector(didTapView))
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        
        view.addGestureRecognizer(tapGestureRecognizer)
        [backgroundView, contentsView].forEach { view.addSubview($0) }
        [closeButton, textView, saveButton].forEach { contentsView.addSubview($0) }
    }
    
    override func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentsView).inset(10)
            make.size.equalTo(30)
        }
        
        textView.snp.makeConstraints { make in
            make.centerX.equalTo(contentsView)
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.width.equalTo(contentsView.snp.width).multipliedBy(0.85)
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentsView)
            make.bottom.equalTo(contentsView.snp.bottom).inset(16)
            make.width.equalTo(contentsView.snp.width).multipliedBy(0.85)
            make.height.equalTo(50)
        }
    }
    
}

extension DiaryViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        var keyboardHeight: CGFloat = 0.0
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.contentsView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.85)
                make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
                make.bottom.equalTo(self.view).inset(keyboardHeight + 10)
            }
            self.contentsView.superview?.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.contentsView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.85)
                make.height.equalToSuperview().multipliedBy(0.7)
            }
            self.contentsView.superview?.layoutIfNeeded()
        }
    }
    
}


