import UIKit
import PlaygroundSupport

let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
container.backgroundColor = .white
PlaygroundPage.current.liveView = container

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
container.addSubview(view)
view.backgroundColor = .red
view.bounceOut(duration: 2)

// ------------------------------------------------------------------------------------

extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

5.times { print("Hello!") }

// ------------------------------------------------------------------------------------

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        self.remove(at: index)
    }
}

var array = ["Apple", "Orange", "Banana", "Orange"]
array.remove(item: "Orange")

// ------------------------------------------------------------------------------------
