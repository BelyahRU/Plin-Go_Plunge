import SwiftUI
import SpriteKit

struct GameView: View {
    
    var onMain: () -> Void
    
    //win
    @State var timeOfLevel = 120
    @State private var isLevelWinBefore = true
    @State var showNotEnoughtAlert = false
    
    @State var currentLevel = 2
    @State var gameScene: GameScene
    @State private var isGameOver = false
    @State private var isPaused = false
    @State private var isWin = false
    @State private var isShopOpened = false
    @State private var isHeart = false
    
    @AppStorage("isFirst2f2f222f532242232") var isFirst = true
//    @State var isFirst = true
    
    
    
    init(currentLevel: Int, onMain: @escaping () -> Void) {
        self.currentLevel = currentLevel
        _gameScene = State(initialValue: GameScene(level: currentLevel)) // Передаем currentLevel
        self.onMain = onMain
    }
    
    var body: some View {
        ZStack {
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
                            if HeardsManager.shared.currentHeards == 0 {
                                showNotEnoughtAlert = true
                            } else {
                                isHeart = true
                                gameScene.isPaused = true
        //                        gameScene.timer?.invalidate()
                                gameScene.timerManager.stop()
                            }
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
                    .position(x: 45, y: ScreenSizes.isSmallScreen ? 85 :85)
                    .blur(radius: (isGameOver || isWin || isPaused ) ? 5 : 0)
                CoinsView()
                    .position(x: ScreenSizes.screenWidth - 70, y: ScreenSizes.isSmallScreen ? 85 :85)
                    .blur(radius: (isGameOver || isWin || isPaused || isHeart) ? 5 : 0)
                if isGameOver {
                    GameOverView {
                        isHeart = true
                    } onMenu: {
                        onMain()
                    }
                    .onAppear {
                        gameScene.timerManager.stop()
                    }

                }
                
                if isWin {
                    WinView(onNextLevel: {
                        setupNextLevel()
                    }, onMenu: {
                        let _ = HeardsManager.shared.subtractHeards(1)
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
                
                if showNotEnoughtAlert {
                    CustomAlertView {
                        showNotEnoughtAlert = false
                    }
                    .padding(.bottom, ScreenSizes.isSmallScreen ? 120 : 0)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if isFirst {
                        gameScene.isPaused = true
                        gameScene.timerManager.stop()
                    }
                }
                self.gameScene.scaleMode = .aspectFill
                
                NotificationCenter.default.addObserver(
                    forName: NSNotification.Name("GameOver"),
                    object: nil,
                    queue: .main
                ) { _ in
                    gameScene.timerManager.stop()
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
                    gameScene.timerManager.stop()
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
            if isFirst {
                TutorialView(onSkip: {
                    isFirst = false
                    gameScene.isPaused = false
                    gameScene.timerManager.start()
                }, onHome: {
                    onMain()
                })
                    .ignoresSafeArea(.all)
                    .position(CGPoint(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight / 2))
                    
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
        if currentLevel != 15 {
            currentLevel += 1
        } else {
            currentLevel = 1
        }
        isGameOver = false
        isWin = false
        gameScene = GameScene(level: currentLevel)
        gameScene.scaleMode = .aspectFill
    }
}

