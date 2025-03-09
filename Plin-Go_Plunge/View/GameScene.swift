

import SpriteKit

final class GameScene: SKScene {
    
    var currentLevel: Int
    
    var arrows: [SKSpriteNode] = []
    var startArrows: [SKSpriteNode] = []
    var gameBoard: SKSpriteNode!
    var draggingBlock: SKSpriteNode?
    var originalPosition: CGPoint?
    var isWin = false
    
    var firstGameArrowIsLocked = false
    var secondGameArrowIsLocked = false
    var thirdGameArrowIsLocked = false
    
    var usedBlocks: [SKSpriteNode] = []
    var usedStartBlocksCount = 0
    
    init(level: Int) {
        self.currentLevel = level
        print(currentLevel)
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        configureScene()
        configureSnowBottom()
        
        setupLevel()
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Игнорируем касания стрелочек напрямую
        for arrow in arrows {
            if arrow.contains(location) {
                return
            }
        }
        
        // Проверяем, что касание произошло только на стартовых блоках
        for i in 0..<startArrows.count {
            if startArrows[i].contains(location) {
                draggingBlock = startArrows[i]
                draggingBlock!.alpha = 0.8
                if startArrows[i].name!.contains("Two") {
                    draggingBlock!.size = CGSize(width: startArrows[i].size.width * 2,
                                                 height: startArrows[i].size.height * 2)
                }
                originalPosition = startArrows[i].position
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let draggingBlock = draggingBlock else { return }
        let location = touch.location(in: self)
        draggingBlock.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let draggingBlock = draggingBlock else { return }
        draggingBlock.removeFromParent()  // Убираем блок с экрана
        
        let location = touches.first!.location(in: self)
        
        // Если draggingBlock имеет имя, содержащее "Two", проверяем, какие блоки попали в него
        if draggingBlock.name!.contains("Two") {
            // Нужно искать блоки, попавшие в область draggingBlock
            var blocksInArea: [SKSpriteNode] = []
            if draggingBlock.name!.contains("Horizontal") {
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
                        // Для каждого найденного блока обновляем имя
                        let newName = updateNameArrow(gameArrow: block, gameBlock: draggingBlock)  // Предположим, что у нас одна стрелка для этого случая
                        if newName != nil {
                            // Обновляем имя и добавляем в использованные
                            block.texture = SKTexture(imageNamed: newName!)
                            block.name = newName!
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
                    let newName = updateNameArrow(gameArrow: arrow, gameBlock: draggingBlock)
                    if newName != nil {
                        arrow.texture = SKTexture(imageNamed: newName!)
                        arrow.name = newName!
                        usedBlocks.append(draggingBlock)
                        usedStartBlocksCount += 1
                    }
                    self.draggingBlock = nil
                    originalPosition = nil
                }
            }
        }
        
        // Проверяем на какую стрелку был перемещен блок
        
        if let originalPosition = originalPosition {
            // Если блок не был перемещен на стрелку, возвращаем его на исходную позицию
            draggingBlock.position = originalPosition
            let size = draggingBlock.size
            draggingBlock.size = CGSize(width: size.width / 2, height: size.height / 2)
            draggingBlock.alpha = 1
            addChild(draggingBlock)
        }
        
        // Обязательно сбрасываем draggingBlock в nil
        self.draggingBlock = nil
        originalPosition = nil
        
        // Проверка условий выигрыша и поражения
        checkWinCondition()
        checkLoseCondition()
    }
    
    func getBlocksInArea(draggingBlock: SKSpriteNode, count: Int, alignment: String) -> [SKSpriteNode] {
        let minX = draggingBlock.position.x - draggingBlock.frame.size.width / 4
        let maxX = draggingBlock.position.x + draggingBlock.frame.size.width / 4
        let minY = draggingBlock.position.y - draggingBlock.frame.size.height / 4
        let maxY = draggingBlock.position.y + draggingBlock.frame.size.height / 4
        
        var blocksInArea: [(block: SKSpriteNode, intersectionArea: CGFloat)] = []
        
        // Обходим все возможные блоки в сцене (например, это могут быть все блоки, кроме стрелок)
        for block in arrows {
            let blockMinX = block.position.x - block.frame.size.width / 2
            let blockMaxX = block.position.x + block.frame.size.width / 2
            let blockMinY = block.position.y - block.frame.size.height / 2
            let blockMaxY = block.position.y + block.frame.size.height / 2
            
            // Проверяем, пересекаются ли прямоугольники (хотя бы на чуть-чуть)
            if maxX > blockMinX && minX < blockMaxX && maxY > blockMinY && minY < blockMaxY {
                // Если хотя бы часть block входит в draggingBlock, вычисляем площадь пересечения
                let intersectionRect = CGRect(
                    x: max(minX, blockMinX),
                    y: max(minY, blockMinY),
                    width: min(maxX, blockMaxX) - max(minX, blockMinX),
                    height: min(maxY, blockMaxY) - max(minY, blockMinY)
                )
                
                let intersectionArea = intersectionRect.width * intersectionRect.height
                
                // Добавляем блок и его площадь пересечения в массив
                blocksInArea.append((block, intersectionArea))
            }
        }
        
        // Группируем блоки по alignment (по y для вертикального, по x для горизонтального)
        var groupedBlocks: [CGFloat: [SKSpriteNode]] = [:]
        
        if alignment == "Vertical" {
            // Группируем по оси Y
            for (block, _) in blocksInArea {
                let key = block.position.y  // Используем y как ключ для группировки
                if groupedBlocks[key] == nil {
                    groupedBlocks[key] = []
                }
                groupedBlocks[key]?.append(block)
            }
        } else if alignment == "Horizontal" {
            // Группируем по оси X
            for (block, _) in blocksInArea {
                let key = block.position.x  // Используем x как ключ для группировки
                if groupedBlocks[key] == nil {
                    groupedBlocks[key] = []
                }
                groupedBlocks[key]?.append(block)
            }
        }
        
        // Фильтруем только те группы, в которых достаточно блоков (например, 2)
        var filteredBlocks: [SKSpriteNode] = []
        for (_, group) in groupedBlocks {
            if group.count >= 1 {  // Фильтруем, если блоков больше или равно нужному количеству
                filteredBlocks.append(contentsOf: group)
            }
        }
        
        // Сортируем блоки по площади пересечения в порядке убывания
        let sortedBlocks = blocksInArea.filter { block, _ in
            filteredBlocks.contains(block)
        }.sorted { $0.intersectionArea > $1.intersectionArea }
        
        
        var array = sortedBlocks.prefix(count).map { $0.block }
            
        // Проверяем, если draggingBlock содержит "_" и "Horizontal"
        if draggingBlock.name?.contains("_") == true && draggingBlock.name?.contains("Horizontal") == true {
            // Если да, сортируем блоки по возрастанию координаты x
            array.sort { $0.position.x < $1.position.x }
        }
        
        // Возвращаем отсортированные блоки
        return array
    }
    
    
    
    func checkLoseCondition() {
        if usedStartBlocksCount == startArrows.count && !isWin {
            print("Lose!")
            NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil)
        }
    }
    
    func checkWinCondition() {
        let angles = arrows.compactMap { arrow in
            
            return extractAngle(from: arrow.name ?? "")
        }
        print(angles)
        if angles.count == arrows.count && angles.allSatisfy({ $0 == angles.first }) {
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
        let arrowDegree: Int? = extractAngle(from: arrowName)
        
        if gameBlock.name == "rotateRightOneBlock90", let _ = arrowDegree {
            let newValue = calculateAngle(angle1: arrowDegree!, angle2: 90)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateOneBlock180", let _ = arrowDegree {
            let newValue = calculateAngle(angle1: arrowDegree!, angle2: 180)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateRightTwoHorizontalBlocks90", let _ = arrowDegree {
            let newValue = calculateAngle(angle1: arrowDegree!, angle2: 90)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateLeftTwoVerticalBlocks90", let _ = arrowDegree {
            let newValue = substractAngle(angle1: arrowDegree!, angle2: 90)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateLeftOneBlock90", let _ = arrowDegree {
            let newValue = substractAngle(angle1: arrowDegree!, angle2: 90)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateRightOneBlock45", let _ = arrowDegree {
            let newValue = calculateAngle(angle1: arrowDegree!, angle2: 45)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateRightOneBlock135", let _ = arrowDegree {
            let newValue = calculateAngle(angle1: arrowDegree!, angle2: 135)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateLeftOneBlock45", let _ = arrowDegree {
            let newValue = substractAngle(angle1: arrowDegree!, angle2: 45)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        } else if gameBlock.name == "rotateLeftTwoVerticalBlocks45", let _ = arrowDegree {
            let newValue = substractAngle(angle1: arrowDegree!, angle2: 45)
            arrowName = arrowName.replacingOccurrences(of: "\(arrowDegree!)", with: "\(newValue)")
            return arrowName
        }
        
        return nil
    }
    
    func updateTwoNames(gameArrows: [SKSpriteNode], gameBlock: SKSpriteNode) -> [String]? {
        var arrowNames: [String] = []
        var arrowDegrees: [Int?] = []
        for i in gameArrows {
            arrowNames.append(i.name ?? "nothing")
            arrowDegrees.append(extractAngle(from: i.name ?? "nothing"))
        }
        
        if gameBlock.name == "rotateTwoBlocksHorizontal_45_135" {
            let newValue = calculateAngle(angle1: arrowDegrees[0]!, angle2: 45)
            arrowNames[0] = arrowNames[0].replacingOccurrences(of: "\(arrowDegrees[0]!)", with: "\(newValue)")
            let newValue2 = calculateAngle(angle1: arrowDegrees[1]!, angle2: 135)
            arrowNames[1] = arrowNames[1].replacingOccurrences(of: "\(arrowDegrees[1]!)", with: "\(newValue2)")
            return arrowNames
        } else if gameBlock.name == "rotateTwoBlocksHorizontal_90_45" {
            let newValue = calculateAngle(angle1: arrowDegrees[0]!, angle2: 90)
            arrowNames[0] = arrowNames[0].replacingOccurrences(of: "\(arrowDegrees[0]!)", with: "\(newValue)")
            let newValue2 = substractAngle(angle1: arrowDegrees[1]!, angle2: 45)
            arrowNames[1] = arrowNames[1].replacingOccurrences(of: "\(arrowDegrees[1]!)", with: "\(newValue2)")
            return arrowNames
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
    
    func substractAngle(angle1: Int, angle2: Int) -> Int {
        var result = angle1 - angle2
        if result >= 360 {
            result -= 360
        } else if result < 0 {
            result += 360
        }
        return result
    }
}
