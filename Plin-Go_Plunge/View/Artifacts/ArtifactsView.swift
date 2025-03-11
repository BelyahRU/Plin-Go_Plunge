import SwiftUI

struct ArtifactsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isInfo = false
    @State var currentLvl = 1
    var centerX = ScreenSizes.screenWidth / 2
    
    let buttonCoordinates: [(x: CGFloat, y: CGFloat)] = [
        (ScreenSizes.screenWidth / 2, 150), (ScreenSizes.screenWidth / 2 - 50, 240), (ScreenSizes.screenWidth / 2 + 50, 240), (ScreenSizes.screenWidth / 2 - 70, 330), (ScreenSizes.screenWidth / 2 + 70, 330),
            (ScreenSizes.screenWidth / 2, 405), (ScreenSizes.screenWidth / 2 - 85, 500), (ScreenSizes.screenWidth / 2 + 85, 500), (ScreenSizes.screenWidth / 2, 580), (ScreenSizes.screenWidth / 2 - 107, 650),
            (ScreenSizes.screenWidth / 2 + 107, 650), (ScreenSizes.screenWidth / 2, 700), (ScreenSizes.screenWidth / 2 - 107, 800), (ScreenSizes.screenWidth / 2 + 107, 800), (ScreenSizes.screenWidth / 2, 870)
        ]
        
        // Массив имен изображений кнопок
        let artifactImages: [String] = [
            "artifact1",
            "artifact2",
            "artifact3",
            "artifact4",
            "artifact5",
            "artifact6", "artifact7", "artifact8", "artifact9", "artifact10",
            "artifact11", "artifact12", "artifact13", "artifact14", "artifact15"
        ]
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("artifactsBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    
                    VStack(alignment: .center, spacing: 30) {
                            ZStack() {
                                // Кнопка с отступом 16px от левого края
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image("backButton")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 42)
                                        .position(x: 16 + 25, y: ScreenSizes.isSmallScreen ? 50 : 100) // Позиция по оси X с учетом отступа
                                }

                                // Image artifactsLabel, расположенный на том же уровне по y, что и кнопка
                                Image("artifactsLabel")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 194, height: 66)
                                    .position(x: geometry.size.width / 2, y: ScreenSizes.isSmallScreen ? 50 : 100) // Центрируем по X и ставим на 100 по Y
                            }
                        
                        ZStack(alignment: .top) {
                            Image("artifactImage")
                                .resizable()
                                .frame(width: 734, height: 972)
                                .position(x: geometry.size.width / 2, y: 100)
                            ForEach(0..<artifactImages.count, id: \.self) { index in
                                    Button {
                                        if LevelsDataModel.shared.isUnlocked(index + 2) {
                                            currentLvl = index + 1
                                            isInfo = true
                                        }
                                    } label: {
                                        if LevelsDataModel.shared.isUnlocked(index + 2) {
                                            Image("artifact\(index+1)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 82, height: 91)  // Размер изображения
                                        } else {
                                            Image("lvlImage\(index+1)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 71, height: 63)  // Размер изображения
                                        }
                                    }
                                    .position(x: buttonCoordinates[index].x, y: buttonCoordinates[index].y - 400)
                                }
                        }
                        
                    }
                    .frame(width: 734, height: 1100)
                    
                    if ScreenSizes.isSmallScreen {
                        Spacer(minLength: 200)
                    }
                    
                }
                .blur(radius: isInfo ? 5 : 0)
                
                if isInfo {
                    ArtifactInfoView(lvl: currentLvl) {
                        isInfo = false
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
