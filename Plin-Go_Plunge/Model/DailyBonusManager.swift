
import Foundation
import SwiftUI

class DailyBonusManager: ObservableObject {
    static let shared = DailyBonusManager()
    
    // MARK: - UserDefaults Keys
    private let lastClaimKey = "dailyBonusLastClaim1"
    private let bonusDayKey = "dailyBonusDayKey1"
    
    // MARK: - Published Properties для обновления UI
    @Published var isBonusActive: Bool = false
    @Published var timeRemaining: String = "00:00"  // формат hh:mm
    @Published var currentBonusDay: Int = 1         
    
    var progressImageName: String {
        return "progress\(currentBonusDay - 1)"
    }
    
    // Дата последнего бонуса
    private var lastClaimDate: Date {
        didSet {
            UserDefaults.standard.set(lastClaimDate.timeIntervalSince1970, forKey: lastClaimKey)
        }
    }
    
    private var timer: Timer?
    
    // MARK: - Инициализация
    private init() {
        // Загружаем дату последнего бонуса из UserDefaults.
        let savedTimeInterval = UserDefaults.standard.double(forKey: lastClaimKey)
        if savedTimeInterval == 0 {
            // Если данных нет, устанавливаем lastClaimDate так, чтобы бонус был доступен сразу:
            self.lastClaimDate = Date().addingTimeInterval(-24 * 3600)
            UserDefaults.standard.set(lastClaimDate.timeIntervalSince1970, forKey: lastClaimKey)
        } else {
            self.lastClaimDate = Date(timeIntervalSince1970: savedTimeInterval)
        }
        
        // Загружаем текущий день бонуса (если отсутствует, начинаем с 1)
        let savedBonusDay = UserDefaults.standard.integer(forKey: bonusDayKey)
        self.currentBonusDay = savedBonusDay == 0 ? 1 : savedBonusDay
        
        updateBonusState()
        startTimer()
    }

    
    // MARK: - Таймер обновления
    private func startTimer() {
        timer?.invalidate()
        // Обновляем состояние каждую минуту
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateBonusState()
        }
    }
    
    /// Обновление состояния бонуса:
    /// - Если с момента последнего бонуса прошло менее 24 часов – бонус не доступен, обновляем оставшееся время.
    /// - Если 24 часа прошли, бонус доступен.
    /// - Если бонус доступен, но прошло больше 48 часов (день пропущен) – сбрасываем streak до первого дня.
    private func updateBonusState() {
        let now = Date()
        let bonusAvailableTime = lastClaimDate.addingTimeInterval(24 * 3600)
        let claimDeadline = lastClaimDate.addingTimeInterval(48 * 3600)
        
        if now < bonusAvailableTime {
            // Бонус ещё не доступен
            isBonusActive = false
            let remaining = bonusAvailableTime.timeIntervalSince(now)
            let hours = Int(remaining) / 3600
            let minutes = (Int(remaining) % 3600) / 60
            timeRemaining = String(format: "%02d:%02d", hours, minutes)
        } else {
            // Бонус доступен для получения
            isBonusActive = true
            timeRemaining = "00:00"
            // Если бонус доступен уже больше 24 часов (т.е. пропущен день) – сбрасываем streak
            if now > claimDeadline && currentBonusDay != 1 {
                currentBonusDay = 1
                UserDefaults.standard.set(currentBonusDay, forKey: bonusDayKey)
            }
        }
    }
    
    // MARK: - Получение бонуса (вызывается при нажатии на takeButton)
    func claimBonus() {
        let now = Date()
        let bonusAvailableTime = lastClaimDate.addingTimeInterval(24 * 3600)
        // Если бонус доступен
        if now >= bonusAvailableTime {
            // Определяем бонус в зависимости от текущего дня
            var bonusAmount = 30
            switch currentBonusDay {
            case 1: bonusAmount = 30
            case 2: bonusAmount = 50
            case 3: bonusAmount = 70
            case 4: bonusAmount = 90
            case 5: bonusAmount = 110
            default: bonusAmount = 30
            }
            
            // Добавляем кристаллы через CristalsManager
            CristalsManager.shared.addCristals(bonusAmount)
            
            // Проверяем, не пропущен ли день:
            // Если бонус получен в течение 24 часов после его появления, то продолжаем streak.
            // Если бонус получен позже – сбрасываем на первый день.
            let claimDeadline = lastClaimDate.addingTimeInterval(48 * 3600)
            if now <= claimDeadline {
                // Продолжаем streak (с максимумом в 5 дней)
                if currentBonusDay < 5 {
                    currentBonusDay += 1
                } else {
                    currentBonusDay = 1
                }
            } else {
                // День пропущен – сбрасываем прогресс
                currentBonusDay = 1
            }
            UserDefaults.standard.set(currentBonusDay, forKey: bonusDayKey)
            
            // Обновляем дату последнего бонуса – таймер начинается заново
            lastClaimDate = now
            updateBonusState()
        }
    }
}
