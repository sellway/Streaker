/*
 
Этот класс HabitCollectionViewCell:
1 - Определение UICollectionViewCell: Создайте пользовательский класс UICollectionViewCell, который будет отображать различные состояния клетки. Этот класс будет содержать все необходимые элементы пользовательского интерфейса для разных состояний.
 2 - Настройка Внешнего Вида: В вашем классе UICollectionViewCell, добавьте элементы пользовательского интерфейса, такие как UIView для линий, UIImageView для иконок и т.д. Эти элементы будут скрыты или отображаться в зависимости от состояния клетки.
 3 - Конфигурация Состояний: Реализуйте метод configure(with:) в вашем классе UICollectionViewCell. Этот метод будет принимать модель данных (например, HabitCellModel), которая содержит информацию о состоянии клетки, и на основе этой информации настраивать внешний вид клетки.

*/

import UIKit
import PocketSVG
import SnapKit

// Модель данных для ячейки
struct HabitCellModel {
    enum State {
        case emptyCell
        case completedWithNoLine
        case notCompleted
        case progress
        case emptySpace
    }

    var state: State
    // Другие свойства, если нужны
}

// Класс ячейки UICollectionView
class HabitCollectionViewCell: UICollectionViewCell {
    // Элементы UI
    private var emptySVGView: SVGImageView?
    private var completedWithNoLineSVGView: SVGImageView?
    private var notCompletedSVGView: SVGImageView?
    private var progressSVGView: SVGImageView?
    private var emptySpaceView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Настройка внешнего вида ячейки
    func configure(with model: HabitCellModel) {
        // Скрываем все элементы перед настройкой
        hideAllElements()
        switch model.state {
        case .emptyCell:
            emptySVGView?.isHidden = false
        case .completedWithNoLine:
            completedWithNoLineSVGView?.isHidden = false
        case .notCompleted:
            notCompletedSVGView?.isHidden = false
        case .progress:
            progressSVGView?.isHidden = false
        case .emptySpace:
            emptySpaceView?.isHidden = false
        }
    }

    // Сброс видимости всех элементов
    private func hideAllElements() {
        emptySVGView?.isHidden = true
        completedWithNoLineSVGView?.isHidden = true
        notCompletedSVGView?.isHidden = true
        progressSVGView?.isHidden = true
        emptySpaceView?.isHidden = true
    }

    // Настройка элементов UI
    private func setupViews() {
        emptySVGView = setupSVGView(withSVGNamed: "emptyCell")
        completedWithNoLineSVGView = setupSVGView(withSVGNamed: "completedWithNoLine")
        notCompletedSVGView = setupSVGView(withSVGNamed: "notCompleted")
        progressSVGView = setupSVGView(withSVGNamed: "progressView")
        emptySpaceView = setupEmptySpaceView()
    }

    private func setupSVGView(withSVGNamed name: String) -> SVGImageView {
        // Создаем SVGImageView с содержимым SVG файла
        guard let url = Bundle.main.url(forResource: name, withExtension: "svg") else {
            fatalError("SVG file named \(name) not found.")
        }
        let svgView = SVGImageView(contentsOf: url)
        
        // Настраиваем масштаб и положение SVGImageView
        svgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(svgView)
        
        // Устанавливаем констрейнты для SVGImageView
        NSLayoutConstraint.activate([
            svgView.topAnchor.constraint(equalTo: topAnchor),
            svgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            svgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            svgView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Скрываем SVG View по умолчанию
        svgView.isHidden = true
        
        return svgView
    }
    
    private func setupEmptySpaceView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        // Устанавливаем констрейнты для пространства
        NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: topAnchor),
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    view.heightAnchor.constraint(equalToConstant: 16) // Высота 16px
                ])
        view.isHidden = true
        return view
    }

}


