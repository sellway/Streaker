


class MainModel {
    internal private(set) var habitsData: [[HabitCellModel]] = []
    var cellCounters: [Int] = []

    // Инициализатор
    init(numberOfButtons: Int, cellsPerButton: Int) {
        self.habitsData = Array(repeating: Array(repeating: HabitCellModel(state: .emptyCell), count: cellsPerButton), count: numberOfButtons)
        self.cellCounters = Array(repeating: 0, count: numberOfButtons)
    }

    // Функция для обновления состояния клеток при нажатии на кнопку
    func updateHabitData(forButtonIndex index: Int) {
        guard index < habitsData.count else { return }
        var newModels = habitsData[index]
        cellCounters[index] += 1

        if let emptyCellIndex = newModels.firstIndex(where: { $0.state == .emptyCell }) {
            newModels[emptyCellIndex].state = .completedWithNoLine(counter: cellCounters[index])
        } else {
            newModels.append(HabitCellModel(state: .completedWithNoLine(counter: cellCounters[index])))
        }

        habitsData[index] = newModels
    }

    // Метод для выравнивания количества клеток во всех рядах
    func alignCellRows() {
        let maxCellCount = habitsData.map { $0.count }.max() ?? 0
        for i in 0..<habitsData.count {
            let currentCount = habitsData[i].count
            if currentCount < maxCellCount {
                habitsData[i].append(contentsOf: Array(repeating: HabitCellModel(state: .emptyCell), count: maxCellCount - currentCount))
            }
        }
    }

    // TODO: Добавьте сюда дополнительную логику, например, управление таймером
}
