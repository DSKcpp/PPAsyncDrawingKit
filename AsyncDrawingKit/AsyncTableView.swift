//
//  AsyncTableView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/6/16.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncTableView: UITableView {
    
    public var afterAsyncTime: TimeInterval = 1

    override open func reloadData() {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    override open func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.reloadRows(at: indexPaths, with: animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    override open func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.insertRows(at: indexPaths, with: animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    override open func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.deleteRows(at: indexPaths, with: animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    override open func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.moveRow(at: indexPath, to: newIndexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    open override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.reloadSections(sections, with: animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    open override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.insertSections(sections, with: animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    open override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.deleteSections(sections, with: animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }
    
    open override func moveSection(_ section: Int, toSection newSection: Int) {
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.moveSection(section, toSection: newSection)
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }

}
