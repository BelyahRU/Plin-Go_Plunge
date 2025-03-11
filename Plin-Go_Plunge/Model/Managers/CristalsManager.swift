
import Foundation

final class CristalsManager: ObservableObject {
    
    static let shared = CristalsManager()

    private let cristalKey = "cristalKey"
    
    public var currentCount: Int {
        return storedCristals
    }
    @Published private var storedCristals: Int {
        didSet {
            UserDefaults.standard.set(storedCristals, forKey: cristalKey)
        }
    }
    
    private init() {
        if UserDefaults.standard.object(forKey: cristalKey) == nil {
            self.storedCristals = 0
        } else {
            self.storedCristals = UserDefaults.standard.object(forKey: cristalKey) as! Int
        }
        
    }
    
    public func addCristals(_ count: Int) {
        storedCristals += count
    }
    
    public func subtractCristals(_ count: Int) -> Bool {
        if storedCristals >= count {
            storedCristals -= count
            return true
        } else {
            return false
        }
    }
}


