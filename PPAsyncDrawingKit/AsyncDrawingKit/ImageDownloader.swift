//
//  ImageDownloader.swift
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/5/11.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    
    static let shared = ImageDownloader()
    
    private(set) var downloaderTasks: [String : ImageDownloaderTask] = [:]
    lazy var session: URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: self.sessionDelegateQueue)
        return session
    }()
    
    private let lock = Lock()
    private let sessionDelegateQueue = OperationQueue()
    
    
    override init() {
        super.init()
        
        sessionDelegateQueue.maxConcurrentOperationCount = 10
    }
    
    func downloaderImage(url: URL, downloadProgress: @escaping (TimeInterval) -> Void, completion: @escaping (UIImage?, Error?) -> Void) -> ImageDownloaderTask {
        let task = ImageDownloaderTask.task(for: url.absoluteString)
        task.downloadProgress = downloadProgress
        task.completion = completion
        DispatchQueue.global().async {
            let sessionTask = task.createSessionTaskIfNecessary(with: { () -> URLSessionDownloadTask in
                return self.session.downloadTask(with: url)
            })
            if let sessionTask = sessionTask {
                sessionTask.resume()
            }
        }
        return task
    }
    
    func fetchDownloadTask(url: String) -> ImageDownloaderTask {
        lock.lock()
        let task = downloaderTasks[url] ?? ImageDownloaderTask(imageURL: url)
        lock.unlock()
        
        lock.lock()
        downloaderTasks[url] = task
        lock.unlock()

        return task
    }
    
    func cancelImageDownload(_ task: ImageDownloaderTask) {
        task.cancel()
        
        lock.lock()
        downloaderTasks.removeValue(forKey: task.imageURL)
        lock.unlock()
    }
}

extension ImageDownloader: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url?.absoluteString, let task = downloaderTasks[url] else { return }
        if let downloadProgress = task.downloadProgress {
            DispatchQueue.main.async {
                downloadProgress(TimeInterval(totalBytesWritten) / TimeInterval(totalBytesExpectedToWrite))
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url?.absoluteString, let task = downloaderTasks[url] else { return }
        do {
            let data = try Data(contentsOf: location)
            
        } catch {
            print(error)
        }
    }
    
    - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
    {
    PPImageDownloaderTask *task = _downloaderTasks[downloadTask.originalRequest.URL.absoluteString];
    NSData *data = [NSData dataWithContentsOfURL:location];
    [[PPImageCache sharedCache] storeImageDataToDisk:data forURL:task.URL];
    
    if (task.isCancelled) {
    return;
    }
    if (task.completion) {
    UIImage *image = [PPImageDecode imageWithData:data];
    image = [PPImageDecode decodeImageWithImage:image];
    PPAsyncExecuteInMainQueue(^{
    task.completion(image, nil);
    });
    }
    }
    
    - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    {
    PPImageDownloaderTask *_task = _downloaderTasks[task.originalRequest.URL.absoluteString];
    
    if (_task.completion && error) {
    PPAsyncExecuteInMainQueue(^{
    _task.completion(nil, error);
    });
    }
    }
}
