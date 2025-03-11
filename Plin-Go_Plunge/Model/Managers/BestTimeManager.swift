
import Foundation

final class BestTimeManager: ObservableObject {
    static let shared = BestTimeManager()
    
    private let bestTimesKey = "bestTimesKey"
    private var bestTimes: [Int] = []
    
    private init() {
        if let savedTimes = UserDefaults.standard.array(forKey: bestTimesKey) as? [Int],
           savedTimes.count == 15 {
            bestTimes = savedTimes
        } else {
            bestTimes = Array(repeating: 120, count: 15)
            UserDefaults.standard.set(bestTimes, forKey: bestTimesKey)
        }
    }
    
    func updateBestTime(for level: Int, with seconds: Int) {
        guard level >= 1 && level <= bestTimes.count else { return }
        
        if seconds < bestTimes[level - 1] {
            bestTimes[level - 1] = seconds
            UserDefaults.standard.set(bestTimes, forKey: bestTimesKey)
        }
    }
    
    func bestTime(for level: Int) -> Int? {
        guard level >= 1 && level <= bestTimes.count else { return nil }
        return bestTimes[level - 1]
    }
}
