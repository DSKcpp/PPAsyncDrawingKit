//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import AsyncDrawingKit

let imageView = AsyncImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
imageView.image = #imageLiteral(resourceName: "avatar.png")
imageView.cornerRadius = 50
imageView.borderWidth = 0.1
imageView.borderColor = .red
imageView.contentMode = .scaleAspectFill
imageView.backgroundColor = .white

imageView.drawingFinish = { [unowned imageView] _, success in
    guard success else { return }
    #imageLiteral(resourceName: "avatar.png")
    imageView
}

PlaygroundPage.current.liveView = imageView
//: [Next](@next)
