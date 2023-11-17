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
    
    // Хранение всех HabitsCollectionViewController, которые должны синхронизировать скролл
    static var synchronizedCollectionViews: [HabitsCollectionViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadCellModels()
        collectionView.reloadData()
        
        // Добавляем текущий экземпляр в массив синхронизированных экземпляров
        HabitsCollectionViewController.synchronizedCollectionViews.append(self)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100) // Установите размер элементов здесь
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        
        view.addSubview(collectionView)
        
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        collectionView.snp.makeConstraints { make in
                    make.top.equalTo(view.snp.top)
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(view.snp.bottom)
                }
    }
    
    // Загрузка моделей данных для ячеек
    func loadCellModels() {
        cellModels = []
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
            return CGSize(width: buttonSize.width, height: 0) // Размеры для полоски внизу над кнопками
        }
    }
    
    // Синхронизация скролла
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for synchronizedVC in HabitsCollectionViewController.synchronizedCollectionViews {
            if synchronizedVC != self {
                synchronizedVC.collectionView.contentOffset = scrollView.contentOffset
            }
        }
    }
}

