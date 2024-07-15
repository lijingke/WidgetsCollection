import UIKit

public class FountainFirework: Firework {
    /**
       x   x x  x x
          x   x x
        x   x    x
         x x x x
          x x x
           x x
            x
            x
      -------------
     **/

    public var origin: CGPoint
    public var scale: CGFloat
    public var sparkSize: CGSize

    public var maxChangeValue: Int {
        return 10
    }

    public var trajectoryFactory: SparkTrajectoryFactory {
        return FountainSparkTrajectoryFactory()
    }

    private var defaultTrajectoryFactory: DefaultSparkTrajectoryFactory {
        return trajectoryFactory as! DefaultSparkTrajectoryFactory
    }

    public var sparkViewFactory: SparkViewFactory {
        return CircleColorSparkViewFactory()
    }

    public init(origin: CGPoint, sparkSize: CGSize, scale: CGFloat) {
        self.origin = origin
        self.sparkSize = sparkSize
        self.scale = scale
    }

    public func sparkViewFactoryData(at index: Int) -> SparkViewFactoryData {
        return DefaultSparkViewFactoryData(size: sparkSize, index: index)
    }

    public func sparkView(at index: Int) -> SparkView {
        return sparkViewFactory.create(with: sparkViewFactoryData(at: index))
    }

    public func trajectory(at _: Int) -> SparkTrajectory {
        return defaultTrajectoryFactory.random().scale(by: scale).shift(to: origin)
    }
}
