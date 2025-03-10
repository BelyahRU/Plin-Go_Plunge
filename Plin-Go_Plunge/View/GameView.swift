import SwiftUI
import SpriteKit

struct GameView: View {
    
    @State var currentLevel = 2
    @State var gameScene: GameScene
    @State private var isGameOver = false
    @State private var isWin = false
    
    init(currentLevel: Int) {
        self.currentLevel = currentLevel
        _gameScene = State(initialValue: GameScene(level: currentLevel)) // Передаем currentLevel
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
            }
            .edgesIgnoringSafeArea(.all)
            .blur(radius: (isGameOver || isWin ) ? 5 : 0)
            
            if isGameOver {
                GameOverView {
                    restartLevel()
                } onMenu: {
                    print("menu")
                }

            }
            
            if isWin {
                WinView {
                    restartLevel()
                } onMenu: {
                    print("menu")
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
}

