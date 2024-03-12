


class MainModel {
    // Data array of HabitCellModels for each habit
    internal private(set) var habitsData: [[HabitCellModel]] = []
    // Counter array for the number of cells (habits) per button
    var cellCounters: [Int] = []

    // Initializes model with the given number of buttons and cells per button
    init(numberOfButtons: Int, cellsPerButton: Int) {
        self.habitsData = Array(repeating: Array(repeating: HabitCellModel(state: .emptyCell), count: cellsPerButton), count: numberOfButtons)
        self.cellCounters = Array(repeating: 0, count: numberOfButtons)
    }

    // Updates habit cell data when a button is tapped
    func updateHabitData(forButtonIndex index: Int) {
        guard index < habitsData.count else { return }
        var newModels = habitsData[index]
        cellCounters[index] += 1
        // Replace first empty cell with a completed state or append a new cell model
        if let emptyCellIndex = newModels.firstIndex(where: { $0.state == .emptyCell }) {
            newModels[emptyCellIndex].state = .completedWithNoLine(counter: cellCounters[index])
        } else {
            newModels.append(HabitCellModel(state: .completedWithNoLine(counter: cellCounters[index])))
        }
        habitsData[index] = newModels
    }

    // Aligns rows in the collection view to have the same number of cells
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
