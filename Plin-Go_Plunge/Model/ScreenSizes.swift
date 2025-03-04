
import Foundation
import UIKit

final class ScreenSizes {
    
    static let screenSize = CGSize(width: UIScreen.main.bounds.width,
                                   height: UIScreen.main.bounds.height)
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let isSmallScreen = UIScreen.main.bounds.height < 700
    
}

