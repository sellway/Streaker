/*

Этот класс CreateNewStreakViewController:
1 - Управляет экраном для создания новой привычки, содержит представление CreateNewStreakView.
2 - Настраивает элементы интерфейса, включая навигационную панель с кнопками сохранения и отмены.
3 - Сохраняет новую привычку в базу данных и выводит все сохраненные привычки в консоль.

*/

import UIKit

class CreateNewStreakViewController: UIViewController {
    let createNewStreakView = CreateNewStreakView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createNewStreakView.cancelButton)
        createNewStreakView.cancelButton.addTarget(self, action: #selector(dissmis), for: .touchUpInside)
    }
    
    private func setupView() {
        // Add the createNewStreakView as a subview and set up constraints
        view.addSubview(createNewStreakView)
        createNewStreakView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "New Streak"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveStreak)
        )
    }
    
    @objc private func dissmis() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveStreak() {
        guard let streakName = createNewStreakView.streakNameTextField.text, !streakName.isEmpty else {
            print("Streak name is empty.")
            return
        }

        // Create an instance of HabitsModel
        let newHabit = HabitsModel()
        newHabit.name = streakName
        newHabit.color = "Green" // Example, replace with actual logic to choose a color

        // Save the new habit to Realm using HabitsDataManager
        HabitsDataManager.shared.saveHabitsToRealm(habitsModel: newHabit)

        print("Saving streak with name: \(streakName)")

        // Optionally, pop or dismiss the view controller
        navigationController?.popViewController(animated: true)
        
        // Вывод всех сохранённых привычек
        let allSavedHabits = HabitsDataManager.shared.loadAllHabitsFromRealm()
        for habit in allSavedHabits {
            print("Saved Habit: \(habit.name), Color: \(habit.color)")
        }
    }
}
