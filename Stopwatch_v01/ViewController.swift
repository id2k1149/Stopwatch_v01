//
//  ViewController.swift
//  Stopwatch_v01
//
//  Created by Max Franz Immelmann on 4/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    let squareView = UIView()
    let circleView = UIView()
    
    var digitalStartTime: TimeInterval?
    var digitalTimer: Timer?
    
    let digitalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 64, weight: .regular)
        label.textAlignment = .center
        label.text = "00:00.00"
        return label
    }()
    
    var analogStartTime: TimeInterval?
    var analogTimer: Timer?
    
    let analogStopwatchView = AnalogStopwatchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        addView(using: squareView, size: 0.9, color: .black)
        addView(using: circleView, size: 0.7, color: .white)
        
        // Add time label to view
        view.addSubview(digitalTimeLabel)
        digitalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            digitalTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitalTimeLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
        ])
        
        // Add analog stopwatch view to view
        view.addSubview(analogStopwatchView)
        analogStopwatchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            analogStopwatchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            analogStopwatchView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            analogStopwatchView.widthAnchor.constraint(equalToConstant: 100),
            analogStopwatchView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Add start button to view
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .orange
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.layer.cornerRadius = 25
        startButton.addTarget(self, action: #selector(startStopwatch), for: .touchUpInside)
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        squareView.layer.cornerRadius = squareView.frame.width / 4
        circleView.layer.cornerRadius = circleView.frame.width / 2
        
        addMinuteMarks(to: circleView)
        
        
    }
    
    @objc func startStopwatch() {
        if digitalTimer == nil {
            // Start the timer
            digitalStartTime = Date().timeIntervalSinceReferenceDate
            digitalTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateDigitalTimeLabel), userInfo: nil, repeats: true)
            
            // Start the analog timer
            analogStartTime = Date().timeIntervalSinceReferenceDate
            analogTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAnalogStopwatch), userInfo: nil, repeats: true)
                     
            // Change button title to "Stop"
            if let startButton = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                startButton.setTitle("Stop", for: .normal)
            }
        } else {
            // Stop the timer
            digitalTimer?.invalidate()
            digitalTimer = nil
            
            // Stop the analog timer
            analogTimer?.invalidate()
            analogTimer = nil
            
            // Change button title to "Start"
            if let startButton = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                startButton.setTitle("Start", for: .normal)
            }
        }
    }
    
//    @objc func updateTimeLabel() {
//        guard let startTime = digitalStartTime else { return }
//
//        // Calculate elapsed time
//        let currentTime = Date().timeIntervalSinceReferenceDate
//        let elapsedTime = currentTime - startTime
//
//        // Format elapsed time as minutes, seconds, and hundredths of a second
//        let minutes = Int(elapsedTime / 60)
//        let seconds = Int(elapsedTime) % 60
//        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
//
//        // Update time label text
//        digitalTimeLabel.text = String(format: "%02d:%02d.%02d",
//                                minutes,
//                                seconds,
//                                hundredths)
//    }
    
    @objc func updateDigitalTimeLabel() {
        guard let startTime = digitalStartTime else { return }
        
        // Calculate elapsed time
        let currentTime = Date().timeIntervalSinceReferenceDate
        let elapsedTime = currentTime - startTime
        
        // Format elapsed time as minutes, seconds, and hundredths of a second
        let minutes = Int(elapsedTime / 60)
        let seconds = Int(elapsedTime) % 60
        let hundredths = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
        
        // Update time label text
        digitalTimeLabel.text = String(format: "%02d:%02d.%02d",
                                       minutes,
                                       seconds,
                                       hundredths)
    }

    @objc func updateAnalogStopwatch() {
        guard let startTime = analogStartTime else { return }
        
        let currentTime = Date().timeIntervalSinceReferenceDate
        let elapsedTime = currentTime - startTime
        
        // 30 is the number of seconds for a full rotation
//        let rotationAngle = CGFloat(elapsedTime) * .pi / 30
        
//        analogStopwatchView.rotateHand(to: rotationAngle)
    }

}

extension UIViewController {
    func addView(using subview: UIView, size: CGFloat, color: UIColor) {
        
        let minSize = min(view.frame.height, view.frame.width) * size
        
        view.addSubview(subview)
        subview.backgroundColor = color
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.widthAnchor.constraint(equalToConstant: minSize).isActive = true
        subview.heightAnchor.constraint(equalTo: subview.widthAnchor).isActive = true
        
        subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func addMinuteMarks(to circleView: UIView) {
        let markSize = CGSize(width: 8, height: 2)
        let markRadius = circleView.frame.width/2 - markSize.width
        
        for i in 0..<60 {
            let mark = UIView(frame: CGRect(origin: .zero, size: markSize))
            let angle = CGFloat(i) / 60.0 * 2.0 * CGFloat.pi
            let x = cos(angle) * markRadius + circleView.frame.width/2
            let y = sin(angle) * markRadius + circleView.frame.height/2
            mark.center = CGPoint(x: x, y: y)
            mark.backgroundColor = UIColor.black
            mark.transform = CGAffineTransform(rotationAngle: angle)
            circleView.addSubview(mark)
        }
    }
}
