//
//  AsyncQueuePoolView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/6/14.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

protocol AsyncQueuePoolViewDelegate: NSObjectProtocol {
    
    func numberOfItems(in queuePoolView: AsyncQueuePoolView) -> Int
    func queuePoolView(_ queuePoolView: AsyncQueuePoolView, viewForItemAtIndex: Int) -> AsyncQueuePoolView.ReusableView
}

class AsyncQueuePoolView: UIView {
    
    typealias ReusableView = AsyncDrawingView
    
    weak var delegate: AsyncQueuePoolViewDelegate?
    
    fileprivate lazy var idleReusbaleViews: [ReusableView] = []
    fileprivate lazy var reusbaleViews: [ReusableView] = []
    
    func dequeueReusableView() -> ReusableView? {
        if let first = idleReusbaleViews.first {
            idleReusbaleViews.remove(at: 0)
            return first
        } else {
            return nil
        }
    }
    
    fileprivate func append(toIdle reusableView: ReusableView) {
        idleReusbaleViews.append(reusableView)
    }
}

extension AsyncQueuePoolView {
    
    func reloadData() {
        reusbaleViews.forEach { view in
            view.isHidden = true
            append(toIdle: view)
        }
        guard let delegate = delegate else { return }
        let itemNumbers = delegate.numberOfItems(in: self)
        if itemNumbers > 0 {
            var views: [ReusableView] = []
            for i in 0..<itemNumbers {
                let reusableView = delegate.queuePoolView(self, viewForItemAtIndex: i)
                reusableView.isHidden = false
                addSubview(reusableView)
                views.append(reusableView)
            }
            
            reusbaleViews.removeAll()
            reusbaleViews = views
        }
    }
}
