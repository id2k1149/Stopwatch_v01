//
//  AnalogStopwatchView.swift
//  Stopwatch_v01
//
//  Created by Max Franz Immelmann on 4/4/23.
//

import Foundation
import UIKit

class AnalogStopwatchView: UIView {
    
    private let circleLayer = CAShapeLayer()
    private let secondsHandLayer = CAShapeLayer()
    private let animationDuration: CFTimeInterval = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Create a circle that represents the stopwatch face
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = 2.0
        layer.addSublayer(circleLayer)
        
        // Create a line that represents the second hand
        let secondsHandPath = UIBezierPath()
        secondsHandPath.move(to: center)
        secondsHandPath.addLine(to: CGPoint(x: center.x, y: center.y - radius))
        secondsHandLayer.path = secondsHandPath.cgPath
        secondsHandLayer.strokeColor = UIColor.red.cgColor
        secondsHandLayer.lineWidth = 2.0
        secondsHandLayer.lineCap = .round
        layer.addSublayer(secondsHandLayer)
        
        // Start a timer that updates the second hand's position once per second
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc private func update() {
        // Calculate the angle of the second hand based on the current time
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        let seconds = Double(components.second ?? 0)
        let angle = 2 * Double.pi * seconds / 60.0
        
        // Rotate the second hand to the new angle
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = angle
        rotation.duration = animationDuration
        rotation.isRemovedOnCompletion = false
        rotation.fillMode = .forwards
        secondsHandLayer.add(rotation, forKey: "rotationAnimation")
    }
    
}

