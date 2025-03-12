import SwiftUI

struct ff: View {
    @State private var animate: Bool = false
    @State private var combinedOffset: CGSize = .zero
    @State private var pinkArrowFrame: CGRect = .zero
    @State private var startBlockFrame: CGRect = .zero
    
    // Состояния для последовательной анимации
    @State private var showAnimatedBlock: Bool = true
    @State private var showPink90Arrow: Bool = false
    @State private var showHand: Bool = true
    @State private var darkenBackground: Bool = false
    @State private var showText: Bool = true
    @State private var showNewText: Bool = false
    
    // Новые состояния для replayButton и handImage2
    @State private var showReplayButton: Bool = false
    @State private var showHandImage2: Bool = false
    
    // Константы для позиционирования
    let boardWidth: CGFloat = 174
    let boardHeight: CGFloat = 343
    let textMargin: CGFloat = 20

    var body: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let screenHeight = geo.size.height
            ZStack {
                // Группа, которую затемняем (игровая доска, стрелки, исходный текст)
                ZStack {
                    Color(.blue.withAlphaComponent(0.2))
                        .edgesIgnoringSafeArea(.all)
                    
                    // Игровое поле с позиционированием по центру экрана
                    ZStack {
                        Image("gameBoard1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: boardWidth, height: boardHeight)
                            .position(x: screenWidth / 2, y: screenHeight / 2 - boardHeight / 2)
                        
                        VStack(spacing: -9) {
                            Image("red90Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 77, height: 77)
                            
                            // pink0Arrow (или pink90Arrow, если уже заменена) с GeometryReader для измерения его позиции
                            Image(showPink90Arrow ? "pink90Arrow" : "pink0Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 77, height: 77)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.onAppear {
                                            pinkArrowFrame = geo.frame(in: .global)
                                        }
                                    }
                                )
                            
                            Image("yellow0Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 77, height: 77)
                        }
                        .position(x: screenWidth / 2, y: screenHeight / 2 - boardHeight / 2)
                    }
                    
                    // Исходный текст над игровым полем
                    if showText {
                        VStack(spacing: -15) {
                            Text("Turn all arrows")
                                .font(.custom("Kavoon-Regular", size: 26))
                                .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                                .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                            Text("in one direction")
                                .font(.custom("Kavoon-Regular", size: 26))
                                .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                                .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                        }
                        // Позиционируем текст так, чтобы его нижняя граница совпадала с верхней границей игрового поля
                        .position(x: screenWidth / 2,
                                  y: screenHeight / 2 - boardHeight / 2 - textMargin - boardHeight / 2)
                        .zIndex(10)
                    }
                }
                .ignoresSafeArea()
//                 Затемняющий слой для всей группы (но ниже нижней панели)
                if darkenBackground {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)
                }
//                 Новый текст, который появляется поверх затемнения – располагаем его на том же месте, что и исходный текст
                if showNewText {
                    VStack(spacing: -10) {
                        Text("You can start")
                            .font(.custom("Kavoon-Regular", size: 26))
                            .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                            .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                        Text("the level over,")
                            .font(.custom("Kavoon-Regular", size: 26))
                            .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                            .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                        Text("but it will cost 1 life.")
                            .font(.custom("Kavoon-Regular", size: 26))
                            .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                            .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                    }
                    .position(x: screenWidth / 2,
                              y: screenHeight / 2 - boardHeight / 2 - textMargin - boardHeight / 2)
                    .zIndex(20)
                }
                
//                 Нижняя панель с блоками – остаётся поверх затемняющего слоя
                
                
//                 Hand Image – двигается вместе с блоком и затем исчезает
                if showHand {
                    Image("handImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 107)
                        .position(CGPoint(x: screenWidth / 2 + 50, y: screenHeight - 190))
                        .offset(animate ? combinedOffset : .zero)
                        .animation(.easeInOut(duration: 1), value: animate)
                        .zIndex(3)
                }
                
                // replayButton (изначально скрыта)
                if showReplayButton {
                    Image("replayButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 53, height: 53)
                        .position(x: screenWidth - 39,
                                  y: screenHeight - 288)
                        .zIndex(30)
                }
                
                // handImage2, появляется над replayButton с небольшим смещением влево вверх
                if showHandImage2 {
                    Image("handImage2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 107)
                        .position(x: screenWidth - 53/2 - 16 - 10,
                                  y: screenHeight - 300 - 10)
                        .zIndex(31)
                }
                ZStack {
                    Image("snowBottomImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth + 60, height: 220)
                        .ignoresSafeArea()
                    HStack(spacing: 13) {
                        // Первый блок (без анимации)
                        ZStack(alignment: .center) {
                            Image("startBlockImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 74, height: 74)
                            Image("rotateRightOneBlock90")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 74, height: 74)
                        }
                        
                        // Второй блок: фон остаётся статичным, а анимируется только изображение стрелки
                        ZStack(alignment: .center) {
                            Image("startBlockImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 74, height: 74)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.onAppear {
                                            startBlockFrame = geo.frame(in: .global)
                                        }
                                    }
                                )
                            if showAnimatedBlock {
                                Image("rotateRightOneBlock90")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 74, height: 74)
                                    .offset(animate ? combinedOffset : .zero)
                                    .animation(.easeInOut(duration: 1), value: animate)
                                    .transition(.opacity)
                            }
                        }
                    }
                }
                .position(CGPoint(x: screenWidth / 2, y: screenHeight - 170))
                .zIndex(2)
                .ignoresSafeArea(.all)
            }
            .onAppear {
                // Через 1.5 сек вычисляем смещение и запускаем анимацию перемещения
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let pinkCenter = CGPoint(x: pinkArrowFrame.midX, y: pinkArrowFrame.midY)
                    let startCenter = CGPoint(x: startBlockFrame.midX, y: startBlockFrame.midY)
                    let offsetX = pinkCenter.x - startCenter.x
                    let offsetY = pinkCenter.y - startCenter.y
                    combinedOffset = CGSize(width: offsetX, height: offsetY)
                    animate = true
                    
                    // Через 1 сек после перемещения заменяем стрелку и скрываем handImage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showAnimatedBlock = false
                            showPink90Arrow = true
                        }
                        
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showHand = false
                        }
                        
                        // Через 0.5 сек затемняется задний фон, исходный текст исчезает и появляется новый текст,
                        // а затем появляется replayButton, а спустя 0.4 сек – handImage2, и через ещё 0.4 сек replayButton исчезает
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                darkenBackground = true
                                showText = false
                                showNewText = true
                                showReplayButton = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showHandImage2 = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showReplayButton = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
//            .padding(.bottom, -100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
