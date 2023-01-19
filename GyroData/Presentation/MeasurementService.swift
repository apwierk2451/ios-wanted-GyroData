//
//  MeasurementService.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

import CoreMotion

class MeasurementService {
    private let manager = CMMotionManager()
    private(set) var timer = Timer()
    
    var gyroCoordinates: [(x: Double, y: Double, z: Double)] = [] {
        didSet {
            guard let coordinate = gyroCoordinates.last else { return }
            addAction?(coordinate)
        }
    }

    private var addAction: (((x: Double, y: Double, z: Double)) -> Void)?
    
    private var stopAction: (() -> Void)?
    
    private var duringTime = ""
    
    func measureAccelerometer() {
        gyroCoordinates = []
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        
        var second: Double = 0
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] timer in
            second += 0.1
            self?.duringTime = "\(second)"
            
            if Int(second) == 60 {
                self?.stopAction?()
            }
            
            if let data = self?.manager.accelerometerData {
                self?.gyroCoordinates.append(
                    (x: data.acceleration.x,
                     y: data.acceleration.y,
                     z: data.acceleration.z)
                )
            }
        }
    }
    
    func measureGyro() {
        gyroCoordinates = []
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = 0.1
        
        var second: Double = 0

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1, repeats: true
        ) { [weak self] timer in
            second += 0.1
            self?.duringTime = "\(second)"
            
            if Int(second) == 60 {
                self?.stopAction?()
            }
            
            if let data = self?.manager.gyroData {
                self?.gyroCoordinates.append(
                    (x: data.rotationRate.x,
                     y: data.rotationRate.y,
                     z: data.rotationRate.z)
                )
            }
        }
    }
    
    func stopMeasurement() {
        timer.invalidate()
    }

    func getMeasurementResult() -> [(x: Double, y: Double, z: Double)] {
        let result = gyroCoordinates
        gyroCoordinates = []
        return result
    }
    
    func getDuringTime() -> String {
        return self.duringTime
    }
    
    func registStopAction(action: @escaping (() -> Void)) {
        stopAction = action
    }
    
    func registerCoordinateAction(action: @escaping (((x: Double, y: Double, z: Double)) -> Void)) {
        addAction = action
    }
}
