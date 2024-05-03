/*

Этот класс HabitCell / HabitsModel:
1 - Моделирование данных привычки: Представляет собой объект Realm для хранения данных о привычке, включая имя, цвет, счетчик выполнений и список ячеек привычек (HabitCell)
2 - Управление состоянием ячеек привычек: Хранит и обрабатывает изменения состояний ячеек привычек, включая добавление и перемещение ячеек
3 - Реализация протокола HabitsModelProtocol: Обеспечивает функциональность для обновления вида и перемещения ячеек. Метод updateCellView() добавляет или обновляет ячейки на основе выполненных привычек, а moveCellUp(from:to:) перемещает ячейку в списке
4 - Интеграция с Realm: Взаимодействие с базой данных Realm для сохранения и загрузки данных привычек и их ячеек
 
 */

import RealmSwift
import Foundation

class HabitCell: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var stateType: String  // 'empty', 'completed', 'notCompleted', 'progress', 'emptySpace'
    @Persisted var counter: Int?      // используется для completedWithNoLine
    @Persisted var percentage: Double?  // используется для progress
    
    // Связь с объектом Habit, если необходима
    @Persisted(originProperty: "cells") var habit: LinkingObjects<HabitsModel>
}

protocol HabitsModelProtocol {
    var cellCounter: Int { get }
    var cellModels: [HabitCellModel] { get set }

    func updateCellView()
    func moveCellUp(from sourceIndex: Int, to destinationIndex: Int)
}

class HabitsModel: Object, HabitsModelProtocol {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var color: String = ""
    @Persisted var counter: Int = 0
    @Persisted var cells: List<HabitCell>  // Список клеток
    
    var cellCounter: Int = 0
    var cellModels: [HabitCellModel] = []

    func updateCellView() {
        cellCounter += 1

        // Создаем новую модель клетки с увеличенным счетчиком
        let newCellModel = HabitCellModel(state: .completedWithNoLine(counter: cellCounter))

        // Находим первую пустую клетку
        if let emptyCellIndex = cellModels.firstIndex(where: { $0.state == .emptyCell }) {
            // Заменяем первую пустую клетку на новую модель
            cellModels[emptyCellIndex] = newCellModel
        } else {
            // Если пустых клеток нет, добавляем новую модель в конец
            cellModels.append(newCellModel)
        }
    }

    func moveCellUp(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex >= 0, destinationIndex >= 0, sourceIndex < cellModels.count, destinationIndex < cellModels.count else {
            return
        }

        let sourceModel = cellModels[sourceIndex]
        cellModels.remove(at: sourceIndex)
        cellModels.insert(sourceModel, at: destinationIndex)
    }
}
