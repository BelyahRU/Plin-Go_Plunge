import SwiftUI
import SpriteKit

struct GameView: View {
    
    var onMain: () -> Void
    
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
                        gameScene.timer?.invalidate()
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
                        gameScene.timer?.invalidate()
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
                    restartLevel()
                    isHeart = true
                } onMenu: {
                    
                    print("menu")
                }

            }
            
            if isWin {
                WinView {
                    setupNextLevel()
                } onMenu: {
                    print("menu")
                }

            }
            
            if isPaused {
                PauseView {
                    isPaused = false
                    gameScene.isPaused = false
                    gameScene.startTimer()
                } onMenu: {
                    onMain()
                } onShop: {
                    print("shop")
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
                        gameScene.startTimer()
                        restartLevel()
                    }
                } onBack: {
                    isHeart = false
                    gameScene.isPaused = false
                    gameScene.startTimer()
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
                self.isGameOver = true
            }
            
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("Win"),
                object: nil,
                queue: .main
            ) { _ in
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

