//
//  MeasureView.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class MeasureView: UIView {
    
    let measurementSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(
            items: [MeasurementType.acc.name, MeasurementType.gyro.name]
        )
        control.selectedSegmentTintColor = .systemBlue
        control.selectedSegmentIndex = MeasurementType.acc.number
        control.backgroundColor = .white
        control.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 100)
        control.layer.borderWidth = 2
        control.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 100)
        control.layer.masksToBounds = false
        control.layer.shadowOffset = CGSizeMake(5, 5)
        control.layer.shadowOpacity = 1
        control.layer.shadowRadius = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let chartsView: ChartView = {
        let view = ChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let measurementButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .systemBlue

        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(measurementSegmentedControl)
        self.addSubview(chartsView)
        self.addSubview(measurementButton)
        self.addSubview(stopButton)
        self.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            measurementSegmentedControl.leftAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            measurementSegmentedControl.rightAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.rightAnchor,
                constant: -30
            ),
            measurementSegmentedControl.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: 15
            ),
            
            chartsView.leftAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            chartsView.rightAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.rightAnchor,
                constant: -30
            ),
            chartsView.heightAnchor.constraint(
                equalTo: chartsView.widthAnchor
            ),
            chartsView.topAnchor.constraint(
                equalTo: measurementSegmentedControl.bottomAnchor,
                constant: 30
            ),
            
            measurementButton.leftAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            measurementButton.rightAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.rightAnchor,
                constant: -320
            ),
            measurementButton.topAnchor.constraint(
                equalTo: chartsView.bottomAnchor,
                constant: 40
            ),
            
            stopButton.leftAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            stopButton.rightAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.rightAnchor,
                constant: -320
            ),
            stopButton.topAnchor.constraint(
                equalTo: measurementButton.bottomAnchor,
                constant: 40
            ),
            stopButton.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: -150
            )
        ])
    }
    
    func hideButton(_ isButtonHide: Bool) {
        if isButtonHide {
            measurementButton.isHidden = true
            stopButton.isHidden = false
        } else {
            stopButton.isHidden = true
            measurementButton.isHidden = false
        }
    }
}
