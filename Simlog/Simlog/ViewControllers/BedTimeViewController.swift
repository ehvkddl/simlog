//
//  BedTimeViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/28.
//

import UIKit
import HGCircularSlider

class BedTimeViewController: BaseViewController {

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
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
        view.layer.cornerRadius = 15
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
    
    let bedTimeTitleLabel = {
        let lbl = UILabel()
        lbl.text = "취침시간"
        return lbl
    }()
    
    let bedTimeLabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = .black
        return lbl
    }()
    
    let wakeupTimeTitleLabel = {
        let lbl = UILabel()
        lbl.text = "기상시간"
        return lbl
    }()
    
    let wakeupTimeLabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var rangeCircularSlider = {
        let slider = RangeCircularSlider()
        slider.backgroundColor = .clear
        slider.startThumbImage = UIImage(systemName: "moon.zzz.fill")?.withTintColor(Constants.BaseColor.background)
        slider.endThumbImage = UIImage(systemName: "sun.max.fill")?.withTintColor(Constants.BaseColor.background)
        slider.backtrackLineWidth = 40.0
        slider.lineWidth = 40.0
        slider.trackColor = Constants.BaseColor.grayBackground
        slider.trackFillColor = Constants.BaseColor.accent
        slider.diskColor = .clear
        slider.diskFillColor = Constants.BaseColor.grayBackground
        
        let dayInSeconds = 24 * 60 * 60
        slider.maximumValue = CGFloat(dayInSeconds)
        
        slider.startPointValue = 0 * 60 * 60
        slider.endPointValue = 8 * 60 * 60
        
        return slider
    }()
    
    let clockImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.48, height: 200)
        return view
    }()
    
    let durationLabel = {
        let lbl = UILabel()
        return lbl
    }()
    
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
        config.titleAlignment = .center
        btn.configuration = config
        btn.layer.cornerRadius = 15
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTimeTexts()
        drawTicks(count: 60)
    }
    
    override func configureView() {
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        rangeCircularSlider.addTarget(self, action: #selector(updateTimeTexts), for: .valueChanged)
        
        [backgroundView, contentsView].forEach { view.addSubview($0) }
        [closeButton, bedTimeLabel, wakeupTimeLabel, rangeCircularSlider, clockImageView, saveButton].forEach { contentsView.addSubview($0) }
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
        
        bedTimeLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentsView).inset(10)
        }
        
        wakeupTimeLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentsView).inset(10)
        }
        
        rangeCircularSlider.snp.makeConstraints { make in
            make.center.equalTo(contentsView)
            make.size.equalTo(contentsView.snp.width).multipliedBy(0.95)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.center.equalTo(contentsView)
            make.size.equalTo(contentsView.snp.width).multipliedBy(0.57)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentsView)
            make.bottom.equalTo(contentsView.snp.bottom).inset(16)
            make.width.equalTo(contentsView.snp.width).multipliedBy(0.85)
            make.height.equalTo(50)
        }
    }
    
}

extension BedTimeViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func updateTimeTexts() {
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)
        
        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        bedTimeLabel.text = dateFormatter.string(from: bedtimeDate)
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        wakeupTimeLabel.text = dateFormatter.string(from: wakeDate)
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
}

extension BedTimeViewController {
    
    private func drawTicks(count: Int) {
        let radius = clockImageView.frame.width * 0.5
        var rotationInDegrees: CGFloat = 0

        for i in 0 ..< count {
            let tick = i % 5 == 0 ? createTick(height: 10.0) : createTick(height: 5.0)

            let x = CGFloat(Float(clockImageView.center.x) + Float(radius) * cosf(2 * Float(i) * Float(Double.pi) / Float(count) - Float(Double.pi) / 2))
            let y = CGFloat(Float(clockImageView.center.y) + Float(radius) * sinf(2 * Float(i) * Float(Double.pi) / Float(count) - Float(Double.pi) / 2))

            tick.center = CGPoint(x: x, y: y)
            tick.transform = CGAffineTransform.identity.rotated(by: rotationInDegrees * .pi / 180.0)
            clockImageView.addSubview(tick)

            rotationInDegrees = rotationInDegrees + (360.0 / CGFloat(count))
        }
    }

    private func createTick(height: Double) -> UIView {
        let tick = UIView(frame: CGRect(x: 0, y: 0, width: 1.5, height: height))
        tick.backgroundColor = Constants.BaseColor.tick

        return tick
    }
    
}
