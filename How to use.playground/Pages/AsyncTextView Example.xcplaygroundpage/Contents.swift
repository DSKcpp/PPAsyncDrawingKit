//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import AsyncDrawingKit

AsyncTextRenderer.debugModeEnabled = true

let label = AsyncTextView()
let text = NSMutableAttributedString(string: "Fuck JS!")
text.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 0, length: text.length))

label.backgroundColor = .white
label.attributedString = text
label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)


PlaygroundPage.current.liveView = label
//: [Next](@next)
