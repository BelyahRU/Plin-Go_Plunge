import Foundation
import Combine

final class HeardsManager: ObservableObject {
    
    static let shared = HeardsManager()
    
    private let heardsKey = "heardsKey111"
    private let lastUpdateKey = "lastUpdateKey111"
    private var timer: Timer?
    
    @Published var currentHeards: Int
    @Published var timeRemaining: String = "00:00" // Отображаемое время

    private var storedHeards: Int {
        didSet {
            UserDefaults.standard.set(storedHeards, forKey: heardsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var lastUpdate: Date? {
        didSet {
            // Сохраняем время последнего обновления в виде TimeInterval
            if lastUpdate != nil {
                UserDefaults.standard.set(lastUpdate!.timeIntervalSince1970, forKey: lastUpdateKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    private init() {
        let savedTimeInterval = UserDefaults.standard.double(forKey: lastUpdateKey)
        // Если savedTimeInterval равен 0, возможно, ключ не был установлен, поэтому сохраняем текущее время
        print(savedTimeInterval)
        if savedTimeInterval == 0 {
            self.lastUpdate = Date()
            UserDefaults.standard.set(lastUpdate!.timeIntervalSince1970, forKey: lastUpdateKey)
        } else {
            self.lastUpdate = Date(timeIntervalSince1970: savedTimeInterval)
        }
        
        self.storedHeards = UserDefaults.standard.object(forKey: heardsKey) as? Int ?? 3
        self.currentHeards = self.storedHeards
        updateHeards()
        startTimer() // Запуск таймера
    }

    public func boughtHeards(_ amount: Int) {
        storedHeards += amount
        self.currentHeards = self.storedHeards
        if currentHeards >= 3 {
            lastUpdate = nil
            timeRemaining = "Full"
            UserDefaults.standard.removeObject(forKey: lastUpdateKey)
            startTimer()
        }
    }
    
    private func addHeards(_ count: Int) {
        if currentHeards < 3 {
            storedHeards = min(3, currentHeards + count)
            self.currentHeards = self.storedHeards
            lastUpdate = Date() // Обновляем время последнего обновления
        } else {
            lastUpdate = nil
            timeRemaining = "Full"
            UserDefaults.standard.removeObject(forKey: lastUpdateKey)
            startTimer()
        }
    }
    
    public func subtractHeards(_ count: Int) -> Bool {
        if currentHeards >= count {
            storedHeards -= count
            self.currentHeards = self.storedHeards
            // Если теперь сердец меньше 3, запускаем таймер с новым lastUpdate
            if currentHeards < 3 {
                lastUpdate = Date() // Устанавливаем время начала отсчёта заново
            }
            startTimer()
            return true
        } else {
            return false
        }
    }

    
    private func startTimer() {
        // Инвалидируем старый таймер, если он существует
        timer?.invalidate()
        
        // Таймер для обновления каждую секунду
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateHeards()
        }
    }
    
    private func updateHeards() {
        // Вычисляем прошедшее время с последнего обновления
        guard let last = lastUpdate else {return}
        let timeElapsed = Date().timeIntervalSince(lastUpdate!)
        
        // Если прошло больше часа, добавляем сердца
        if timeElapsed >= 3600 && currentHeards < 3 {
            let newHeards = Int(timeElapsed / 3600)
            addHeards(newHeards)
            // Сдвигаем lastUpdate на полные часы, а не сбрасываем его
            lastUpdate = lastUpdate!.addingTimeInterval(Double(newHeards * 3600))
        }
        
        updateTimeRemaining(timeElapsed: Date().timeIntervalSince(lastUpdate!))
    }

    
    private func updateTimeRemaining(timeElapsed: TimeInterval) {
        // Если сердечек меньше 3, показываем оставшееся время до следующего сердечка
        if currentHeards < 3 {
            let remainingTime = max(0, 3600 - timeElapsed)
            let minutes = Int(remainingTime) / 60
            let seconds = Int(remainingTime) % 60
            timeRemaining = String(format: "%02d:%02d", minutes, seconds)
        } else {
            // Если 3 или больше сердечек, показываем "Full"
            timeRemaining = "Full"
        }
    }
}
