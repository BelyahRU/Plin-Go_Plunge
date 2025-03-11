
import SpriteKit
import UIKit
import SpriteKit

enum Positions {
    case left
    case right
    case up
    case down
}

final class DraggingBlock: SKSpriteNode {
    
    // Basic adjacent blocks
    var left: SKSpriteNode?
    var right: SKSpriteNode?
    var up: SKSpriteNode?
    var down: SKSpriteNode?
    
    // Additional parameters for triple/quad blocks
    var leftDown: SKSpriteNode?
    var leftUp: SKSpriteNode?
    var rightUp: SKSpriteNode?
    var rightDown: SKSpriteNode?
    
    // MARK: - Initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GameScene
final class GameScene: SKScene {
    // Game State
    let currentLevel: Int
    var isWin = false
    
    // Nodes and collections
    var arrows: [SKSpriteNode] = []
    //    var startArrows: [SKSpriteNode] = []
    var startArrows: [DraggingBlock] = []
    var usedBlocks: [SKSpriteNode] = []
    var usedStartBlocksCount = 0
    var gameBoard: SKSpriteNode!
    
    // Touch handling
    //    var draggingBlock: SKSpriteNode?
    
    var draggingBlock: DraggingBlock?
    var originalPosition: CGPoint?
    
    // Timer and label
    var timerLabel: SKLabelNode!
    let timerManager: TimerManager
    var levelSetupManager: LevelSetupManager!
    
    init(level: Int) {
        self.currentLevel = level
        self.timerManager = TimerManager(timeOfLevel: 120)
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        configureScene()
        configureSnowBottom()
        configureLevelLabel()
        levelSetupManager = LevelSetupManager(scene: self)
        levelSetupManager.setupLevel(currentLevel)
        setupTimer()
        addTimerLabel()
    }
    
    private func configureScene() {
        backgroundColor = .clear
    }
    
    private func configureSnowBottom() {
        let bottomViewHeight: CGFloat = 220
        let bottomView = SKSpriteNode(imageNamed: "snowBottomImage")
        bottomView.size = CGSize(width: size.width + 60, height: bottomViewHeight)
        bottomView.position = CGPoint(x: size.width / 2, y: bottomViewHeight / 2)
        bottomView.zPosition = 1.2
        addChild(bottomView)
    }
    
    private func configureLevelLabel() {
        let lvlView = SKSpriteNode(imageNamed: "lvlLabel\(currentLevel)")
        lvlView.size = CGSize(width: 124, height: 96)
        lvlView.position = CGPoint(x: size.width / 2, y: 220)
        lvlView.zPosition = 1.0
        addChild(lvlView)
    }
    
    private func setupTimer() {
        timerManager.onTick = { [weak self] remaining in
            self?.updateTimerLabel(with: remaining)
        }
        timerManager.onTimeout = { [weak self] in
            self?.endGameDueToTimeout()
        }
        timerManager.start()
    }
    
    private func addTimerLabel() {
        timerLabel = SKLabelNode(text: "Time: \(timerManager.remainingTime)s")
        timerLabel.fontName = "Kavoon-Regular"
        timerLabel.fontSize = 33
        timerLabel.fontColor = UIColor(red: 32/255.0, green: 102/255.0, blue: 173/255.0, alpha: 1)
        timerLabel.position = CGPoint(x: size.width / 2, y: 150)
        timerLabel.zPosition = 2
        addChild(timerLabel)
    }
    
    private func updateTimerLabel(with time: Int) {
        timerLabel.text = "Time: \(time)s"
    }
    
