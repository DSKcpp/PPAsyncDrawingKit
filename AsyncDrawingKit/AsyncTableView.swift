//
//  AsyncTableView.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2017/6/16.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

open class AsyncTableView: UITableView {
    
    public var afterAsyncTime: TimeInterval = 0.5
    
    private func setGloballyAsyncDrawingEnabledToEnable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterAsyncTime) {
            AsyncDrawingView.globallyAsyncDrawingEnabled = true
        }
    }

    override open func reloadData() {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.reloadData()
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.reloadData()
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    override open func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.reloadRows(at: indexPaths, with: animation)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.reloadRows(at: indexPaths, with: animation)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    override open func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.insertRows(at: indexPaths, with: animation)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.insertRows(at: indexPaths, with: animation)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    override open func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.insertRows(at: indexPaths, with: animation)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.deleteRows(at: indexPaths, with: animation)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    override open func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.moveRow(at: indexPath, to: newIndexPath)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.moveRow(at: indexPath, to: newIndexPath)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    open override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.reloadSections(sections, with: animation)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.reloadSections(sections, with: animation)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    open override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.insertSections(sections, with: animation)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.insertSections(sections, with: animation)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    open override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.deleteSections(sections, with: animation)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.deleteSections(sections, with: animation)
        setGloballyAsyncDrawingEnabledToEnable()
    }
    
    open override func moveSection(_ section: Int, toSection newSection: Int) {
        guard AsyncDrawingView.globallyAsyncDrawingEnabled else {
            super.moveSection(section, toSection: newSection)
            return
        }
        AsyncDrawingView.globallyAsyncDrawingEnabled = false
        super.moveSection(section, toSection: newSection)
        setGloballyAsyncDrawingEnabledToEnable()
    }

}
