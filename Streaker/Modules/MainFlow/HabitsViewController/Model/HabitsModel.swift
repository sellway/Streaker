//
//  HabitsModel.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 26/1/24.
//

import Foundation

protocol HabitsModelProtocol {
    var cellCounter: Int { get }
    var cellModels: [HabitCellModel] { get set }

    func updateCellView()
    func moveCellUp(from sourceIndex: Int, to destinationIndex: Int)
}

class HabitsModel: HabitsModelProtocol {
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
