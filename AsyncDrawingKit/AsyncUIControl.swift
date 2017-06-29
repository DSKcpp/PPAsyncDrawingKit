//
//  AsyncUIControl.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncUIControl: AsyncDrawingView {
    
//    var isEnabled = true
//    var isSelected = falses
//    var isHighlighted = false
//
//    public private(set) var isTracking = false
//    public private(set) var isTouchInside = false
//
//    var redrawsAutomaticallyWhenStateChange = false
//    public private(set) var state = UIControlState.normal
//
//    public private(set) var touchStartPoint = CGPoint.zero
////    public private(set) var allTargets: Set<Any> = []
//
//    fileprivate var targetActions: [TargetAction] = []
//
//    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
//        let ta = TargetAction()
//        ta.target = target as AnyObject
//        ta.action = action
//        ta.controlEvents = controlEvents
//        targetActions.append(ta)
//    }
//
//    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
//
//    }
//
////    func beginTracking(_ touch: UITouch?, with event: UIEvent?) -> Bool {
////
////    }
////
////    func continueTracking(_ touch: UITouch?, with event: UIEvent?) -> Bool {
////
////    }
////
////    func endTracking(_ touch: UITouch?, with event: UIEvent?) -> Bool {
////
////    }
////
////    func cancelTracking(with event: UIEvent?) {
////
////    }
////
////    func actions(forTarget target: Any?, forControlEvent controlEvent: UIControlEvents) -> [String]? {
////
////    }
//
//    func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
//
//    }
//
//    func sendActions(for controlEvents: UIControlEvents) {
//
//    }
}

fileprivate class TargetAction: NSObject {
    
    var action: Selector?
    weak var target: AnyObject?
    var controlEvents: UIControlEvents = []
}
