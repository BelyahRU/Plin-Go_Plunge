
import UIKit
import SpriteKit

// MARK: - TimerManager
final class TimerManager {
    var timer: Timer?
    private(set) var remainingTime: Int
    let timeOfLevel: Int
    var onTick: ((Int) -> Void)?
    var onTimeout: (() -> Void)?
    
    init(timeOfLevel: Int) {
        self.timeOfLevel = timeOfLevel
        self.remainingTime = timeOfLevel
    }
    
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                self.onTick?(self.remainingTime)
            } else {
                self.timer?.invalidate()
                self.onTimeout?()
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
    }
}
