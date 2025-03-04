import SpriteKit

final class GameScene: SKScene {
    
    var currentLevel: Int
    var firstBlock: SKSpriteNode!
    var secondBlock: SKSpriteNode!
    var firstGameArrow: SKSpriteNode!
    var secondGameArrow: SKSpriteNode!
    var thirdGameArrow: SKSpriteNode!
    var gameBoard: SKSpriteNode!
    var draggingBlock: SKSpriteNode?
    var originalPosition: CGPoint?
    var isWin = false
    
    var firstGameArrowIsLocked = false
    var secondGameArrowIsLocked = false
    var thirdGameArrowIsLocked = false
    
    var usedBlocks: [SKSpriteNode] = []
    
    init(level: Int) {
        self.currentLevel = level
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        configureScene()
        configureSnowBottom()
        addGameBlocks()
        setupGameBoard()
        setupGameArrows()
    }
    
    func configureScene() {
        backgroundColor = .clear
    }
    
    func configureSnowBottom() {
        let bottomViewHeight: CGFloat = 220
        let bottomView = SKSpriteNode(imageNamed: "snowBottomImage")
        bottomView.size = CGSize(width: self.size.width+60, height: bottomViewHeight)
        bottomView.position = CGPoint(x: self.size.width / 2, y: bottomViewHeight / 2)
        bottomView.zPosition = 1
        
        addChild(bottomView)
    }
    
