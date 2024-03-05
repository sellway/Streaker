//
//  MyStreaksViewController.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 5/3/24.
//

import UIKit
import RealmSwift

class MyStreaksViewController: UIViewController {
    var myStreaksView = MyStreaksView()

    private var habits: Results<HabitsModel>!

    override func loadView() {
        view = myStreaksView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myStreaksView.tableView.delegate = self
        myStreaksView.tableView.dataSource = self

        loadHabits()
    }

    private func loadHabits() {
        do {
            let realm = try Realm()
            habits = realm.objects(HabitsModel.self)
            myStreaksView.tableView.reloadData()
        } catch {
            print("Error loading habits from Realm: \(error)")
        }
    }
}

extension MyStreaksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let habit = habits[indexPath.row]
        cell.textLabel?.text = habit.name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteHabit(at: indexPath)
        }
    }

    private func deleteHabit(at indexPath: IndexPath) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(habits[indexPath.row])
            }
            // Убедитесь, что у вас есть доступ к tableView из MyStreaksView, если он объявлен там
            myStreaksView.tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error deleting habit: \(error)")
        }
    }
}
