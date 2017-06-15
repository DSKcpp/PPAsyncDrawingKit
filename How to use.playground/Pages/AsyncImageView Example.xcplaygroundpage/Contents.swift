//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import AsyncDrawingKit

let imageView = AsyncImageView()
imageView.image = #imageLiteral(resourceName: "avatar.png")
imageView.backgroundColor = .white
imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

PlaygroundPage.current.liveView = imageView
//: [Next](@next)
