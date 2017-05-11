//
//  ImageTask.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/8.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

protocol ImageTask {
    
    var imageURL: String { get }
    
    func isCancelled() -> Bool
    func cancel()
}

class ImageIOTask: ImageTask {
    
    private(set) var imageURL: String
    
    private var invalid = false
    private let lock = Lock()

    class func task(for imageURL: String) -> ImageIOTask {
        return ImageCache.shared.fetchIOTask(imageURL)
    }
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }

    func isCancelled() -> Bool {
        lock.lock()
        let invalid = self.invalid
        lock.unlock()
        return invalid
    }
    
    func cancel() {
        lock.lock()
        invalid = true
        lock.unlock()
    }
}

class ImageDownloaderTask: ImageTask {
    
    private(set) var imageURL: String
    
    private var invalid = false
    private let lock = Lock()
    
    var downloadProgress: ((TimeInterval) -> Void)?
    var completion: ((UIImage?, Error?) -> Void)?
    
    class func task(for imageURL: String) -> ImageDownloaderTask {
        
    }
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    func isCancelled() -> Bool {
        
    }
    
    func cancel() {
        
    }
    
    func createSessionTaskIfNecessary(with block: () -> URLSessionDownloadTask) -> URLSessionDownloadTask? {
        
    }
}
