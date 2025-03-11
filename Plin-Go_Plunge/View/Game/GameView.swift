import SwiftUI
import SpriteKit

struct GameView: View {
    
    var onMain: () -> Void
    
    //win
    @State var timeOfLevel = 120
    @State private var isLevelWinBefore = true
    
    @State var currentLevel = 2
    @State var gameScene: GameScene
    @State private var isGameOver = false
    @State private var isPaused = false
    @State private var isWin = false
    @State private var isShopOpened = false
    @State private var isHeart = false
    
    init(currentLevel: Int, onMain: @escaping () -> Void) {
        self.currentLevel = currentLevel
        _gameScene = State(initialValue: GameScene(level: currentLevel)) // Передаем currentLevel
        self.onMain = onMain
    }
    
    var body: some View {
        ZStack {
            
            ZStack {
                Image("lvl\(currentLevel)Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                SpriteView(scene: gameScene, options: [.allowsTransparency])
                    .edgesIgnoringSafeArea(.all)
                    .background(.clear)
                    .id(gameScene)
                
                HStack(alignment: .center) {
                    Button {
                        isPaused = true
                        gameScene.isPaused = true
//                        gameScene.timer?.invalidate()
                        gameScene.timerManager.stop()
                    } label: {
                        Image("pauseButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 53, height: 53)
                    }
                    .frame(width: 53, height: 53)
                    Spacer()
                    Button {
                        isHeart = true
                        gameScene.isPaused = true
//                        gameScene.timer?.invalidate()
                        gameScene.timerManager.stop()
                    } label: {
                        Image("replayButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 53, height: 53)
                    }
                    .frame(width: 53, height: 53)
                }
                .padding(.horizontal, 16)
                .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 220 :220))
                
            }
            .edgesIgnoringSafeArea(.all)
            .blur(radius: (isGameOver || isWin || isPaused || isShopOpened || isHeart) ? 5 : 0)
            HeartsGameView()
                .position(x: 45, y: ScreenSizes.isSmallScreen ? 135 :85)
                .blur(radius: (isGameOver || isWin || isPaused ) ? 5 : 0)
            CoinsView()
                .position(x: ScreenSizes.screenWidth - 70, y: ScreenSizes.isSmallScreen ? 135 :85)
                .blur(radius: (isGameOver || isWin || isPaused || isHeart) ? 5 : 0)
            if isGameOver {
                GameOverView {
                    isHeart = true
                } onMenu: {
                    onMain()
                }

            }
            
            if isWin {
                WinView(onNextLevel: {
                    setupNextLevel()
                }, onMenu: {
                    onMain()
                }, time: timeOfLevel,
                    level: currentLevel,
                    isLevelWinBefore: isLevelWinBefore
                )
            }
            
            if isPaused {
                PauseView {
                    isPaused = false
                    gameScene.isPaused = false
//                    gameScene.startTimer()
                    gameScene.timerManager.start()
                } onMenu: {
                    onMain()
                } onShop: {
                    isShopOpened = true
                    isPaused = false
                }

            }
            
            if isShopOpened {
                ShopView(onBack: {
                    isShopOpened = false
                    isPaused = true
                }, isPause: true)
                .zIndex(10)
            }
            
            if isHeart {
                HeartSpendView {
                    if HeardsManager.shared.subtractHeards(1) {
                        isHeart = false
                        gameScene.isPaused = false
//                        gameScene.startTimer()
                        gameScene.timerManager.start()
                        restartLevel()
                    }
                } onBack: {
                    isHeart = false
                    gameScene.isPaused = false
//                    gameScene.startTimer()
                    gameScene.timerManager.start()
                }

            }
        }
        .navigationBarHidden(true)
        .onAppear {
            self.gameScene.scaleMode = .aspectFill
            
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("GameOver"),
                object: nil,
                queue: .main
            ) { _ in
                let _ = HeardsManager.shared.subtractHeards(1)
                self.isGameOver = true
            }
            
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("Win"),
                object: nil,
                queue: .main
            ) { notification in
                if let time = notification.object as? Int {
                    print("Получено время: \(time)")
                    self.timeOfLevel = time
                }
                if !LevelsDataModel.shared.isUnlocked(currentLevel + 1) {
                    isLevelWinBefore = false
                    LevelsDataModel.shared.unlock(level: currentLevel + 1)
                    CristalsManager.shared.addCristals(100)
                } else {
                    isLevelWinBefore = true
                    CristalsManager.shared.addCristals(50)
                }
                
                self.isWin = true
            }

        }
    }
    
    
    private func restartLevel() {
        isGameOver = false
        isWin = false
        gameScene = GameScene(level: currentLevel)
        gameScene.scaleMode = .aspectFill
    }
    
    private func setupNextLevel() {
        isGameOver = false
        isWin = false
        currentLevel += 1
        gameScene = GameScene(level: currentLevel)
        gameScene.scaleMode = .aspectFill
    }
}

