//
//  WBTimelineViewController.swift
//  AsyncDrawingKit-Demo
//
//  Created by DSKcpp on 2017/5/26.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit

final class WBTimelineViewController: UIViewController {

    var timelineItems: [WBTimelineItem] = []
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(WBTImelineTableViewCell.self, forCellReuseIdentifier: "WBTImelineTableViewCell")
        view.addSubview(tableView)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let path = Bundle.main.path(forResource: "WBTimelineJSON", ofType: "zip")
            let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
            let unzipData = (data as NSData).uncompressZipped() as Data
            let json = String(data: unzipData, encoding: .utf8)
            let cards = WBCardsModel.deserialize(from: json)
            
            let semaphore = DispatchSemaphore(value: 1)
            let width = self?.tableView.bounds.width ?? 0
            
            cards?.cards.forEach { card in
                var item: WBTimelineItem?
                if let timelineItem = card.mblog {
                    item = timelineItem
                } else if let timelineItem = card.card_group?.first?.mblog {
                    item = timelineItem
                }
                
                if let item = item {
                    _ = WBTimelineContentView.height(of: item, contentWidth: width)
                    _ = semaphore.wait(timeout: .distantFuture)
                    self?.timelineItems.append(item)
                    semaphore.signal()
                }
            }

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
    
}


