
import SpriteKit
import UIKit


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
    
//    private func addGameBlocks(count: Int, positions: [CGPoint], images: [String]) {
//        for i in 0..<count {
////            let startBlockBack = SKSpriteNode(imageNamed: "startBlockImage")
////            startBlockBack.size = CGSize(width: 74, height: 74)
////            startBlockBack.position = positions[i]
////            startBlockBack.zPosition = 2
////            
////            let startBlock = SKSpriteNode(imageNamed: images[i])
////            startBlock.size = CGSize(width: 74, height: 74)
////            startBlock.position = positions[i]
////            startBlock.name = images[i]
////            startBlock.zPosition = 4
////            scene.addChild(startBlockBack)
////            scene.addChild(startBlock)
////            scene.startArrows.append(startBlock)
//            
//        }
//    }
    
    private func addGameBlocks(count: Int, positions: [CGPoint], images: [String]) {
        for i in 0..<count {
            let startBlockBack = SKSpriteNode(imageNamed: "startBlockImage")
            startBlockBack.size = CGSize(width: 74, height: 74)
            startBlockBack.position = positions[i]
            startBlockBack.zPosition = 2
            scene.addChild(startBlockBack)
            
            // Создаем стартовый блок как DraggingBlock
            let startBlock = DraggingBlock(
                texture: SKTexture(imageNamed: images[i]),
                color: .clear,
                size: CGSize(width: 74, height: 74)
            )
            startBlock.position = positions[i]
            startBlock.name = images[i]
            startBlock.zPosition = 4
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
        addGameBlocks(count: 3,
                      positions: [
                        CGPoint(x: scene.size.width / 2 + 87, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: scene.size.width / 2 - 87, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateTwoBlocksHorizontal_180_45",
                        "rotateRightOneBlock135",
                        "rotateFourBlocks90_90_90_90"
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
