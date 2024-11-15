import UIKit

public protocol SparkTrajectory {
    /// Stores all points that defines a trajectory.
    var points: [CGPoint] { get set }

    /// A path representing trajectory.
    var path: UIBezierPath { get }
}

public extension SparkTrajectory {
    /// Scales a trajectory so it fits to a UI requirements in terms of size of a trajectory.
    /// Use it after all other transforms have been applied and before `shift`.
    func scale(by value: CGFloat) -> SparkTrajectory {
        var copy = self
        (0..<points.count).forEach { copy.points[$0].multiply(by: value) }
        return copy
    }

    /// Flips trajectory horizontally
    func flip() -> SparkTrajectory {
        var copy = self
        (0..<points.count).forEach { copy.points[$0].x *= -1 }
        return copy
    }

    /// Shifts a trajectory by (x, y). Applies to each point.
    /// Use it after all other transformations have been applied and after `scale`.
    func shift(to point: CGPoint) -> SparkTrajectory {
        var copy = self
        let vector = CGVector(dx: point.x, dy: point.y)
        (0..<points.count).forEach { copy.points[$0].add(vector: vector) }
        return copy
    }
}

/// Bezier path with one control point.
public struct QuadraticBezierTrajectory: SparkTrajectory {
    public var points = [CGPoint]()

    public init(_ x0: CGFloat, _ y0: CGFloat,
                _ x1: CGFloat, _ y1: CGFloat,
                _ x2: CGFloat, _ y2: CGFloat)
    {
        points.append(CGPoint(x: x0, y: y0))
        points.append(CGPoint(x: x1, y: y1))
        points.append(CGPoint(x: x2, y: y2))
    }

    public var path: UIBezierPath {
        guard points.count == 3 else { fatalError("3 points required.") }

        let path = UIBezierPath()
        path.move(to: points[0])
        path.addQuadCurve(to: points[2], controlPoint: points[1])
        return path
    }
}

/// Bezier path with two control points.
public struct CubicBezierTrajectory: SparkTrajectory {
    public var points = [CGPoint]()

    public init(_ x0: CGFloat, _ y0: CGFloat,
                _ x1: CGFloat, _ y1: CGFloat,
                _ x2: CGFloat, _ y2: CGFloat,
                _ x3: CGFloat, _ y3: CGFloat)
    {
        points.append(CGPoint(x: x0, y: y0))
        points.append(CGPoint(x: x1, y: y1))
        points.append(CGPoint(x: x2, y: y2))
        points.append(CGPoint(x: x3, y: y3))
    }

    public var path: UIBezierPath {
        guard points.count == 4 else { fatalError("4 points required") }

        let path = UIBezierPath()
        path.move(to: points[0])
        path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
        return path
    }
}
