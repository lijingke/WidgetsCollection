import UIKit

public class FireworkSparkScheduler {
    public var delay: TimeInterval = 0.05
    private var timer: Timer?
    private var queue = [Data]()

    private struct Data {
        weak var presenterView: UIView?
        let sparks: [FireworkSpark]
        let animator: SparkViewAnimator
        let animationDuration: TimeInterval
    }

    public func schedule(sparks: [FireworkSpark],
                         in presenterView: UIView,
                         with animator: SparkViewAnimator,
                         animationDuration: TimeInterval)
    {
        let data = Data(presenterView: presenterView,
                        sparks: sparks,
                        animator: animator,
                        animationDuration: animationDuration)

        queue.append(data)

        if timer == nil {
            scheduleTimer()
        }
    }

    public func cancel() {
        timer?.invalidate()
        timer = nil
    }

    private func scheduleTimer() {
        cancel()

        timer = Timer.scheduledTimer(timeInterval: delay,
                                     target: self,
                                     selector: #selector(timerDidFire),
                                     userInfo: nil, repeats: false)
    }

    @objc private func timerDidFire() {
        guard let data = queue.first else {
            cancel()
            return
        }

        guard let presenterView = data.presenterView else {
            cancel()
            return
        }

        for spark in data.sparks {
            presenterView.addSubview(spark.sparkView)
            data.animator.animate(spark: spark, duration: data.animationDuration)
        }

        queue.remove(at: 0)

        if queue.isEmpty {
            cancel()
        } else {
            scheduleTimer()
        }
    }
}