    func addGameBlocks() {
        let blockWidth: CGFloat = 74
        let startBlock1 = SKSpriteNode(imageNamed: "startBlockImage")
        startBlock1.size = CGSize(width: blockWidth, height: blockWidth)
        startBlock1.position = CGPoint(x: self.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
        startBlock1.zPosition = 2
        
        firstBlock = SKSpriteNode(imageNamed: "rotateRightOneBlock90")
        firstBlock.size = CGSize(width: blockWidth, height: blockWidth)
        firstBlock.position = CGPoint(x: self.size.width / 2 + 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
        firstBlock.name = "rotateRightOneBlock90"
        firstBlock.zPosition = 4
        addChild(startBlock1)
        addChild(firstBlock)
        
        let startBlock2 = SKSpriteNode(imageNamed: "startBlockImage")
        startBlock2.size = CGSize(width: blockWidth, height: blockWidth)
        startBlock2.position = CGPoint(x: self.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
        startBlock2.zPosition = 2
        
        secondBlock = SKSpriteNode(imageNamed: "rotateRightOneBlock90")
        secondBlock.size = CGSize(width: blockWidth, height: blockWidth)
        secondBlock.position = CGPoint(x: self.size.width / 2 - 87 / 2, y: ScreenSizes.isSmallScreen ? 120 : 80)
        secondBlock.name = "rotateRightOneBlock90"
        secondBlock.zPosition = 4
        
        addChild(startBlock2)
        addChild(secondBlock)
    }
    
    func setupGameBoard() {
        gameBoard = SKSpriteNode(imageNamed: "gameBoard\(currentLevel)")
        gameBoard.size = CGSize(width: 174, height: 343)
        gameBoard.position = CGPoint(x: self.size.width / 2 , y: ScreenSizes.isSmallScreen ? ScreenSizes.screenHeight - 120 : ScreenSizes.screenHeight - 380)
        gameBoard.zPosition = 2
        
        addChild(gameBoard)
    }
    
    func setupGameArrows() {
        firstGameArrow = SKSpriteNode(imageNamed: "red90Arrow")
        firstGameArrow.size = CGSize(width: 77, height: 77)
        firstGameArrow.position = CGPoint(x: self.size.width / 2, y: gameBoard.position.y + 70)
        firstGameArrow.name = "red90Arrow"
        firstGameArrow.zPosition = 3
        
        addChild(firstGameArrow)
        
        secondGameArrow = SKSpriteNode(imageNamed: "pink0Arrow")
        secondGameArrow.size = CGSize(width: 77, height: 77)
        secondGameArrow.name = "pink0Arrow"
        secondGameArrow.position = CGPoint(x: self.size.width / 2, y: gameBoard.position.y)
        secondGameArrow.zPosition = 3
        
        addChild(secondGameArrow)
        
        thirdGameArrow = SKSpriteNode(imageNamed: "yellow0Arrow")
        thirdGameArrow.size = CGSize(width: 77, height: 77)
        thirdGameArrow.position = CGPoint(x: self.size.width / 2, y: gameBoard.position.y - 70)
        thirdGameArrow.name = "yellow0Arrow"
        thirdGameArrow.zPosition = 3
        
        addChild(thirdGameArrow)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Игнорируем касания стрелочек напрямую
        if firstGameArrow.contains(location) || secondGameArrow.contains(location) || thirdGameArrow.contains(location) {
            return
        }
        
        // Проверяем, что касание произошло только на стартовых блоках
        if firstBlock.contains(location) {
            draggingBlock = firstBlock
            originalPosition = firstBlock.position
        } else if secondBlock.contains(location) {
            draggingBlock = secondBlock
            originalPosition = secondBlock.position
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let draggingBlock = draggingBlock else { return }
        let location = touch.location(in: self)
        draggingBlock.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Добавляем guard, чтобы гарантировать, что draggingBlock точно существует
        guard let draggingBlock = draggingBlock else { return }
        
        draggingBlock.removeFromParent()  // Убираем блок с экрана

        let location = touches.first!.location(in: self)
        print(originalPosition)
        // Проверяем, на какую стрелку был перемещен блок
        if firstGameArrow.contains(location) {
            let newName = updateNameArrow(gameArrow: firstGameArrow!, gameBlock: draggingBlock)
            if newName != nil {
                firstGameArrow.texture = SKTexture(imageNamed: newName!)
                firstGameArrow.name = newName!
                usedBlocks.append(draggingBlock)
            }
            self.draggingBlock = nil
            originalPosition = nil
        } else if secondGameArrow.contains(location) {
            let newName = updateNameArrow(gameArrow: secondGameArrow!, gameBlock: draggingBlock)
            if newName != nil {
                secondGameArrow.texture = SKTexture(imageNamed: newName!)
                secondGameArrow.name = newName!
                usedBlocks.append(draggingBlock)
            }
            self.draggingBlock = nil
            originalPosition = nil
        } else if thirdGameArrow.contains(location) {
            let newName = updateNameArrow(gameArrow: thirdGameArrow!, gameBlock: draggingBlock)
            if newName != nil {
                thirdGameArrow.texture = SKTexture(imageNamed: newName!)
                thirdGameArrow.name = newName!
                usedBlocks.append(draggingBlock)
            }
            self.draggingBlock = nil
            originalPosition = nil
        } else if let originalPosition = originalPosition {
            // Если блок не был перемещен на стрелку, возвращаем его на исходную позицию
            draggingBlock.position = originalPosition
            addChild(draggingBlock)
        }
        
        // Обязательно сбрасываем draggingBlock в nil
        self.draggingBlock = nil
        originalPosition = nil  // Также сбрасываем исходную позицию
        
        // Проверка условий выигрыша и поражения
        checkWinCondition()
        checkLoseCondition()
    }


    
    func checkLoseCondition() {
        if usedBlocks.count == 2 && !isWin {
            print("Lose!")
            NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil)
        }
    }
    
    func checkWinCondition() {
        let angles = [firstGameArrow, secondGameArrow, thirdGameArrow].compactMap { arrow in
            
            return extractAngle(from: arrow.name ?? "")
        }
        print(angles)
        if angles.count == 3 && angles.allSatisfy({ $0 == angles.first }) {
            isWin = true
            print("Win!")
            NotificationCenter.default.post(name: NSNotification.Name("Win"), object: nil)
        }
    }
    
    
    func extractAngle(from arrowName: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "\\d+", options: []) // Регулярное выражение для поиска чисел
        if let match = regex.firstMatch(in: arrowName, options: [], range: NSRange(location: 0, length: arrowName.count)) {
            let numberString = (arrowName as NSString).substring(with: match.range)
            return Int(numberString)
        }
        return nil
    }
    
    
    func updateNameArrow(gameArrow: SKSpriteNode, gameBlock: SKSpriteNode) -> String? {
        var arrowName = gameArrow.name ?? "nothing"
        var arrowDegree: Int? = extractAngle(from: arrowName)
        
        if gameBlock.name == "rotateRightOneBlock90", let _ = arrowDegree {
            let newValue = calculateAngle(angle1: arrowDegree!, angle2: 90)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        }
        
        return nil
    }
    
    func calculateAngle(angle1: Int, angle2: Int) -> Int {
        var result = angle1 + angle2
        if result >= 360 {
            result -= 360
        } else if result < 0 {
            result += 360
        }
        return result
    }

}
