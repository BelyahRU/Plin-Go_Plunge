
import SpriteKit
import UIKit

// MARK: - TimerManager
final class TimerManager {
    private var timer: Timer?
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

// MARK: - LevelSetupManager
final class LevelSetupManager {
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func setupLevel(_ level: Int) {
        switch level {
        case 1: setup1Level()
        case 2: setup2Level()
        case 3: setup3Level()
        case 4: setup4Level()
        case 5: setup5Level()
        case 6: setup6Level()
        case 7: setup7Level()
        case 8: setup8Level()
        case 9: setup9Level()
        case 10: setup10Level()
        case 11: setup11Level()
        case 12: setup12Level()
        default: setup1Level()
        }
    }
    
    // Common methods
    private func setupGameBoard(position: CGPoint, size: CGSize) {
        scene.gameBoard = SKSpriteNode(imageNamed: "gameBoard\(scene.currentLevel)")
        scene.gameBoard.size = size
        scene.gameBoard.position = position
        scene.gameBoard.zPosition = 2
        scene.addChild(scene.gameBoard)
    }
    
    private func addGameBlocks(count: Int, positions: [CGPoint], images: [String]) {
        for i in 0..<count {
            let startBlockBack = SKSpriteNode(imageNamed: "startBlockImage")
            startBlockBack.size = CGSize(width: 74, height: 74)
            startBlockBack.position = positions[i]
            startBlockBack.zPosition = 2
            
            let startBlock = SKSpriteNode(imageNamed: images[i])
            startBlock.size = CGSize(width: 74, height: 74)
            startBlock.position = positions[i]
            startBlock.name = images[i]
            startBlock.zPosition = 4
            scene.addChild(startBlockBack)
            scene.addChild(startBlock)
            scene.startArrows.append(startBlock)
        }
    }
    
    private func setupGameArrows(count: Int, positions: [CGPoint], images: [String]) {
        for i in 0..<count {
            let gameArrow = SKSpriteNode(imageNamed: images[i])
            gameArrow.size = CGSize(width: 77, height: 77)
            gameArrow.position = positions[i]
            gameArrow.name = images[i]
            gameArrow.zPosition = 3
            scene.addChild(gameArrow)
            scene.arrows.append(gameArrow)
        }
    }
    
