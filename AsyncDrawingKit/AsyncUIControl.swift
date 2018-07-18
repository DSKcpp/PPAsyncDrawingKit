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
    
    private lazy var targetActions: [TargetAction] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        isExclusiveTouch = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var state: UIControl.State {
        var state = UIControl.State.normal
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
    
    
    open func addTarget(_ target: NSObjectProtocol, action: Selector, for controlEvents: UIControl.Event) {
        let targetAction = TargetAction(action: action, target: target, controlEvents: controlEvents)
        if let index = targetActions.index(of: targetAction) {
            targetActions.remove(at: index)
        }
        targetActions.append(targetAction)
    }

    open func removeTarget(_ target: NSObjectProtocol, action: Selector, for controlEvents: UIControl.Event) {
        let targetAction = TargetAction(action: action, target: target, controlEvents: controlEvents)
        if let index = targetActions.index(of: targetAction) {
            targetActions.remove(at: index)
        }
    }
    
    
    
    //open var allTargets: Set<An> {

   //     var result = Set<AnyObject>(targetActions.flatMap { $0.target })
    //    return result
   // }
    
    //open var allControlEvents: UIControlEvents {
        
    // }
    
    open func actions(forTarget target: NSObjectProtocol, forControlEvent controlEvent: UIControl.Event) -> [String]? {
        let results = targetActions.filter { e in
            return target === e.target && controlEvent == e.controlEvents
        }
        return results.map { String(describing: $0.action) }
    }
    
    open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        UIApplication.shared.sendAction(action, to: target, from: self, for: event)
    }
    
    open func sendActions(for controlEvents: UIControl.Event) {
        sendActions(for: controlEvents, with: nil)
    }
    
    private func sendActions(for controlEvents: UIControl.Event, with event: UIEvent?) {
        targetActions.forEach { [unowned self] targetAction in
            if let target = targetAction.target {
                if targetAction.controlEvents == controlEvents {
                    self.sendAction(targetAction.action, to: target, for: event)
                }
            }
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
            var controlEvents: UIControl.Event = .touchDown
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
            let controlEvents: UIControl.Event
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

private extension AsyncUIControl {
    
    func stateWillChange() {
        
    }
    
    func stateDidChange() {
        if redrawsAutomaticallyWhenStateChange {
            setNeedsDisplay()
        }
    }
}

private struct TargetAction {
    
    let action: Selector!
    weak var target: NSObjectProtocol!
    var controlEvents: UIControl.Event = []
    
    init(action: Selector, target: NSObjectProtocol, controlEvents: UIControl.Event) {
        self.action = action
        self.target = target
        self.controlEvents = controlEvents
    }
}

extension TargetAction: Equatable {
    
    public static func ==(lhs: TargetAction, rhs: TargetAction) -> Bool {
        return lhs.target === rhs.target && lhs.action == rhs.action && lhs.controlEvents == rhs.controlEvents
    }
}

extension UIControl.State: Hashable {
    
    public var hashValue: Int {
        return Int(rawValue)
    }
}
