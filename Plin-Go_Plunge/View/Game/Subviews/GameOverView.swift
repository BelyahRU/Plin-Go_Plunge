import SwiftUI

import SwiftUI

struct CustomAlertView: View {
    var title: String = "Not Enough Hearts"
    var message: String = "You don't have enough hearts to play.\nYou can purchase hearts or wait until they are automatically added."
    var dismissButtonTitle: String = "Cancel"
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Затемнённый фон как в стандартном alert
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Контейнер для заголовка и сообщения
                VStack(spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    
                    Text(message)
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 16)
                }
                
                Divider() // Разделитель между сообщением и кнопкой
                
                // Кнопка "Cancel"
                Button(action: onDismiss) {
                    Text(dismissButtonTitle)
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .foregroundColor(.blue)
            }
            .frame(width: 270)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(13)
            .clipped()
        }
    }
}


// GameOverView с интегрированным кастомным алертом
struct GameOverView: View {
    
    var onRetry: () -> Void
    var onMenu: () -> Void
    @State var showNotEnoughtAlert = false

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 10) {
                Image("gameOverLabel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 360, height: 257)
                
                // Кнопка "Retry". Здесь проверяем количество сердец.
                Button {
                    if HeardsManager.shared.currentHeards == 0 {
                        showNotEnoughtAlert = true
                    } else {
                        onRetry()
                    }
                } label: {
                    Image("retryButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 231, height: 68)
                }
                
                Button {
                    onMenu()
                } label: {
                    Image("menuButton1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 231, height: 68)
                }
            }
            .padding(.bottom, 100 + (ScreenSizes.isSmallScreen ? 50:0))
            
            // Если сердец недостаточно — отображаем кастомный алерт
            if showNotEnoughtAlert {
                CustomAlertView {
                    showNotEnoughtAlert = false
                }
                .padding(.bottom, ScreenSizes.isSmallScreen ? 120 : 0)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
