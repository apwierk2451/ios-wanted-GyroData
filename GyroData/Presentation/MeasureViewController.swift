//
//  MeasureViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class MeasureViewController: UIViewController {
    private let measureView = MeasureView()
    private let measurementService = MeasurementService()
    private let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupNavigationItem()
        setupDefault()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAction()
    }

    private func setupButton() {
        measureView.measurementButton.addTarget(self, action: #selector(measureAction), for: .touchUpInside)
        measureView.stopButton.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        measurementService.registStopAction(action: stopAction)
    }
    
    private func toggleSegmentedControl(isEnable: Bool) {
        let index = measureView.measurementSegmentedControl.selectedSegmentIndex
        var number = MeasurementType.acc.number
        
        if index == MeasurementType.acc.number {
            number = MeasurementType.gyro.number
        }
        
        measureView.measurementSegmentedControl.setEnabled(isEnable, forSegmentAt: number)
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "측정하기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveAction)
        )
    }

    private func setupDefault() {
        view = measureView
        view.backgroundColor = .white
    }
    
    private func showFailureAlert(message: String) {
        let alert = UIAlertController(title: "저장 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    @objc func measureAction() {
        measureView.measurementButton.isHidden = true
        measureView.stopButton.isHidden = false
        toggleSegmentedControl(isEnable: false)
        measureView.chartsView.setupDefaultValue()
        
        switch measureView.measurementSegmentedControl.selectedSegmentIndex {
        case MeasurementType.acc.number:
            measurementService.measureAccelerometer()
        default:
            measurementService.measureGyro()
        }
        
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc
    private func stopAction() {
        measurementService.stopMeasurement()
        toggleSegmentedControl(isEnable: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveAction)
        )
        measureView.stopButton.isHidden = true
        measureView.measurementButton.isHidden = false
    }
    
    @objc
    private func saveAction() {
        if self.measurementService.timer.isValid {
            return
        }
        
        let data = self.measurementService.getMeasurementResult()
        let duringTime = self.measurementService.getDuringTime()
        
        if data.isEmpty {
            showFailureAlert(message: "데이터가 존재하지 않습니다.")
            return
        }
        
        var type = MeasurementType.acc.name
        if measureView.measurementSegmentedControl.selectedSegmentIndex == 1 {
            type = MeasurementType.gyro.name
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var dataX = [Double]()
        var dataY = [Double]()
        var dataZ = [Double]()
        
        data.forEach { (x, y, z) in
            dataX.append(x)
            dataY.append(y)
            dataZ.append(z)
        }
        
        let motion = Motion(
            date: dateFormatter.string(from: Date()),
            measurementType: type,
            runtime: String(format: "%.1f", Double(duringTime) ?? 0),
            motionX: dataX,
            motionY: dataY,
            motionZ: dataZ
        )
        
        measureView.indicator.center = view.center
        measureView.indicator.startAnimating()
        
        FileManager.default.addFile(for: motion)
        
        coreDataManager.save(data: motion) { result in
            self.measureView.indicator.stopAnimating()
            
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showFailureAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func bind() {
        measurementService.registAppandCoordinateAction { (x, y, z) in
            self.measureView.chartsView.drawLine(x: x, y: y, z: z)
            
            let strX = String(format: "%.1f", x)
            let strY = String(format: "%.1f", y)
            let strZ = String(format: "%.1f", z)
            
            self.measureView.chartsView.configureLabelText(x: strX, y: strY, z: strZ)
        }
    }
}
