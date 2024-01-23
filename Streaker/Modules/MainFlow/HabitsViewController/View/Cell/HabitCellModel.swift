/*
 
 Этот класс HabitCollectionViewCell:
 1 - Создает UICollectionViewCell, который отображает различные состояния клетки и содержит все необходимые элементы для разных состояний
 2 - Настраивает внешний вид с помощью UIView для линий, UIImageView для иконок и т.д.
 3 - Метод configure(with:) будет принимать модель данных (например, HabitCellModel), которая содержит информацию о состоянии клетки, и на основе этой информации настраивать внешний вид клетки
 
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
    private var emptyCellView: UIView?
    private var completedWithNoLineSVGView: SVGImageView?
    private var notCompletedView: UIView?
    private var progressSVGView: SVGImageView?
    private var emptySpaceView: SVGImageView?
    
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
            emptyCellView?.isHidden = false
        case .completedWithNoLine:
            completedWithNoLineSVGView?.isHidden = false
        case .notCompleted:
            notCompletedView?.isHidden = false
        case .progress:
            progressSVGView?.isHidden = false
        case .emptySpace:
            emptySpaceView?.isHidden = false
        }
    }
    
    // Сброс видимости всех элементов
    private func hideAllElements() {
        emptyCellView?.isHidden = true
        completedWithNoLineSVGView?.isHidden = true
        notCompletedView?.isHidden = true
        progressSVGView?.isHidden = true
        emptySpaceView?.isHidden = true
    }
    
    // Настройка элементов UI
    private func setupViews() {
        setupEmptyCellView()
        setupNotCompletedView()
        completedWithNoLineSVGView = setupSVGView(withSVGNamed: "completedWithNoLine")
        progressSVGView = setupSVGView(withSVGNamed: "progressView")
        emptySpaceView = setupSVGView(withSVGNamed: "emptySpace")
    }
    
    private func setupEmptyCellView() {
        let view = createContainerView()
        let borderContainerView = createBorderView(borderColorHex: "252528", cornerRadius: 16)
        view.addSubview(borderContainerView)
        centerView(borderContainerView, in: view, withHeight: CustomButton.buttonSize.height)
        view.isHidden = true
        emptyCellView = view
    }

    private func setupNotCompletedView() {
        let view = createContainerView()
        let borderContainerView = createBorderView(borderColorHex: "37373A", cornerRadius: 16)
        view.addSubview(borderContainerView)
        centerView(borderContainerView, in: view, withHeight: CustomButton.buttonSize.height)
        
        let crossImageView = setupSVGView(withSVGNamed: "cross")
        crossImageView.isHidden = false // Убедитесь, что SVGImageView не скрыт
        borderContainerView.addSubview(crossImageView)
        
        // Установка констрейнтов для crossImageView, чтобы размеры менялись пропорционально
        NSLayoutConstraint.activate([
            crossImageView.centerXAnchor.constraint(equalTo: borderContainerView.centerXAnchor),
            crossImageView.centerYAnchor.constraint(equalTo: borderContainerView.centerYAnchor),
            crossImageView.widthAnchor.constraint(equalTo: borderContainerView.widthAnchor, multiplier: 12/74),
            crossImageView.heightAnchor.constraint(equalTo: crossImageView.widthAnchor)
        ])
        
        notCompletedView = view
    }
    
    // MARK: - Helper Methods
    private func createContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        addSubview(view)
        view.constrainToEdges(of: self)
        return view
    }

    private func createBorderView(borderColorHex: String, cornerRadius: CGFloat) -> UIView {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .clear
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(hex: borderColorHex)?.cgColor
        borderView.layer.cornerRadius = cornerRadius
        borderView.clipsToBounds = true
        return borderView
    }

    private func centerView(_ viewToCenter: UIView, in containerView: UIView, withHeight height: CGFloat? = nil) {
        NSLayoutConstraint.activate([
            viewToCenter.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            viewToCenter.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            viewToCenter.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        if let height = height {
            viewToCenter.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
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
            svgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            svgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            svgView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1), // Пример множителя
            svgView.heightAnchor.constraint(equalTo: svgView.widthAnchor) // Сохраняем пропорции
        ])
        
        // Скрываем SVG View по умолчанию
        svgView.isHidden = true
        
        return svgView
    }

    
}

// MARK: - UIView Extensions
extension UIView {
    func constrainToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        let hexColorString: String

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColorString = String(hex[start...])
        } else {
            hexColorString = hex
        }

        let scanner = Scanner(string: hexColorString)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            switch hexColorString.count {
            case 6: // RGB (24-bit)
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000FF) / 255
                a = 1.0
            case 8: // ARGB (32-bit)
                r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000FF) / 255
            default:
                return nil
            }

            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }

        return nil
    }
}
