//
//  AsyncUIControl.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncUIControl: AsyncDrawingView {
    
    var isEnabled = true {
        willSet {
            if isEnabled != newValue {
                stateWillChange()
            }
        } didSet {
            stateDidChange()
        }
    }
    
    lazy var isSelected = false
    lazy var isHighlighted = false
    
    lazy var redrawsAutomaticallyWhenStateChange = false
    
    
    fileprivate lazy var targetActions: [TargetAction] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        isExclusiveTouch = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public var state: UIControlState {
        var state = UIControlState.normal
        if isHighlighted {
            state = .highlighted
        }
        if !isEnabled {
            state = state.union(.disabled)
        }
        if isSelected {
            state = state.union(.selected)
        }
        return state
    }
    
    //public var isTracking: Bool { get }
    
    //public var isTouchInside: Bool { get }
    
    
    open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        
    }
    
    open func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        
    }
    
    
    // get info about target & actions. this makes it possible to enumerate all target/actions by checking for each event kind
    
    //open var allTargets: Set<An> {

   //     var result = Set<AnyObject>(targetActions.flatMap { $0.target })
    //    return result
   // }
    
    //open var allControlEvents: UIControlEvents {
        
    // }
    
    //open func actions(forTarget target: Any?, forControlEvent controlEvent: UIControlEvents) -> [String]? {
    //    targetActions.filter { e in
    //        return target == e.target && controlEvent == e.controlEvents
   //     }
   // }
    
    open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        UIApplication.shared.sendAction(action, to: target, from: self, for: event)
    }
    
    open func sendActions(for controlEvents: UIControlEvents) {
        sendActions(for: controlEvents, with: nil)
    }
    
    fileprivate func sendActions(for controlEvents: UIControlEvents, with event: UIEvent?) {
        targetActions.forEach { [unowned self] targetAction in
            if let target = targetAction.target, let action = targetAction.action {
                self.sendAction(action, to: target, for: event)
            }
        }
    }
    
    
    func stateToString(_ state: UIControlState) -> String {
        if (state.contains(.normal)) {
            return "normal"
        } else {
            return ""
        }
    }
    
    //open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
    //}
    
    //open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
    //}
    
    open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
    }
    
    open func cancelTracking(with event: UIEvent?) {
        
    }
}

fileprivate extension AsyncUIControl {
    
    func stateWillChange() {
        
    }
    
    func stateDidChange() {
        if redrawsAutomaticallyWhenStateChange {
            setNeedsDisplay()
        }
    }
}

fileprivate class TargetAction: NSObject {
    
    var action: Selector?
    weak var target: AnyObject?
    var controlEvents: UIControlEvents = []
}