    // Level-specific setups
    private func setup1Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 174, height: 343)
        )
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock90",
                        "rotateRightOneBlock90"
                      ])
        setupGameArrows(count: 3,
                        positions: [
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y + 70),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y - 70)
                        ],
                        images: [
                            "red90Arrow",
                            "pink0Arrow",
                            "yellow0Arrow"
                        ])
    }
    
    private func setup2Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 250, height: 146)
        )
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock90",
                        "rotateOneBlock180"
                      ])
        setupGameArrows(count: 2,
                        positions: [
                            CGPoint(x: scene.size.width / 2 - 38, y: scene.gameBoard.position.y),
                            CGPoint(x: scene.size.width / 2 + 38, y: scene.gameBoard.position.y)
                        ],
                        images: [
                            "pink0Arrow",
                            "green90Arrow"
                        ])
    }
    
    private func setup3Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 230, height: 227)
        )
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightTwoHorizontalBlocks90",
                        "rotateLeftTwoVerticalBlocks90"
                      ])
        setupGameArrows(count: 3,
                        positions: [
                            CGPoint(x: scene.size.width / 2 - 38, y: scene.gameBoard.position.y + 45),
                            CGPoint(x: scene.size.width / 2 + 38, y: scene.gameBoard.position.y + 45),
                            CGPoint(x: scene.size.width / 2 + 38, y: scene.gameBoard.position.y - 28)
                        ],
                        images: [
                            "red0Arrow",
                            "orange90Arrow",
                            "green180Arrow"
                        ])
    }
    
    private func setup4Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 343 / 1.3, height: 259 / 1.3)
        )
        addGameBlocks(count: 3,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateLeftOneBlock90",
                        "rotateOneBlock180",
                        "rotateRightOneBlock90"
                      ])
        setupGameArrows(count: 3,
                        positions: [
                            CGPoint(x: scene.size.width / 2 - 67, y: scene.gameBoard.position.y + 38),
                            CGPoint(x: scene.size.width / 2 + 67, y: scene.gameBoard.position.y + 38),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y - 33)
                        ],
                        images: [
                            "red270Arrow",
                            "yellow0Arrow",
                            "pink90Arrow"
                        ])
    }
    
    private func setup5Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 343 / 1.3, height: 174 / 1.3)
        )
        addGameBlocks(count: 3,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock135",
                        "rotateRightOneBlock90",
                        "rotateRightOneBlock45"
                      ])
        setupGameArrows(count: 3,
                        positions: [
                            CGPoint(x: scene.size.width / 2 - 67, y: scene.gameBoard.position.y + 5),
                            CGPoint(x: scene.size.width / 2 + 67, y: scene.gameBoard.position.y + 5),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y + 5)
                        ],
                        images: [
                            "orange315Arrow",
                            "yellow225Arrow",
                            "green270Arrow"
                        ])
    }
    
    private func setup6Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 299 / 1.3, height: 175 / 1.3)
        )
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock45",
                        "rotateLeftOneBlock45"
                      ])
        setupGameArrows(count: 2,
                        positions: [
                            CGPoint(x: scene.size.width / 2 + 72 / 2, y: scene.gameBoard.position.y + 5),
                            CGPoint(x: scene.size.width / 2 - 72 / 2, y: scene.gameBoard.position.y + 5)
                        ],
                        images: [
                            "green45Arrow",
                            "red315Arrow"
                        ])
    }
    
    private func setup7Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 259 / 1.3, height: 343 / 1.3)
        )
        addGameBlocks(count: 3,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock135",
                        "rotateLeftOneBlock45",
                        "rotateRightOneBlock45"
                      ])
        setupGameArrows(count: 3,
                        positions: [
                            CGPoint(x: scene.size.width / 2 - 35, y: scene.gameBoard.position.y - 65),
                            CGPoint(x: scene.size.width / 2 + 40, y: scene.gameBoard.position.y + 5),
                            CGPoint(x: scene.size.width / 2 - 35, y: scene.gameBoard.position.y + 65)
                        ],
                        images: [
                            "green45Arrow",
                            "red315Arrow",
                            "orange135Arrow"
                        ])
    }
    
    private func setup8Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 174 / 1.3, height: 343 / 1.3)
        )
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateOneBlock180",
                        "rotateLeftOneBlock90"
                      ])
        setupGameArrows(count: 3,
                        positions: [
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y - 65),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y + 5),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y + 75)
                        ],
                        images: [
                            "yellow0Arrow",
                            "pink270Arrow",
                            "red180Arrow"
                        ])
    }
    
    private func setup9Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 342 / 1.3, height: 259 / 1.3)
        )
        addGameBlocks(count: 3,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateTwoBlocksHorizontal_45_135",
                        "rotateRightOneBlock90",
                        "rotateLeftTwoVerticalBlocks45"
                      ])
        setupGameArrows(count: 5,
                        positions: [
                            CGPoint(x: scene.size.width / 2 + 74, y: scene.gameBoard.position.y - 42),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y + 30),
                            CGPoint(x: scene.size.width / 2 + 74, y: scene.gameBoard.position.y + 30),
                            CGPoint(x: scene.size.width / 2 - 74, y: scene.gameBoard.position.y + 30),
                            CGPoint(x: scene.size.width / 2 - 74, y: scene.gameBoard.position.y - 42)
                        ],
                        images: [
                            "yellow45Arrow",
                            "red225Arrow",
                            "green45Arrow",
                            "orange315Arrow",
                            "pink270Arrow"
                        ])
    }
    
    private func setup10Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 299 / 1.3, height: 175 / 1.3)
        )
        addGameBlocks(count: 3,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock135",
                        "rotateOneBlock180",
                        "rotateTwoBlocksHorizontal_90_45"
                      ])
        setupGameArrows(count: 2,
                        positions: [
                            CGPoint(x: scene.size.width / 2 + 72 / 2, y: scene.gameBoard.position.y + 5),
                            CGPoint(x: scene.size.width / 2 - 72 / 2, y: scene.gameBoard.position.y + 5)
                        ],
                        images: [
                            "pink0Arrow",
                            "orange180Arrow"
                        ])
    }
    
    private func setup11Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 342 / 1.3, height: 272 / 1.3)
        )
        addGameBlocks(count: 4,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 + 87 / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock90",
                        "rotateRightOneBlock135",
                        "rotateOneBlock180",
                        "rotateRightOneBlock45"
                      ])
        setupGameArrows(count: 4,
                        positions: [
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y + 35),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y - 35),
                            CGPoint(x: scene.size.width / 2 - 75, y: scene.gameBoard.position.y + 35),
                            CGPoint(x: scene.size.width / 2 + 75, y: scene.gameBoard.position.y - 35)
                        ],
                        images: [
                            "green225Arrow",
                            "pink0Arrow",
                            "orange315Arrow",
                            "yellow270Arrow"
                        ])
    }
    
    private func setup12Level() {
        setupGameBoard(
            position: CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 342 / 1.3, height: 272 / 1.3)
        )
        addGameBlocks(count: 4,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87 / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 + 87 / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock90",
                        "rotateRightOneBlock135",
                        "rotateOneBlock180",
                        "rotateRightOneBlock45"
                      ])
        setupGameArrows(count: 4,
                        positions: [
                            CGPoint(x: scene.size.width / 2 - 75, y: scene.gameBoard.position.y - 35),
                            CGPoint(x: scene.size.width / 2, y: scene.gameBoard.position.y - 35),
                            CGPoint(x: scene.size.width / 2 - 75, y: scene.gameBoard.position.y + 35),
                            CGPoint(x: scene.size.width / 2 + 75, y: scene.gameBoard.position.y - 35)
                        ],
                        images: [
                            "pink315Arrow",
                            "red135Arrow",
                            "orange0Arrow",
                            "yellow0Arrow"
                        ])
    }
}

