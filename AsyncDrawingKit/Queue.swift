//
//  Queue.swift
//  AsyncDrawingKit
//
//  Created by DSKcpp on 2018/6/6.
//  Copyright © 2018年 DSKcpp. All rights reserved.
//

import UIKit

class Queue {
    
    static let concurrentQueueGroup = ConcurrentQueueGroup(name: "io.67373.drawQueue", qos: .userInteractive)
}

final public class ConcurrentQueueGroup {
    
    private var queues: [DispatchQueue] = []
    
    private let name: String
    private let maxConcurrentCount: Int32
    private let qos: DispatchQoS
    
    private var counter: Int32 = 0
    
    public init(name: String = UUID().uuidString,
                maxConcurrentCount: Int = ProcessInfo.processInfo.activeProcessorCount,
                qos: DispatchQoS = .default) {
        
        self.name = name
        self.maxConcurrentCount = Int32(min(12, maxConcurrentCount))
        self.qos = qos
        
        for _ in 0..<maxConcurrentCount {
            let queue = DispatchQueue(label: name, qos: qos)
            queues.append(queue)
        }
    }
    
    public func idle() -> DispatchQueue {
        OSAtomicIncrement32(&counter)
        let i = Int(counter % maxConcurrentCount)
        return queues[i]
    }
}
