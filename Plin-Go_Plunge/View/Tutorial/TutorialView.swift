import SwiftUI

struct TutorialView: View {
    
    var onSkip: () -> Void
    var onHome: () -> Void
    
    
    @State private var animate: Bool = false
    @State private var animate2: Bool = false
    @State private var combinedOffset: CGSize = .zero
    @State private var combinedOffset2: CGSize = .zero
    
    
    
    @State private var pinkArrowFrame: CGRect = .zero
    @State private var yellowArrowFrame: CGRect = .zero
    @State private var startBlockFrame: CGRect = .zero
    @State private var startBlockFrame2: CGRect = .zero
    @State private var handImage2Position: CGPoint = CGPoint(
        x: ScreenSizes.screenWidth - 53/2 - 16 - 10,
        y: ScreenSizes.screenHeight - 270 + (ScreenSizes.isSmallScreen ? 80 : 0))
    @State private var handImageName: String = "handImage2"

    // Состояния для последовательной анимации
    @State private var showAnimatedBlock: Bool = true
    @State private var showAnimatedBlock2: Bool = true
    @State private var showPink90Arrow: Bool = false
    @State private var showYellow90Arrow: Bool = false
    @State private var showHand: Bool = true
    @State private var showHand2: Bool = false
    @State private var darkenBackground: Bool = false
    @State private var showText: Bool = true
    @State private var showNewText: Bool = false
    @State private var showNewText2: Bool = false
    @State private var showNewText3: Bool = false
    
    @State private var showLeftBlock: Bool = true
    @State private var leftBlockOffset: CGSize = .zero

    
    // Новые состояния для replayButton и handImage2
    @State private var showReplayButton: Bool = false
    @State private var showHandImage2: Bool = false
    @State private var isHeart: Bool = false
    
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
                
                Color(.black.withAlphaComponent(0.5))
                    .edgesIgnoringSafeArea(.all)
                ZStack {
                    
                    // Игровое поле с позиционированием по центру экрана
                    ZStack {
                        Image("gameBoard1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: boardWidth / (ScreenSizes.isSmallScreen ? 1: 1.3))
                            .position(x: screenWidth / 2 + 4.5, y: screenHeight / 2 - boardHeight / 4 + 25 + (ScreenSizes.isSmallScreen ? 0: 0) - (ScreenSizes.isBigScreen ? 37 : 0))
                        
                        VStack(spacing: -9) {
                            Image("red90Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: (ScreenSizes.isSmallScreen ? 100: 77))
                            
                            // pink0Arrow (или pink90Arrow, если уже заменена) с GeometryReader для измерения его позиции
                            Image(showPink90Arrow ? "pink90Arrow" : "pink0Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: (ScreenSizes.isSmallScreen ? 100: 77))
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.onAppear {
                                            pinkArrowFrame = geo.frame(in: .global)
                                        }
                                    }
                                )
                            
                            Image(showYellow90Arrow ? "yellow90Arrow" : "yellow0Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: (ScreenSizes.isSmallScreen ? 100: 77))
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.onAppear {
                                            yellowArrowFrame = geo.frame(in: .global)
                                        }
                                    }
                                )
                        }
                        .position(x: screenWidth / 2 + 4.5, y: screenHeight / 2 - boardHeight / 4 + 25 + (ScreenSizes.isSmallScreen ? 0: 0)  - (ScreenSizes.isBigScreen ? 37 : 0))
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
                        .position(x: screenWidth / 2 + 4.5, y: screenHeight / 2 - boardHeight / 4 + 25 - boardHeight / 2 - textMargin + (ScreenSizes.isSmallScreen ? 0: 0))
                        .zIndex(10)
                    }
                }
                .ignoresSafeArea()
                if darkenBackground {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)
                }
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
                    .position(x: screenWidth / 2 + 4.5, y: screenHeight / 2 - boardHeight / 4 + 25 - boardHeight / 2 - textMargin - 20 + (ScreenSizes.isSmallScreen ? 5: 0))
                    .zIndex(20)
                }
                
                if showNewText2 {
                    VStack(spacing: -15) {
                        Text("You can records")
                            .font(.custom("Kavoon-Regular", size: 26))
                            .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                            .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                        Text("for passing time.")
                            .font(.custom("Kavoon-Regular", size: 26))
                            .foregroundStyle(Color(red: 72/255, green: 220/255, blue: 240/255))
                            .customeStroke(color: Color(red: 7/255, green: 47/255, blue: 88/255), width: 2)
                    }
                    .position(x: screenWidth / 2 + 4.5, y: screenHeight / 2 - boardHeight / 4 + 25 - boardHeight / 2 - textMargin + (ScreenSizes.isSmallScreen ? 5: 0))
                    .zIndex(20)
                }
                if showNewText3 {
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
                    .position(x: screenWidth / 2 + 4.5, y: screenHeight / 2 - boardHeight / 4 + 25 - boardHeight / 2 - textMargin + (ScreenSizes.isSmallScreen ? 5: 0))
                    .zIndex(20)
                }
                
