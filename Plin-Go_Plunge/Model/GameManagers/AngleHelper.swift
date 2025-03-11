
import SpriteKit


// MARK: - AngleHelper
struct AngleHelper {
    static func calculateAngle(angle1: Int, angle2: Int) -> Int {
        var result = angle1 + angle2
        if result >= 360 {
            result -= 360
        } else if result < 0 {
            result += 360
        }
        return result
    }
    
    static func subtractAngle(angle1: Int, angle2: Int) -> Int {
        var result = angle1 - angle2
        if result >= 360 {
            result -= 360
        } else if result < 0 {
            result += 360
        }
        return result
    }
    
    static func extractAngle(from arrowName: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
        if let match = regex.firstMatch(in: arrowName, options: [], range: NSRange(location: 0, length: arrowName.count)) {
            let numberString = (arrowName as NSString).substring(with: match.range)
            return Int(numberString)
        }
        return nil
    }
}
