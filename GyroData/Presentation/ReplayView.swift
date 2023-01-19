//
//  ReplayView.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class ReplayView: UIView {
    let measurementTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022/09/07 15:10:11"
        return label
    }()
    
    let pageTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View"
        return label
    }()
    
    let chartsView: ChartView = {
        let view = ChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let playStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .light)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTimeLabel(time: String) {
        self.runtimeLabel.text = "\(time)"
    }
    
    func configureLabelText(motion: MotionInfo) {
        measurementTime.text = motion.data.date
        pageTypeLabel.text = motion.pageType.name
        runtimeLabel.text = "00.0"
    }
    
    func configureButtonImage(_ systemImageName: String) {
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 45,
            weight: .light
        )
        playButton.setImage(
            UIImage(
                systemName: systemImageName,
                withConfiguration: imageConfig),
            for: .normal
        )
    }
}
