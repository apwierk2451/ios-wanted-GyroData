//
//  Stopwatch.swift
//  GyroData
//
//  Created by seohyeon park on 2022/12/29.
//

import Foundation

class Stopwatch {
    static let share = Stopwatch()
    
    var timer = Timer()
    var isRunning = false
    
    private init() { }
}
