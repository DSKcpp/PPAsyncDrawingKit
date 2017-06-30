//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import AsyncDrawingKit

let label = AsyncTextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
let text = NSMutableAttributedString(string: "昨  ")
text.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: text.range)
text.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: text.range)
label.frame.size = text.sizeConstrained(toWidth: 375)
label.backgroundColor = .white
label.attributedString = text

label.drawingFinish = { [unowned label] _, success in
    guard success else { return }
    label
}


PlaygroundPage.current.liveView = label
//: [Next](@next)
