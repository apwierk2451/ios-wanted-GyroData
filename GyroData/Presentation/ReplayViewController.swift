//
//  ReplayViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class ReplayViewController: UIViewController {
    
    private var motionInfo: MotionInfo?
    private let replayView = ReplayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupLayout()
        setupNavigationItem()
        setupDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if motionInfo?.pageType == ReplayViewPageType.view {
            replayView.playButton.isHidden = true
            replayView.runtimeLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if motionInfo?.pageType == ReplayViewPageType.view {
            guard let motion = motionInfo?.data else { return }
            
            for i in 0..<motion.motionX.count {
                self.replayView.chartsView.drawLine(
                    x: motion.motionX[i],
                    y: motion.motionY[i],
                    z: motion.motionZ[i]
                )
            }
        }
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "다시보기"
    }
    
    private func setupDefault() {
        replayView.measurementTime.text = motionInfo?.data.date
        replayView.pageTypeLabel.text = motionInfo?.pageType.name
        replayView.runtimeLabel.text = "00.0"

        replayView.playButton.addTarget(self, action: #selector(activateTimer), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(replayView)
    }
    
    @objc
    func activateTimer() {
        Stopwatch.share.isRunning.toggle()
        
        let systemImageName = Stopwatch.share.isRunning ? "stop.fill" : "play.fill"
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 45,
            weight: .light
        )
        replayView.playButton.setImage(
            UIImage(
                systemName: systemImageName,
                withConfiguration: imageConfig),
            for: .normal
        )
        
        var second: Double = 0
        var count = 0
        if !Stopwatch.share.isRunning {
            Stopwatch.share.timer.invalidate()
            second = 0
            count = 0
            return
        }

        guard let motion = motionInfo?.data else { return }
        
        Stopwatch.share.timer = Timer.scheduledTimer(
            withTimeInterval: 0.1, repeats: true
        ) { [weak self] timer in
            
            count += 1
            second += 0.1

            let strTime = String(format: "%.1f", second)
            self?.replayView.configureTimeLabel(time: strTime)

            if (second == (Double(motion.runtime)) ?? 0.0) || (count >= motion.motionX.count) {
                Stopwatch.share.timer.invalidate()
                return
            }

            self?.replayView.chartsView.drawLine(
                x: motion.motionX[count],
                y: motion.motionY[count],
                z: motion.motionZ[count]
            )
            let strX = String(format: "%.1f", motion.motionX[count])
            let strY = String(format: "%.1f", motion.motionY[count])
            let strZ = String(format: "%.1f", motion.motionZ[count])
            
            self?.replayView.chartsView.configureLabelText(
                x: strX,
                y: strY,
                z: strZ
            )
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(replayView.measurementTime)
        self.view.addSubview(replayView.pageTypeLabel)
        self.view.addSubview(replayView.chartsView)
        self.view.addSubview(replayView.playButton)
        self.view.addSubview(replayView.runtimeLabel)

        NSLayoutConstraint.activate([
            replayView.measurementTime.leftAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            replayView.measurementTime.rightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.rightAnchor,
                constant: -30
            ),
            replayView.measurementTime.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 15
            ),
            
            replayView.pageTypeLabel.leftAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            replayView.pageTypeLabel.rightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.rightAnchor,
                constant: -30
            ),
            replayView.pageTypeLabel.topAnchor.constraint(
                equalTo: replayView.measurementTime.bottomAnchor,
                constant: 5
            ),
            
            replayView.chartsView.leftAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leftAnchor,
                constant: 30
            ),
            replayView.chartsView.rightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.rightAnchor,
                constant: -30
            ),
            replayView.chartsView.topAnchor.constraint(
                equalTo: replayView.pageTypeLabel.bottomAnchor,
                constant: 30
            ),
            replayView.chartsView.heightAnchor.constraint(
                equalTo: replayView.chartsView.widthAnchor
            ),

            replayView.playButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            replayView.playButton.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -200
            ),

            replayView.runtimeLabel.centerYAnchor.constraint(
                equalTo: replayView.playButton.centerYAnchor
            ),
            replayView.runtimeLabel.rightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.rightAnchor,
                constant: -50
            )
        ])
    }
}

extension ReplayViewController: SendDataDelegate {
    func sendData<T>(_ data: T) {
        motionInfo = data as? MotionInfo
    }
}
