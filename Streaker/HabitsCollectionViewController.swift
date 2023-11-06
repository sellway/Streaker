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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadCellModels()
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100) // Установите размер элементов здесь
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // Загрузка моделей данных для ячеек
    func loadCellModels() {
        // Создайте достаточное количество моделей
        cellModels = (1...10).map { _ in HabitCellModel(state: .emptyCell) }
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
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Здесь вы можете настроить размер ячейки в зависимости от модели данных
        let model = cellModels[indexPath.item]
        switch model.state {
        case .emptySpace:
            return CGSize(width: collectionView.bounds.width, height: 16) // Размеры для emptySpace
        case .emptyCell, .completedWithNoLine, .notCompleted, .progress:
            return buttonSize
        }
    }
    
}
