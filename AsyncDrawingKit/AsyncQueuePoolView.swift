//
//  AsyncQueuePoolView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/6/14.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

public protocol AsyncQueuePoolViewDataSource: NSObjectProtocol {
    
    func numberOfItems(in queuePoolView: AsyncQueuePoolView) -> Int
    func queuePoolView(_ queuePoolView: AsyncQueuePoolView, viewForItemAt index: Int) -> AsyncQueuePoolView.ReusableView
}

open class AsyncQueuePoolView: UIView {
    
    public typealias ReusableView = AsyncDrawingView
    
    public weak var dataSource: AsyncQueuePoolViewDataSource?
    
    fileprivate lazy var idleReusbaleViews: [ReusableView] = []
    fileprivate lazy var reusbaleViews: [ReusableView] = []
    
    public func dequeueReusableView() -> ReusableView? {
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
    
    open func reloadData() {
        reusbaleViews.forEach { view in
            view.isHidden = true
            append(toIdle: view)
        }
        guard let dataSource = dataSource else { return }
        let itemNumbers = dataSource.numberOfItems(in: self)
        if itemNumbers > 0 {
            var views: [ReusableView] = []
            for i in 0..<itemNumbers {
                let reusableView = dataSource.queuePoolView(self, viewForItemAt: i)
                reusableView.isHidden = false
                addSubview(reusableView)
                views.append(reusableView)
            }
            
            reusbaleViews.removeAll()
            reusbaleViews = views
        }
    }
}
