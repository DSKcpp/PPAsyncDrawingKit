//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import AsyncDrawingKit

let imageView = AsyncImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
imageView.image = #imageLiteral(resourceName: "avatar.png")
imageView.cornerRadius = 50
imageView.borderWidth = 0.5
imageView.borderColor = .red
imageView.contentMode = .scaleAspectFill
imageView.backgroundColor = .gray

imageView.drawingDidFinish = { [unowned imageView] _, success in
    guard success else { return }
/*:
Origin Image
     
![Origin Image](avatar.png)
     
Display to ImageView
*/
    imageView
}

PlaygroundPage.current.liveView = imageView
//: [Next](@next)