// MARK: - GameScene
final class GameScene: SKScene {
    // Game State
    let currentLevel: Int
    var isWin = false
    
    // Nodes and collections
    var arrows: [SKSpriteNode] = []
    var startArrows: [SKSpriteNode] = []
    var usedBlocks: [SKSpriteNode] = []
    var usedStartBlocksCount = 0
    var gameBoard: SKSpriteNode!
    
    // Touch handling
    var draggingBlock: SKSpriteNode?
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
                if startArrow.name?.contains("Two") == true {
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
        
        if draggingBlock.name?.contains("Two") == true {
            var blocksInArea: [SKSpriteNode] = []
            if draggingBlock.name?.contains("Horizontal") == true {
                blocksInArea = getBlocksInArea(draggingBlock: draggingBlock, count: 2, alignment: "Horizontal")
            } else {
                blocksInArea = getBlocksInArea(draggingBlock: draggingBlock, count: 2, alignment: "Vertical")
            }
            if blocksInArea.count == 2 {
                if draggingBlock.name?.contains("_") == true && draggingBlock.name?.contains("Horizontal") == true {
                    if let newNames = updateTwoNames(gameArrows: blocksInArea, gameBlock: draggingBlock) {
                        blocksInArea[0].texture = SKTexture(imageNamed: newNames[0])
                        blocksInArea[0].name = newNames[0]
                        usedBlocks.append(blocksInArea[0])
                        blocksInArea[1].texture = SKTexture(imageNamed: newNames[1])
                        blocksInArea[1].name = newNames[1]
                        usedBlocks.append(blocksInArea[1])
                    }
                } else {
                    for block in blocksInArea {
                        if let newName = updateNameArrow(gameArrow: block, gameBlock: draggingBlock) {
                            block.texture = SKTexture(imageNamed: newName)
                            block.name = newName
                            usedBlocks.append(block)
                        }
                    }
                }
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
            draggingBlock.size = CGSize(width: size.width / 2, height: size.height / 2)
            draggingBlock.alpha = 1
            addChild(draggingBlock)
        }
        
        self.draggingBlock = nil
        originalPosition = nil
        
        checkWinCondition()
        checkLoseCondition()
    }
    
    func getBlocksInArea(draggingBlock: SKSpriteNode, count: Int, alignment: String) -> [SKSpriteNode] {
        let minX = draggingBlock.position.x - draggingBlock.frame.size.width / 4
        let maxX = draggingBlock.position.x + draggingBlock.frame.size.width / 4
        let minY = draggingBlock.position.y - draggingBlock.frame.size.height / 4
        let maxY = draggingBlock.position.y + draggingBlock.frame.size.height / 4
        
        var blocksInArea: [(block: SKSpriteNode, intersectionArea: CGFloat)] = []
        
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
        
        var groupedBlocks: [CGFloat: [SKSpriteNode]] = [:]
        if alignment == "Vertical" {
            for (block, _) in blocksInArea {
                let key = block.position.y
                groupedBlocks[key, default: []].append(block)
            }
        } else if alignment == "Horizontal" {
            for (block, _) in blocksInArea {
                let key = block.position.x
                groupedBlocks[key, default: []].append(block)
            }
        }
        
        var filteredBlocks: [SKSpriteNode] = []
        for (_, group) in groupedBlocks {
            if group.count >= 1 {
                filteredBlocks.append(contentsOf: group)
            }
        }
        
        let sortedBlocks = blocksInArea.filter { filteredBlocks.contains($0.block) }
            .sorted { $0.intersectionArea > $1.intersectionArea }
        
        var array = Array(sortedBlocks.prefix(count).map { $0.block })
        if draggingBlock.name?.contains("_") == true && draggingBlock.name?.contains("Horizontal") == true {
            array.sort { $0.position.x < $1.position.x }
        }
        return array
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
        var arrowName = gameArrow.name ?? "nothing"
        if let arrowDegree = AngleHelper.extractAngle(from: arrowName) {
            if gameBlock.name == "rotateRightOneBlock90" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 90)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateOneBlock180" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 180)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateRightTwoHorizontalBlocks90" {
                let newValue = AngleHelper.calculateAngle(angle1: arrowDegree, angle2: 90)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            } else if gameBlock.name == "rotateLeftTwoVerticalBlocks90" {
                let newValue = AngleHelper.subtractAngle(angle1: arrowDegree, angle2: 90)
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
            } else if gameBlock.name == "rotateLeftTwoVerticalBlocks45" {
                let newValue = AngleHelper.subtractAngle(angle1: arrowDegree, angle2: 45)
                return arrowName.replacingOccurrences(of: "\(arrowDegree)", with: "\(newValue)")
            }
        }
        return nil
    }
    
