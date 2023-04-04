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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        addView(using: squareView, size: 0.9, color: .black)
        addView(using: circleView, size: 0.7, color: .white)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        squareView.layer.cornerRadius = squareView.frame.width / 4
        circleView.layer.cornerRadius = circleView.frame.width / 2
        
        print(circleView.frame.width)
        
        addMinuteMarks(to: circleView)
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
