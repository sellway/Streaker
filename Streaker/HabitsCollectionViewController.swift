/*
 
 Этот класс HabitsCollectionViewController:
 1 - Создаёт и настраивает UICollectionView
 2 - Реализует протоколы UICollectionViewDataSource и UICollectionViewDelegateFlowLayout для управления данными и внешним видом клеток
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
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100) // Размер элементов
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // Загрузка моделей данных для ячеек
    func loadCellModels() {
        cellModels = []
    }
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count // Возвращаем количество элементов
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectionViewCell else {
            fatalError("Unable to dequeue HabitCollectionViewCell")
        }
        let model = cellModels[indexPath.item]
        cell.configure(with: model)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Здесь вы можете настроить размер ячейки в зависимости от модели данных
        let model = cellModels[indexPath.item]
        switch model.state {
        case .emptyCell, .completedWithNoLine, .notCompleted, .progress:
            return CGSize(width: buttonSize.width, height: buttonSize.height + (buttonSize.height * 0.216))
        case .emptySpace:
            return CGSize(width: buttonSize.width, height: 0) // Размеры для emptySpace
        }
    }
    
}
