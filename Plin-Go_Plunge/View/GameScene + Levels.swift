
import SpriteKit

extension GameScene {
    
    func setupLevel() {
        switch currentLevel {
        case 1:
            setup1Level()
        case 2:
            setup2Level()
        case 3:
            setup3Level()
        default:
            setup1Level()
        }
    }
    
    //1
    private func setup1Level() {
        setupGameBoard(
            position: CGPoint(x: self.size.width / 2 , y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 174, height: 343))
        
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: self.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: self.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock90",
                        "rotateRightOneBlock90"
                      ])
        setupGameArrows(count: 3,
            positions: [
                CGPoint(x: self.size.width / 2, y: gameBoard.position.y + 70),
                CGPoint(x: self.size.width / 2, y: gameBoard.position.y),
                CGPoint(x: self.size.width / 2, y: gameBoard.position.y - 70)
            ], images: [
                "red90Arrow",
                "pink0Arrow",
                "yellow0Arrow"
            ])
    }
    
    //2
    func setup2Level() {
        setupGameBoard(
            position: CGPoint(x: self.size.width / 2 , y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 250, height: 146))
        
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: self.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: self.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightOneBlock90",
                        "rotateOneBlock180"
                      ])
        setupGameArrows(count: 2,
            positions: [
                CGPoint(x: self.size.width / 2 - 38, y: gameBoard.position.y),
                CGPoint(x: self.size.width / 2 + 38, y: gameBoard.position.y)
            ], images: [
                "pink0Arrow",
                "green90Arrow"
            ])
    }
    
    private func setup3Level() {
        setupGameBoard(
            position: CGPoint(x: self.size.width / 2 , y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380),
            size: CGSize(width: 230, height: 227))
        
        addGameBlocks(count: 2,
                      positions: [
                        CGPoint(x: self.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80),
                        CGPoint(x: self.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
                      ],
                      images: [
                        "rotateRightTwoHorizontalBlocks90",
                        "rotateLeftTwoVerticalBlocks90"
                      ])
        setupGameArrows(count: 3,
            positions: [
                CGPoint(x: self.size.width / 2 - 38, y: gameBoard.position.y + 45),
                CGPoint(x: self.size.width / 2 + 38, y: gameBoard.position.y + 45),
                CGPoint(x: self.size.width / 2 + 38, y: gameBoard.position.y - 28),
            ], images: [
                "red0Arrow",
                "orange90Arrow",
                "green180Arrow",
            ])
    }
    
    private func setupGameBoard(position: CGPoint, size: CGSize) {
        gameBoard = SKSpriteNode(imageNamed: "gameBoard\(currentLevel)")
        gameBoard.size = size
        gameBoard.position = position
        gameBoard.zPosition = 2
        
        addChild(gameBoard)
    }
    
    private func addGameBlocks(count: Int, positions: [CGPoint], images: [String]) {
        for i in 0...count-1 {
            let startBlockBack = SKSpriteNode(imageNamed: "startBlockImage")
            startBlockBack.size = CGSize(width: 74, height: 74)
            startBlockBack.position = positions[i]
            startBlockBack.zPosition = 2
            
            let startBlock = SKSpriteNode(imageNamed: images[i])
            startBlock.size = CGSize(width: 74, height: 74)
            startBlock.position = positions[i]
            startBlock.name = images[i]
            startBlock.zPosition = 4
            addChild(startBlockBack)
            addChild(startBlock)
            startArrows.append(startBlock)
        }
    }

    private func setupGameArrows(count: Int, positions: [CGPoint], images: [String]) {
        for i in 0...count-1 {
            let gameArrow = SKSpriteNode(imageNamed: images[i])
            gameArrow.size = CGSize(width: 77, height: 77)
            gameArrow.position = positions[i]
            gameArrow.name = images[i]
            gameArrow.zPosition = 3
            
            addChild(gameArrow)
            arrows.append(gameArrow)
        }
    }
}

