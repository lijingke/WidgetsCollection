import UIKit

public protocol Firework {
    /// Defines origin of firework.
    var origin: CGPoint { get set }

    /// Defines trajectory scale. Trajectory is normalized so it needs to be scaled up
    /// before presenting on screen.
    var scale: CGFloat { get set }

    /// Defines size of a single spark.
    var sparkSize: CGSize { get set }

    /// Returns trajectories
    var trajectoryFactory: SparkTrajectoryFactory { get }

    /// Returns spark views
    var sparkViewFactory: SparkViewFactory { get }

    func sparkViewFactoryData(at index: Int) -> SparkViewFactoryData
    func sparkView(at index: Int) -> SparkView
    func trajectory(at index: Int) -> SparkTrajectory
}

public extension Firework {
    /// Helper method that return spark view and corresponding trajectory.
    func spark(at index: Int) -> FireworkSpark {
        return FireworkSpark(sparkView(at: index), trajectory(at: index))
    }
}
