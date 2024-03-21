//
//  ScrollViewSimultaneousGesture.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 15/3/24.
//

import UIKit

class ScrollViewSimultaneousGesture: UIScrollView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGestureRecognizer.velocity(in: self)
            print("Pan gesture detected in ScrollViewSimultaneousGesture with velocity: \(velocity)")
            return abs(velocity.y) < abs(velocity.x)
        }
        return false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.gestureRecognizers?.forEach { $0.delegate = self }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.gestureRecognizers?.forEach { $0.delegate = self }
    }
}