    private func endGameDueToTimeout() {
        if usedStartBlocksCount != startArrows.count && !isWin {
            timerManager.stop()
            print("Игра завершена по истечении времени!")
            isPaused = true
            NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil)
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for arrow in arrows {
            if arrow.contains(location) { return }
        }
        
        for startArrow in startArrows {
            if startArrow.contains(location) {
                draggingBlock = startArrow
                draggingBlock?.alpha = 0.8
                if startArrow.name?.contains("Two") == true || startArrow.name?.contains("Four") == true {
                    draggingBlock?.size = CGSize(width: startArrow.size.width * 2,
                                                 height: startArrow.size.height * 2)
                }
                originalPosition = startArrow.position
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let draggingBlock = draggingBlock else { return }
        draggingBlock.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let draggingBlock = draggingBlock else { return }
        draggingBlock.removeFromParent()
        let location = touches.first!.location(in: self)
        if draggingBlock.name!.contains("Four") {
            getBlocksInArea(draggingBlock: draggingBlock)
            print(draggingBlock.leftUp, draggingBlock.leftDown, draggingBlock.rightUp, draggingBlock.rightDown)
            updateNames()
            var changed = false
            if let leftUp = draggingBlock.leftUp {
                for i in arrows {
                    if i == leftUp {
                        i.name = leftUp.name
                        i.texture = SKTexture(imageNamed: leftUp.name!)
                        changed = true
                    }
                }
            }
            if let leftDown = draggingBlock.leftDown {
                for i in arrows {
                    if i == leftDown {
                        i.name = leftDown.name
                        i.texture = SKTexture(imageNamed: leftDown.name!)
                        changed = true
                    }
                }
            }
            if let rightUp = draggingBlock.rightUp {
                for i in arrows {
                    if i == rightUp {
                        i.name = rightUp.name
                        i.texture = SKTexture(imageNamed: rightUp.name!)
                        changed = true
                    }
                }
            }
            if let rightDown = draggingBlock.rightDown {
                for i in arrows {
                    if i == rightDown {
                        i.name = rightDown.name
                        i.texture = SKTexture(imageNamed: rightDown.name!)
                        changed = true
                    }
                }
            }
            if changed == true {
                usedStartBlocksCount += 1
                self.draggingBlock = nil
                originalPosition = nil
            }
        } else if draggingBlock.name?.contains("Two") == true {
            getBlocksInArea(draggingBlock: draggingBlock)
            updateNames()
            var changed = false
            if draggingBlock.name!.contains("Horizontal") {
                if let left = draggingBlock.left {
                    for i in arrows {
                        if i == left {
                            i.name = left.name
                            i.texture = SKTexture(imageNamed: left.name!)
                            changed = true
                        }
                    }
                }
                if let right = draggingBlock.right {
                    for i in arrows {
                        if i == right {
                            i.name = right.name
                            i.texture = SKTexture(imageNamed: right.name!)
                            changed = true
                        }
                    }
                }
            } else if draggingBlock.name!.contains("Vertical") {
                if let up = draggingBlock.up {
                    for i in arrows {
                        if i == up {
                            i.name = up.name
                            i.texture = SKTexture(imageNamed: up.name!)
                            changed = true
                        }
                    }
                }
                if let down = draggingBlock.down {
                    for i in arrows {
                        if i == down {
                            i.name = down.name
                            i.texture = SKTexture(imageNamed: down.name!)
                            changed = true
                        }
                    }
                }
                
            }
            if changed == true {
                usedStartBlocksCount += 1
                self.draggingBlock = nil
                originalPosition = nil
            }
        } else {
            for arrow in arrows {
                if arrow.contains(location) {
                    if let newName = updateNameArrow(gameArrow: arrow, gameBlock: draggingBlock) {
                        arrow.texture = SKTexture(imageNamed: newName)
                        arrow.name = newName
                        usedBlocks.append(draggingBlock)
                        usedStartBlocksCount += 1
                    }
                    self.draggingBlock = nil
                    originalPosition = nil
                }
            }
        }
        if let originalPosition = originalPosition {
            draggingBlock.position = originalPosition
            let size = draggingBlock.size
            draggingBlock.size = CGSize(width: 74, height: 74)
            draggingBlock.alpha = 1
            addChild(draggingBlock)
        }
        
        self.draggingBlock = nil
        originalPosition = nil
        
        checkWinCondition()
        checkLoseCondition()
        
    }
    
    func getBlocksInArea(draggingBlock: DraggingBlock)  {
        let minX = draggingBlock.position.x - draggingBlock.frame.size.width / 4
        let maxX = draggingBlock.position.x + draggingBlock.frame.size.width / 4
        let minY = draggingBlock.position.y - draggingBlock.frame.size.height / 8
        let maxY = draggingBlock.position.y + draggingBlock.frame.size.height / 8
        
        var blocksInArea: [(block: SKSpriteNode, intersectionArea: CGFloat)] = []
        
        // Собираем блоки, пересекающиеся с областью draggingBlock
        for block in arrows {
            let blockMinX = block.position.x - block.frame.size.width / 2
            let blockMaxX = block.position.x + block.frame.size.width / 2
            let blockMinY = block.position.y - block.frame.size.height / 2
            let blockMaxY = block.position.y + block.frame.size.height / 2
            
            if maxX > blockMinX && minX < blockMaxX && maxY > blockMinY && minY < blockMaxY {
                let intersectionRect = CGRect(
                    x: max(minX, blockMinX),
                    y: max(minY, blockMinY),
                    width: min(maxX, blockMaxX) - max(minX, blockMinX),
                    height: min(maxY, blockMaxY) - max(minY, blockMinY)
                )
                let intersectionArea = intersectionRect.width * intersectionRect.height
                blocksInArea.append((block, intersectionArea))
            }
        }
        
        // Определяем положение блоков относительно draggingBlock
        if draggingBlock.name!.contains("Horizontal") {
            for (block, _) in blocksInArea {
                let dx = block.position.x - draggingBlock.position.x
                if abs(dx) < 50 {
                    if dx < 0 {
                        draggingBlock.left = block
                    } else {
                        draggingBlock.right = block
                    }
                }
            }
        } else if draggingBlock.name!.contains("Vertical") {
            for (block, _) in blocksInArea {
                let dy = block.position.y - draggingBlock.position.y
                if dy < 0 {
                    draggingBlock.down = block
                } else {
                    draggingBlock.up = block
                }
            }
        } else if draggingBlock.name!.contains("Four") {
            // Для блока типа "Four" распределяем по четырем сторонам
            for (block, _) in blocksInArea {
                let dx = block.position.x - draggingBlock.position.x
                let dy = block.position.y - draggingBlock.position.y
                
                if dx < 0 && dy > 0 {
                    draggingBlock.leftUp = block
                } else if dx > 0 && dy > 0 {
                    draggingBlock.rightUp = block
                } else if dx < 0 && dy < 0 {
                    draggingBlock.leftDown = block
                } else if dx > 0 && dy < 0 {
                    draggingBlock.rightDown = block
                }
            }
        } else if draggingBlock.name!.contains("Four") {
            for (block, _) in blocksInArea {
                let dx = block.position.x - draggingBlock.position.x
                let dy = block.position.y - draggingBlock.position.y
                
                if dx < 0 && dy > 0 {
                    draggingBlock.leftUp = block
                } else if dx > 0 && dy > 0 {
                    draggingBlock.rightUp = block
                } else if dx < 0 && dy < 0 {
                    draggingBlock.leftDown = block
                } else if dx > 0 && dy < 0 {
                    draggingBlock.rightDown = block
                }
            }
        }
    }
    
    
    
    func checkLoseCondition() {
        if usedStartBlocksCount == startArrows.count && !isWin {
            print("Lose!")
            timerManager.stop()
            isPaused = true
            NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil)
        }
    }
    
    func checkWinCondition() {
        let angles = arrows.compactMap { AngleHelper.extractAngle(from: $0.name ?? "") }
        print(angles)
        if angles.count == arrows.count && angles.allSatisfy({ $0 == angles.first }) {
            isWin = true
            timerManager.stop()
            isPaused = true
            let time = timerManager.timeOfLevel - timerManager.remainingTime
            print("Win!")
            NotificationCenter.default.post(name: NSNotification.Name("Win"), object: time)
        }
    }
    
    func updateNameArrow(gameArrow: SKSpriteNode, gameBlock: SKSpriteNode) -> String? {
        let arrowName = gameArrow.name ?? "nothing"
        if let arrowDegree = AngleHelper.extractAngle(from: arrowName) {
            if gameBlock.name == "rotateRightOneBlock90" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 90)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateOneBlock180" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 180)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateLeftOneBlock90" {
                let newValue = AngleHelper.subtractAngle(angle1: arrowDegree, angle2: 90)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateRightOneBlock45" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 45)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateRightOneBlock135" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 135)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateLeftOneBlock45" {
                let newValue = AngleHelper.subtractAngle(angle1: arrowDegree, angle2: 45)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            }
        }
        return nil
    }
    
    
    func updateNames() {
        guard let _ = draggingBlock else { return }
        if draggingBlock!.name!.contains("Four") {
            if draggingBlock!.name == "rotateFourBlocks90_90_90_90" {
                if let leftUp = draggingBlock!.leftUp {
                    let arrowDegree = AngleHelper.extractAngle(from: leftUp.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.leftUp!.name! = leftUp.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                if let leftDown = draggingBlock!.leftDown {
                    let arrowDegree = AngleHelper.extractAngle(from: leftDown.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.leftDown!.name! = leftDown.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                
                if let rightUp = draggingBlock!.rightUp {
                    let arrowDegree = AngleHelper.extractAngle(from: rightUp.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.rightUp!.name! = rightUp.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                
                if let rightDown = draggingBlock!.rightDown {
                    let arrowDegree = AngleHelper.extractAngle(from: rightDown.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.rightDown!.name! = rightDown.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
            }
        } else if draggingBlock!.name!.contains("Horizontal") {
            if draggingBlock!.name == "rotateTwoBlocksHorizontal_45_135" {
                if let left = draggingBlock!.left {
                    let arrowDegree = AngleHelper.extractAngle(from: left.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 45)
                    draggingBlock!.left!.name! = left.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                if let right = draggingBlock!.right {
                    let arrowDegree = AngleHelper.extractAngle(from: right.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 135)
                    draggingBlock!.right!.name! = right.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                    
                }
            } else if  draggingBlock!.name == "rotateRightTwoHorizontalBlocks90" {
                if let left = draggingBlock!.left {
                    let arrowDegree = AngleHelper.extractAngle(from: left.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.left!.name! = left.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                if let right = draggingBlock!.right {
                    let arrowDegree = AngleHelper.extractAngle(from: right.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.right!.name! = right.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                    print(right.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)"))
                    
                }
            }else if  draggingBlock!.name == "rotateTwoBlocksHorizontal_90_45" {
                if let left = draggingBlock!.left {
                    let arrowDegree = AngleHelper.extractAngle(from: left.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.left!.name! = left.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                if let right = draggingBlock!.right {
                    let arrowDegree = AngleHelper.extractAngle(from: right.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 45)
                    draggingBlock!.right!.name! = right.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
            } else if draggingBlock!.name ==  "rotateTwoBlocksHorizontal_180_45" {
                if let left = draggingBlock!.left {
                    let arrowDegree = AngleHelper.extractAngle(from: left.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 180)
                    draggingBlock!.left!.name! = left.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                if let right = draggingBlock!.right {
                    let arrowDegree = AngleHelper.extractAngle(from: right.name ?? "nothing")
                    let newValue = AngleHelper.calculateAngle(angle1: arrowDegree ?? 90, angle2: 45)
                    draggingBlock!.right!.name! = right.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
            }
        }else if draggingBlock!.name!.contains("Vertical") {
            if draggingBlock!.name == "rotateLeftTwoVerticalBlocks90" {
                if let up = draggingBlock!.up {
                    let arrowDegree = AngleHelper.extractAngle(from: up.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.up!.name! = up.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                    print(up.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)"))
                }
                if let down = draggingBlock!.down {
                    let arrowDegree = AngleHelper.extractAngle(from: down.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 90)
                    draggingBlock!.down!.name! = down.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                    print(down.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)"))
                    
                }
            } else if draggingBlock!.name == "rotateLeftTwoVerticalBlocks45" {
                if let up = draggingBlock!.up {
                    let arrowDegree = AngleHelper.extractAngle(from: up.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 45)
                    draggingBlock!.up!.name! = up.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                }
                if let down = draggingBlock!.down {
                    let arrowDegree = AngleHelper.extractAngle(from: down.name ?? "nothing")
                    let newValue = AngleHelper.subtractAngle(angle1: arrowDegree ?? 90, angle2: 45)
                    draggingBlock!.down!.name! = down.name!.replacingOccurrences(of: "\(arrowDegree ?? 90)", with: "\(newValue)")
                    
                }
            }
        }
        
    }
    
}
