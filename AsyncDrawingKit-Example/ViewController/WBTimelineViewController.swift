//
//  WBTimelineViewController.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/5/26.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit
import AsyncDrawingKit

final class WBTimelineViewController: UIViewController {

    var timelineItems: [WBTimelineItem] = []
    
    let tableView = AsyncTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(WBTImelineTableViewCell.self, forCellReuseIdentifier: "WBTImelineTableViewCell")
        view.addSubview(tableView)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            let path = Bundle.main.path(forResource: "wb", ofType: "gz")
            let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
            let unzipData = (data as NSData).uncompressZipped() as Data
            let json = String(data: unzipData, encoding: .utf8)!
            let model = WBCardsModel.deserialize(from: json)!
            
            let semaphore = DispatchSemaphore(value: 1)
            let width = UIScreen.main.bounds.width
            
            model.cards.forEach { card in
                var item: WBTimelineItem?
                if let timelineItem = card.mblog {
                    item = timelineItem
                } else if let timelineItem = card.card_group?.first?.mblog {
                    item = timelineItem
                }
                
                
                if let item = item {
                    _ = WBTimelineContentView.height(of: item, contentWidth: width)
                    _ = semaphore.wait(timeout: .distantFuture)
                    self.timelineItems.append(item)
                    semaphore.signal()
                }
            }
            
            self.timelineItems += self.timelineItems

            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WBTimelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WBTImelineTableViewCell", for: indexPath) as! WBTImelineTableViewCell
        cell.timelineItem = timelineItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = timelineItems[indexPath.row]
        return item.drawingContext.height
    }
    
}


