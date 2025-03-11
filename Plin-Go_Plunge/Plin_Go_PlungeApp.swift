
import SwiftUI

@main
struct Plin_Go_PlungeApp: App {
    @AppStorage("isInit") var isInit = true
    
    var body: some Scene {
        WindowGroup {
            if isInit {
                InitialView(onHome: {
                    isInit = false
                })
                .edgesIgnoringSafeArea(.all)
            } else {
                MainView()
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
//                        HeardsManager.shared
                    }
//                WinView(onNextLevel: {
//                    print()
//                }, onMenu: {
//                    print()
//                }, time: 10, level: 1, isLevelWinBefore: false)
            }
        }
        
    }
}