    func updateTwoNames(gameArrows: [SKSpriteNode], gameBlock: SKSpriteNode) -> [String]? {
        var arrowNames: [String] = []
        var arrowDegrees: [Int?] = []
        for arrow in gameArrows {
            arrowNames.append(arrow.name ?? "nothing")
            arrowDegrees.append(AngleHelper.extractAngle(from: arrow.name ?? "nothing"))
        }
        if gameBlock.name == "rotateTwoBlocksHorizontal_45_135" {
            let newValue = AngleHelper.calculateAngle(angle1: arrowDegrees[0]!, angle2: 45)
            arrowNames[0] = arrowNames[0].replacingOccurrences(of: "\(arrowDegrees[0]!)", with: "\(newValue)")
            let newValue2 = AngleHelper.calculateAngle(angle1: arrowDegrees[1]!, angle2: 135)
            arrowNames[1] = arrowNames[1].replacingOccurrences(of: "\(arrowDegrees[1]!)", with: "\(newValue2)")
            return arrowNames
        } else if gameBlock.name == "rotateTwoBlocksHorizontal_90_45" {
            let newValue = AngleHelper.calculateAngle(angle1: arrowDegrees[0]!, angle2: 90)
            arrowNames[0] = arrowNames[0].replacingOccurrences(of: "\(arrowDegrees[0]!)", with: "\(newValue)")
            let newValue2 = AngleHelper.subtractAngle(angle1: arrowDegrees[1]!, angle2: 45)
            arrowNames[1] = arrowNames[1].replacingOccurrences(of: "\(arrowDegrees[1]!)", with: "\(newValue2)")
            return arrowNames
        }
        return nil
    }
}
