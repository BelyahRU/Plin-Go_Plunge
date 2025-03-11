import SwiftUI

struct LevelsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentPage = 0
    @State var isGame = false
    @State var currentLevel = 0
    let totalLevels = 15
    let levelsPerPage = 4
    let maxPage = (15 - 1) / 4
    
    var body: some View {
        ZStack {
            if isGame {
                GameView(currentLevel: currentLevel, onMain: {
                    presentationMode.wrappedValue.dismiss()
                })
                    .edgesIgnoringSafeArea(.all)
            } else {
                ZStack {
                    ZStack(alignment: .top) {
                        Image("levelsBackground")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 42)
                                
                        }
                        .frame(width: 50, height: 42)
                        .position(x: 16 + 25, y: ScreenSizes.isSmallScreen ? 110 : 90) // Позиция по оси X с учетом отступа
                        
                        let startIndex = currentPage * levelsPerPage
                        let endIndex = min(startIndex + levelsPerPage, totalLevels)
                        
                        ZStack {
                            Image("selectLvlBack")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 343, height: 429)
                            
            //                Spacer(minLength: 20)
                            VStack(spacing: -7) {
                                
                                HStack(spacing: 20) {
                                    ForEach(startIndex..<min(startIndex + 2, endIndex), id: \.self) { index in
                                        let levelNumber = index + 1
                                        if !LevelsDataModel.shared.isUnlocked(levelNumber) {
                                            Image("lvlLockedd")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 93, height: 140)
                                                .padding(10)
                                        } else {
                                            VStack(spacing: -10) {
                                                Button {
                                                    if HeardsManager.shared.currentHeards != 0 {
                                                        currentLevel = levelNumber
                                                        isGame = true
                                                    }
                                                    
                                                } label: {
                                                    Image("lvl\(levelNumber)")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 93, height: 97)
                                                }
                                                .frame(width: 93, height: 97)
                                                .padding(10)
                                                Text("Best time:")
                                                    .font(.custom("Kavoon-Regular", size: 23))
                                                    .foregroundStyle(Color(red: 32/255, green: 102/255, blue: 173/255))
                                                Text("120s")
                                                    .font(.custom("Amiri-Bold", size: 23))
                                                    .foregroundStyle(Color(red: 32/255, green: 102/255, blue: 173/255))
                                            }
                                        }
                                    }
                                }
                                
                                // Второй ряд
                                HStack(spacing: 20) {
                                    // Проверяем, если это последняя страница, и уровней меньше 4
                                    ForEach(min(startIndex + 2, endIndex)..<min(startIndex + 4, endIndex), id: \.self) { index in
                                        let levelNumber = index + 1
                                        if !LevelsDataModel.shared.isUnlocked(levelNumber) {
                                            Image("lvlLockedd")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 93, height: 140)
                                                .padding(10)
                                                .padding(.leading, levelNumber == 15 ? 50 : 0)
                                        } else {

                                            VStack(spacing: -10) {
                                                Button {
                                                    if HeardsManager.shared.currentHeards != 0 {
                                                        currentLevel = levelNumber
                                                        isGame = true
                                                    }
                                                } label: {
                                                    Image("lvl\(levelNumber)")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 93, height: 97)
                                                }
                                                .frame(width: 93, height: 97)
                                                .padding(10)
                                                Text("Best time:")
                                                    .font(.custom("Kavoon-Regular", size: 23))
                                                    .foregroundStyle(Color(red: 32/255, green: 102/255, blue: 173/255))
                                                Text("120s")
                                                    .font(.custom("Amiri-Bold", size: 23))
                                                    .foregroundStyle(Color(red: 32/255, green: 102/255, blue: 173/255))
                                                
                                            }
                                            .padding(.leading, levelNumber == 15 ? 50 : 0)
                                        }
                                    }
                                    
                                    // Если на последней странице и уровней меньше 4, добавляем Spacer()
                                    if endIndex == totalLevels && startIndex + 4 > totalLevels {
                                        Spacer(minLength: 0)  // Добавляем пустое пространство, чтобы 15-й уровень не был по центру
                                    }
                                }
                            }
                            .padding(.top, 75)
                        }
                        .frame(width: 343, height: 429)
                        .position(x: ScreenSizes.screenWidth / 2, y: ScreenSizes.screenHeight / 2 - (ScreenSizes.isSmallScreen ? 0: 100))
                        
                        // Кнопка для перехода на предыдущую страницу
                        if currentPage > 0 {
                            Button {
                                print(currentPage)
                                print("left")
                                if currentPage > 0 {
                                    currentPage -= 1
                                }
                            } label: {
                                Image("leftlvlButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 74, height: 75)
                            }
                            .frame(width: 74, height: 75)
                            .position(x: 52, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 70: 150))
                        }
                        
                        // Кнопка для перехода на следующую страницу
                        if currentPage < maxPage {
                            Button {
                                print(currentPage)
                                print("right")
                                if currentPage < maxPage {
                                    currentPage += 1
                                }
                            } label: {
                                Image("rightlvlButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 74, height: 75)
                            }
                            .frame(width: 74, height: 75)
                            .position(x: ScreenSizes.screenWidth - 52, y: ScreenSizes.screenHeight - (ScreenSizes.isSmallScreen ? 70: 150))
                        }
                    }
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.all)
                    
                    
                }
                
            }
        }
        
    }
}
