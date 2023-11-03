/*
 
Этот класс HabitsCollectionViewController:
1 - Создаёт и настраивает UICollectionView.
2 - Реализует протоколы UICollectionViewDataSource и UICollectionViewDelegateFlowLayout для управления данными и внешним видом клеток.
3 - Загружает модели данных для клеток и конфигурирует их в соответствии с состояниями.

*/

import UIKit

class HabitsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var cellModels: [HabitCellModel] = [] // Массив моделей данных для клеток
    var buttonColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadCellModels() // Загрузка данных для клеток
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100) // Размеры клеток

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadCellModels() {
        // Загрузка или создание данных для клеток
        cellModels = [
            HabitCellModel(state: .waiting(progress: 0.5)),
            HabitCellModel(state: .completedWithTopLine),
            // Добавьте другие состояния для тестирования
        ]
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectionViewCell else {
            fatalError("Unable to dequeue HabitCollectionViewCell")
        }
        let model = cellModels[indexPath.item]
        cell.configure(with: model)
        cell.backgroundColor = buttonColor // Установка цвета фона ячейки
        return cell
    }

    
    

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Размеры клеток можно настроить здесь
        return CGSize(width: 100, height: 100)
    }

    // Добавьте другие методы для обработки нажатий на клетки, если нужно
}
