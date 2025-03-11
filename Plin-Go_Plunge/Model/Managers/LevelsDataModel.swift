
import Foundation

//MARK: - Levels
final class LevelsDataModel {
    static let shared = LevelsDataModel()
    
    private let total = 15
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    public var levelsArray: [String: Bool] {
        get {
            if let savedLevels = userDefaults.dictionary(forKey: "levelsKey") as? [String: Bool] {
                return savedLevels
            } else {
                var defaultLevels = [String: Bool]()
                for i in 1...total {
                    if i == 1 {
                        defaultLevels[String(i)] = true
                    } else {
                        defaultLevels[String(i)] = false
                    }
                }
                return defaultLevels
            }
        }
        set {
            userDefaults.set(newValue, forKey: "levelsKey")
        }
    }
    
    public func isUnlocked(_ level: Int) -> Bool {
        if level >= 1 && level <= 15 {
            return levelsArray[String(level)] ?? false
        }
        
        return false
    }
    
    
    
    public func unlock(level: Int) {
        if level >= 1 && level <= 15 {
            levelsArray[String(level)] = true
        }
    }
}

