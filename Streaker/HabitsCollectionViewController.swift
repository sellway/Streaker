/*
 
Этот класс HabitsCollectionViewController:
1 - Создаёт и настраивает UICollectionView.
2 - Реализует протоколы UICollectionViewDataSource и UICollectionViewDelegateFlowLayout для управления данными и внешним видом клеток.
3 - Загружает модели данных для клеток и конфигурирует их в соответствии с состояниями.

*/

import UIKit
import SnapKit

class HabitsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var cellModels: [HabitCellModel] = [] // Массив моделей данных для клеток
    var buttonColor: UIColor?
    var buttonSize: CGSize = .zero
    var heightConstraint: Constraint? // Добавьте переменную для ограничения по высоте
    var bottomButtonConstraint: Constraint? // Ссылка на констрейнт кнопки снизу
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Теперь, когда Auto Layout применил ограничения, мы можем вычислить динамическое количество элементов
        let dynamicCount = calculateDynamicCount()
        loadCellModels(dynamicCount: dynamicCount)
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical
        //layout.itemSize = CGSize(width: 100, height: 100) // Установите размер элементов здесь
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        collectionView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    if let bottomButtonConstraint = self.bottomButtonConstraint {
                        make.bottom.equalTo(bottomButtonConstraint as! ConstraintRelatableTarget) // Используем переданный констрейнт
                    } else {
                        make.bottom.equalToSuperview() // Или делаем что-то по умолчанию, если констрейнт не передан
                    }
                    self.heightConstraint = make.top.equalToSuperview().constraint // Сохраните ограничение
                }
    }
    
    func updateCollectionViewHeight(newHeight: CGFloat) {
            self.heightConstraint?.update(offset: newHeight) // Используйте этот метод для обновления высоты
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    
    // Загрузка моделей данных для ячеек
    func loadCellModels(dynamicCount: Int) {
        cellModels = []

        for index in 0..<dynamicCount {
            if index % 2 == 0 {
                cellModels.append(HabitCellModel(state: .emptySpace))
            } else {
                cellModels.append(HabitCellModel(state: .emptyCell))
            }
        }
        
        if cellModels.last?.state == .emptySpace {
            cellModels.removeLast()
        }
    }
    
    // Обновленная функция calculateDynamicCount
    func calculateDynamicCount() -> Int {
//        let availableHeight = collectionView.frame.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom
//        let cellHeight = buttonSize.height + 16 // Предполагаем, что 16 - это высота emptySpace
//        let numberOfCells = Int(availableHeight / cellHeight)
//        let totalItems = numberOfCells * 2 - 1 // Убираем один emptySpace, если он последний
//        return max(totalItems, 0) // Убедимся, что не возвращаем отрицательное число
        return 14
    }

    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count // Возвращаем количество элементов, основываясь на массиве моделей
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectionViewCell else {
            fatalError("Unable to dequeue HabitCollectionViewCell")
        }
        let model = cellModels[indexPath.item]
        cell.configure(with: model) // Конфигурируем ячейку с моделью данных
        
        // Переворачиваем ячейку, чтобы контент отображался правильно
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Здесь вы можете настроить размер ячейки в зависимости от модели данных
        let model = cellModels[indexPath.item]
        switch model.state {
        case .emptyCell, .completedWithNoLine, .notCompleted, .progress:
            return buttonSize
        case .emptySpace:
            return CGSize(width: buttonSize.width, height: 16) // Размеры для emptySpace
        }
    }
    
}
