//
//  AsyncUIControl.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/1.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncUIControl: AsyncDrawingView {
    
    private lazy var _isEnabled = true
    
    public var isEnabled: Bool {
        get {
            return _isEnabled
        } set {
            if newValue != _isEnabled {
                stateWillChange()
                _isEnabled = newValue
                stateDidChange()
            }
        }
    }
    
    private lazy var _isSelected = false
    
    public var isSelected: Bool {
        get {
            return _isSelected
        } set {
            if newValue != _isSelected {
                stateWillChange()
                _isSelected = newValue
                stateDidChange()
            }
        }
    }
    
    private lazy var _isHighlighted = false
    
    public var isHighlighted: Bool {
        get {
            return _isHighlighted
        } set {
            if newValue != _isHighlighted {
                stateWillChange()
                _isHighlighted = newValue
                stateDidChange()
            }
        }
    }
    
    public lazy var redrawsAutomaticallyWhenStateChange = false
    
    public lazy var isTouchInside = false
    public lazy var isTracking = false
    
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
    
    
    
    //public var isTouchInside: Bool { get }
    
    
    open func addTarget(_ target: NSObjectProtocol, action: Selector, for controlEvents: UIControlEvents) {
        let targetAction = TargetAction(action: action, target: target)
        targetAction.target = target
        targetAction.controlEvents = controlEvents
        targetActions.append(targetAction)
    }

    open func removeTarget(_ target: NSObjectProtocol, action: Selector, for controlEvents: UIControlEvents) {
        for (i, targetAction) in targetActions.enumerated() {
            if targetAction.target === target && targetAction.action == action && controlEvents == targetAction.controlEvents {
                targetActions.remove(at: i)
            }
        }
    }
    
    
    
    //open var allTargets: Set<An> {

   //     var result = Set<AnyObject>(targetActions.flatMap { $0.target })
    //    return result
   // }
    
    //open var allControlEvents: UIControlEvents {
        
    // }
    
    open func actions(forTarget target: NSObjectProtocol, forControlEvent controlEvent: UIControlEvents) -> [String]? {
        let results = targetActions.filter { e in
            return target === e.target && controlEvent == e.controlEvents
        }
        return results.map { String(describing: $0.action) }
    }
    
    open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        UIApplication.shared.sendAction(action, to: target, from: self, for: event)
    }
    
    open func sendActions(for controlEvents: UIControlEvents) {
        sendActions(for: controlEvents, with: nil)
    }
    
    fileprivate func sendActions(for controlEvents: UIControlEvents, with event: UIEvent?) {
        targetActions.forEach { [unowned self] targetAction in
            if let target = targetAction.target {
                if targetAction.controlEvents == controlEvents {
                    self.sendAction(targetAction.action, to: target, for: event)
                }
            }
        }
    }
    
    func stateToString(_ state: UIControlState) -> String {
        if state.contains(.normal) {
            return "normal"
        } else {
            return ""
        }
    }
    
    open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
    
    open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
    
    open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
    }
    
    open func cancelTracking(with event: UIEvent?) {
        
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchInside = true
        guard let touch = touches.first else { return }
        isTracking = beginTracking(touch, with: event)
        isHighlighted = true
        
        if isTracking {
            var controlEvents: UIControlEvents = .touchDown
            if touch.tapCount > 1 {
                controlEvents = controlEvents.union(.touchDownRepeat)
            }
            
            sendActions(for: controlEvents, with: event)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation: CGPoint
        let touch = touches.first
        if touch != nil {
            touchLocation = touch!.location(in: self)
        } else {
            touchLocation = .zero
        }
        isTouchInside = point(inside: touchLocation, with: event)
        isHighlighted = isTouchInside
        if isTracking {
//            let continueTracking = self.continueTracking(touch, with: event)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation: CGPoint
        let touch = touches.first
        if touch != nil {
            touchLocation = touch!.location(in: self)
        } else {
            touchLocation = .zero
        }
        isTouchInside = point(inside: touchLocation, with: event)
        isHighlighted = false
        if isTracking {
            endTracking(touch, with: event)
            let controlEvents: UIControlEvents
            if isTouchInside {
                controlEvents = .touchUpInside
            } else {
                controlEvents = .touchUpOutside
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { [unowned self] in
                self.sendActions(for: controlEvents, with: event)
            })
        }
        isTouchInside = false
        isTracking = false
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        if isTracking {
            cancelTracking(with: event)
            sendActions(for: .touchCancel, with: event)
        }
        isTouchInside = false
        isTracking = false
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

fileprivate class TargetAction {
    
    let action: Selector!
    weak var target: NSObjectProtocol!
    var controlEvents: UIControlEvents = []
    
    init(action: Selector, target: NSObjectProtocol) {
        self.action = action
        self.target = target
    }
}
