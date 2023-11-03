

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var buttons: [CustomButton] = []
    private var blurEffectView: UIVisualEffectView?
    private var habitsCollectionViewController: HabitsCollectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        setupButtons()
        createBlurBackground()
        setupHabitsCollectionViewController()
    }

    private func setupButtons() {
        let totalButtons = 4
        for index in 0..<totalButtons {
            let button = CustomButton()
            button.scaleButtonElements(forScreenWidth: view.bounds.width)
            button.setPositionAtBottomCenter(in: view, index: index, totalButtons: totalButtons)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            view.addSubview(button)
        }
    }

    @objc private func buttonTapped(_ sender: CustomButton) {
        // Обновите данные в HabitsCollectionViewController в зависимости от нажатой кнопки
        // Например, измените cellModels или переключите на другой контроллер
    }

    private func setupHabitsCollectionViewController() {
        let habitsVC = HabitsCollectionViewController()
        addChild(habitsVC)
        view.addSubview(habitsVC.view)
        habitsVC.view.translatesAutoresizingMaskIntoConstraints = false
        habitsVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(blurEffectView!.snp.top)
        }
        habitsVC.didMove(toParent: self)
        habitsCollectionViewController = habitsVC
    }

    // Остальные методы ViewController...
}



// MARK: - Blur Background Handling
extension ViewController {
    private func createBlurBackground() {
        // Блюр-подложка
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.translatesAutoresizingMaskIntoConstraints = false
        if let blurEffectView = blurEffectView {
            view.insertSubview(blurEffectView, at: 0)
        }
    }

    private func updateBlurBackgroundPositionAndSize() {
        if let referenceButton = buttons.first, let blurEffectView = blurEffectView {
            let buttonFrame = view.convert(referenceButton.frame, from: referenceButton.superview)
            let bottomPadding = view.bounds.height - buttonFrame.maxY
            let blurBackgroundHeight = bottomPadding + buttonFrame.height / 2

            blurEffectView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(blurBackgroundHeight)
            }
        }
    }
}













// MARK: - Работающий код ViewController без ViewCollection

//import UIKit
//import SnapKit
//
//class ViewController: UIViewController {
//    private var buttons: [CustomButton] = []
//    private var blurEffectView: UIVisualEffectView?
//    private var habitsCollectionViewController: HabitsCollectionViewController?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
//        setupButtons()
//        createBlurBackground()
//        setupHabitsCollectionViewController()
//    }
//
//    private func setupButtons() {
//        let totalButtons = 4
//        for index in 0..<totalButtons {
//            let button = CustomButton()
//            button.scaleButtonElements(forScreenWidth: view.bounds.width)
//            button.setPositionAtBottomCenter(in: view, index: index, totalButtons: totalButtons)
//            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            buttons.append(button)
//            view.addSubview(button)
//        }
//    }
//
//    @objc private func buttonTapped(_ sender: CustomButton) {
//        // Обновите данные в HabitsCollectionViewController в зависимости от нажатой кнопки
//        // Например, измените cellModels или переключите на другой контроллер
//    }
//
//    private func setupHabitsCollectionViewController() {
//        let habitsVC = HabitsCollectionViewController()
//        addChild(habitsVC)
//        view.addSubview(habitsVC.view)
//        habitsVC.view.translatesAutoresizingMaskIntoConstraints = false
//        habitsVC.view.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(blurEffectView!.snp.top)
//        }
//        habitsVC.didMove(toParent: self)
//        habitsCollectionViewController = habitsVC
//    }
//
//    // Остальные методы ViewController...
//}




// MARK: - Setup DataSource и Delegate
//extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return buttons.count // Количество клеток равно количеству кнопок
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectionViewCell else {
//            fatalError("Unable to dequeue HabitCell")
//        }
//        // Настройте клетку
//        return cell
//    }
//
//    // Другие методы delegate, если нужны
//}



// MARK: - Setup Collection View
//extension ViewController {
//    func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: view.frame.width / 4, height: 74) // Размер клетки
//        layout.minimumLineSpacing = 0 // Без отступов между клетками
//
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        view.addSubview(collectionView)
//
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(buttons.first!.snp.top) // Предполагая, что у вас есть ссылка на первую кнопку
//            make.height.equalTo(74) // Начальная высота, которая будет изменяться динамически
//        }
//    }
//
//    func updateCollectionViewHeight() {
//        let totalCells = // Вычислите общее количество клеток, которые должны отображаться
//        let newHeight = CGFloat(totalCells) * 74 // Высота = количество клеток * высота одной клетки
//        collectionView.snp.updateConstraints { make in
//            make.height.equalTo(newHeight)
//        }
//    }
//}

