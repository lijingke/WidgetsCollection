import UIKit

extension CGPoint {
    mutating func add(vector: CGVector) {
        x += vector.dx
        y += vector.dy
    }

    func adding(vector: CGVector) -> CGPoint {
        var copy = self
        copy.add(vector: vector)
        return copy
    }

    mutating func multiply(by value: CGFloat) {
        x *= value
        y *= value
    }
}
