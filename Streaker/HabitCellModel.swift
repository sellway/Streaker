/*
 
Этот класс HabitCollectionViewCell:
1 - Определение UICollectionViewCell: Создайте пользовательский класс UICollectionViewCell, который будет отображать различные состояния клетки. Этот класс будет содержать все необходимые элементы пользовательского интерфейса для разных состояний.
 2 - Настройка Внешнего Вида: В вашем классе UICollectionViewCell, добавьте элементы пользовательского интерфейса, такие как UIView для линий, UIImageView для иконок и т.д. Эти элементы будут скрыты или отображаться в зависимости от состояния клетки.
 3 - Конфигурация Состояний: Реализуйте метод configure(with:) в вашем классе UICollectionViewCell. Этот метод будет принимать модель данных (например, HabitCellModel), которая содержит информацию о состоянии клетки, и на основе этой информации настраивать внешний вид клетки.

*/

import UIKit

// Модель данных для ячейки
struct HabitCellModel {
    enum State {
        case waiting(progress: Float)
        case completedWithTopLine
        case completedWithBottomLine
        case completedWithNoLine
        case notCompleted
        case paused
    }

    var state: State
    // Другие свойства, если нужны
}

// Класс ячейки UICollectionView
class HabitCollectionViewCell: UICollectionViewCell {
    // Элементы UI
    private let progressView = UIProgressView()
    private let topLineView = UIView()
    private let bottomLineView = UIView()
    private let crossImageView = UIImageView()
    private let pauseImageView = UIImageView()

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
        resetViews()
        switch model.state {
        case .waiting(let progress):
            progressView.isHidden = false
            progressView.progress = progress

        case .completedWithTopLine:
            topLineView.isHidden = false

        case .completedWithBottomLine:
            bottomLineView.isHidden = false

        case .completedWithNoLine: break
            // Ничего не отображается

        case .notCompleted:
            crossImageView.isHidden = false

        case .paused:
            pauseImageView.isHidden = false
        }
    }

    // Сброс видимости всех элементов
    private func resetViews() {
        progressView.isHidden = true
        topLineView.isHidden = true
        bottomLineView.isHidden = true
        crossImageView.isHidden = true
        pauseImageView.isHidden = true
    }
    
    private func hideAllElements() {
        progressView.isHidden = true
        topLineView.isHidden = true
        bottomLineView.isHidden = true
        crossImageView.isHidden = true
        pauseImageView.isHidden = true
    }

    // Настройка элементов UI
    private func setupViews() {
        addSubview(progressView)
        addSubview(topLineView)
        addSubview(bottomLineView)
        addSubview(crossImageView)
        addSubview(pauseImageView)

        // Настройка progressView
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])

        // Настройка topLineView
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = .systemBlue // Пример цвета
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 2) // Пример высоты
        ])

        // Настройка bottomLineView
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = .systemBlue // Пример цвета
        NSLayoutConstraint.activate([
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 2) // Пример высоты
        ])

        // Настройка crossImageView
        crossImageView.translatesAutoresizingMaskIntoConstraints = false
        crossImageView.contentMode = .scaleAspectFit
        crossImageView.image = UIImage(named: "cross") // Замените на ваше изображение
        NSLayoutConstraint.activate([
            crossImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            crossImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            crossImageView.widthAnchor.constraint(equalToConstant: 24), // Пример размера
            crossImageView.heightAnchor.constraint(equalToConstant: 24) // Пример размера
        ])

        // Настройка pauseImageView
        pauseImageView.translatesAutoresizingMaskIntoConstraints = false
        pauseImageView.contentMode = .scaleAspectFit
        pauseImageView.image = UIImage(named: "pause") // Замените на ваше изображение
        NSLayoutConstraint.activate([
            pauseImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pauseImageView.widthAnchor.constraint(equalToConstant: 24), // Пример размера
            pauseImageView.heightAnchor.constraint(equalToConstant: 24) // Пример размера
        ])
    }
}