//                 Нижняя панель с блоками – остаётся поверх затемняющего слоя
                
                
//                 Hand Image – двигается вместе с блоком и затем исчезает
                if showHand {
                    Image("handImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 107)
                        .position(CGPoint(x: screenWidth / 2 + 50, y: screenHeight - 135 - (ScreenSizes.isSmallScreen ? 50:0)))
                        .offset(animate ? combinedOffset : .zero)
                        .animation(.easeInOut(duration: 1), value: animate)
                        .zIndex(3)
                }
                
                if showHand2 {
                    Image("handImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 107)
                        .position(CGPoint(x: screenWidth / 2 - 40, y: screenHeight - 135 - (ScreenSizes.isSmallScreen ? 50:0)))
                        .offset(animate2 ? combinedOffset2 : .zero)
                        .animation(.easeInOut(duration: 1), value: animate2)
                        .zIndex(3)
                }
                
                // replayButton (изначально скрыта)
                if showReplayButton {
                    Image("replayButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 53, height: 53)
                        .position(x: screenWidth - 39 - (ScreenSizes.isBigScreen ? 3: 0),
                                  y: screenHeight - 288 + 50 - (ScreenSizes.isSmallScreen ? 50 : 0) + (ScreenSizes.isBigScreen ? 8: 0))
                        .zIndex(30)
                }
                
                // handImage2, появляется над replayButton с небольшим смещением влево вверх
                if showHandImage2 {
                    Image(handImageName)

                        .resizable()
                        .scaledToFit()
                        .frame(width: 73)
                        .position(handImage2Position)
                        .zIndex(31)
                }
                
                ZStack {
                    Image("snowBottomImage")
                        .resizable()
                        .scaledToFit()
//                        .frame(width: screenWidth + 60, height: 220)
                        .frame(width: screenWidth + 60)
                        .ignoresSafeArea()
                    VStack(spacing: 10) {
                        Text("Time: 120s")
                            .font(.custom("Kavoon-Regular", size: 33))
                            .foregroundStyle(Color(red: 32/255.0, green: 102/255.0, blue: 173/255.0))
                        HStack(spacing: (ScreenSizes.isSmallScreen ? 26 : 13)) {
                            // Первый блок (без анимации)
                            ZStack(alignment: .center) {
                                Image("startBlockImage")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 74, height: 74)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear.onAppear {
                                                startBlockFrame2 = geo.frame(in: .global)
                                            }
                                        }
                                    )
                                if showAnimatedBlock2 {
                                    Image("rotateRightOneBlock90")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 74, height: 74)
                                        .offset(animate2 ? combinedOffset2 : .zero)
                                        .animation(.easeInOut(duration: 1), value: animate2)
                                        .transition(.opacity)
                                }
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
                    
                }
                .position(CGPoint(x: screenWidth / 2, y: screenHeight - (ScreenSizes.isSmallScreen ? 160 : 110)))
                .zIndex(2)
                .ignoresSafeArea(.all)
                
                HStack(alignment: .center) {
                    if !isHeart {
                        Button {
                            onHome()
                        } label: {
                            Image("homeTutorialButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 53, height: 53)
                        }
                        .frame(width: 53, height: 53)
                    } else {
                        Image("heart1Image")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 67, height: 67)
                    }
                    Spacer()
                    Button {
                        onSkip()
                    } label: {
                        Image("skipTutorialButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 27)
                    }
                    .frame(width: 42, height: 27)
                }
                .padding(.horizontal, 16)
                .position(CGPoint(x: screenWidth / 2, y: ScreenSizes.isSmallScreen ? 150 : 100 - (ScreenSizes.isBigScreen ? 10: 0)))
                .zIndex(100)
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                darkenBackground = true
                                showText = false
                                showNewText = true
                                showReplayButton = true
                                isHeart = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                // Инициализируем handImage2 там, где была handImage
//                                handImage2Position = CGPoint(x: screenWidth / 2 + 50, y: screenHeight - 150)
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showHandImage2 = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showReplayButton = false
                                        showNewText = false
                                        showNewText2 = true
                                        
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation {
                                            handImageName = "handImage3"
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                            let targetX = screenWidth / 2 + 4.5
                                            let targetY = (screenHeight - 200 - (ScreenSizes.isSmallScreen ? 50:0))
                                            isHeart = false
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                handImage2Position = CGPoint(x: targetX, y: targetY)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                                                showHandImage2 = false
                                                showNewText2 = false
                                                darkenBackground = false
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    showNewText3 = true
                                                }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    showHand2 = true
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                            let yellowCenter = CGPoint(x: yellowArrowFrame.midX, y: yellowArrowFrame.midY)
                                                            let startCenter = CGPoint(x: startBlockFrame2.midX, y: startBlockFrame2.midY)
                                                            let offsetX = yellowCenter.x - startCenter.x
                                                            let offsetY = yellowCenter.y - startCenter.y
                                                            combinedOffset2 = CGSize(width: offsetX, height: offsetY)
                                                            animate2 = true
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                                    showAnimatedBlock2 = false
                                                                    showYellow90Arrow = true
                                                                    showNewText3 = false
                                                                }
                                                                
                                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                                    showHand2 = false
                                                                }
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                                    onSkip()
                                                                }
                                                            }
                                                            
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                
                                }
                            }
                        }

                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
