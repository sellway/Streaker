/*
 
 Этот класс HabitsCollectionViewController:
 1 - Создаёт и настраивает UICollectionView
 2 - Реализует протоколы UICollectionViewDataSource и UICollectionViewDelegateFlowLayout для управления данными и внешним видом клеток
 3 - Загружает модели данных для клеток и конфигурирует их в соответствии с состояниями.
 
 */

import UIKit
import SnapKit

// HabitsCollectionViewController manages the display and interaction with the collection of habit cells
class HabitsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HabitsModelProtocol {
    var cellCounter: Int = 0
    var habitsData: [[HabitCellModel]] = []
    var habitsCollectionViewControllers: [HabitsCollectionViewController] = []
    var buttons: [CustomButton] = []
    
    // Add this stub to conform to 'HabitsModelProtocol'
    func updateCellView() {
        // Update the view based on the cell data
        collectionView.reloadData()
    }

    func moveCellUp(from sourceIndex: Int, to destinationIndex: Int) {
        // Move the cell from the source index to the destination index
        guard sourceIndex < cellModels.count && destinationIndex < cellModels.count else {
            // Ensure that both indices are valid
            return
        }

        // Perform the move operation on the cellModels array
        let movedCell = cellModels.remove(at: sourceIndex)
        cellModels.insert(movedCell, at: destinationIndex)

        // Update the collection view to reflect the changes
        collectionView.reloadData()
    }

    // Collection view to show habit cells
    var collectionView: UICollectionView!
        // Models for each cell, triggering updates on change
        var cellModels: [HabitCellModel] = [] {
            didSet {
                updateHabitsCollectionViews()
            }
        }
    
    var habitsModel: HabitsModelProtocol = HabitsModel() // Model containing the habit data
    var buttonColor: UIColor?
    var buttonSize: CGSize = .zero
    
    // Array to hold references for synchronized scrolling
    static var synchronizedCollectionViews: [HabitsCollectionViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView() // Инициализация и настройка коллекции
        // Добавляем текущий экземпляр в массив синхронизированных экземпляров
        HabitsCollectionViewController.synchronizedCollectionViews.append(self)
        // Перемещаем коллекцию на задний план
        view.sendSubviewToBack(collectionView)
    }
    
    // Initializes and configures the collection view
    private func setupCollectionView() {
        // Define layout properties for the collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Set the scroll direction to vertical
        layout.itemSize = CGSize(width: 0, height: 0)
        layout.minimumLineSpacing = 0 // Set spacing between lines to 0
        layout.minimumInteritemSpacing = 0 // Set spacing between items to 0
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let safeAreaTop = windowScene.windows.first?.safeAreaInsets.top ?? 0.0
                // 88 height of customNavBar
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 88 + safeAreaTop, right: 0)
            }
        // Create the collection view with the defined layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        collectionView.dataSource = self // Set the data source for the collection view
        collectionView.delegate = self // Set the delegate for the collection view
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        
        // Add the collection view to the view hierarchy and set constraints
        view.addSubview(collectionView)
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        // Перемещаем коллекцию на задний план, чтобы кнопки были впереди
        view.sendSubviewToBack(collectionView)
    }
    
    // Method to update the model in all HabitsCollectionViewControllers
    private func updateHabitsCollectionViews() {
        for habitsVC in habitsCollectionViewControllers {
            habitsVC.cellModels = cellModels
            habitsVC.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count // Returning the number of elements based on the model array
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
        // Here you can adjust the cell size depending on the data model
        let model = cellModels[indexPath.item]
        switch model.state {
        case .emptyCell, .completedWithNoLine, .notCompleted, .progress:
            return CGSize(width: buttonSize.width, height: buttonSize.height + (buttonSize.height * 0.200))
        case .emptySpace:
            return CGSize(width: buttonSize.width, height: 0) // Dimensions for the stripe below the buttons
        }
    }
    
    // Scroll synchronization
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for synchronizedVC in HabitsCollectionViewController.synchronizedCollectionViews {
            if synchronizedVC != self {
                synchronizedVC.collectionView.contentOffset = scrollView.contentOffset
            }
        }
    }
}
