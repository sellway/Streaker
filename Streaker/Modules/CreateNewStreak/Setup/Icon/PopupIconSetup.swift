//  PopupIconSetup.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 19/7/24.
//

import UIKit
import SnapKit

protocol PopupIconSetupDelegate: AnyObject {
    func didSelectIcon(_ iconName: String)
}

class PopupIconSetup: UIViewController {
    
    weak var delegate: PopupIconSetupDelegate?
    var selectedIcon: String = "plus_ic"
    var onIconSelected: ((String) -> Void)?
    
    // Define the icons array as a property of the class
    private let icons: [String] = [
        "plus_ic", "family_time_ic", "star_ic", "paint_ic", "sort_out_emails_ic", "cross_ic",
        "fire_ic", "eat_fruits_ic", "run_ic", "volunteer_ic", "make_todolist_ic", "phone_ic",
        "morning_ic", "gym_ic", "ride_a_bike_ic", "generate_ideas_ic", "log_my_time_ic", "awward_ic",
        "8_hours_sleep_ic", "go_for_a_walk_ic", "swim_ic", "have_some_fun_ic", "listen_podcast_ic", "drugs_ic",
        "morning_gym_ic", "time_for_myself_ic", "yoga_ic", "be_grateful_ic", "learn_new_skill_ic", "doctor_ic",
        "mental_ic", "healthy_meal_ic", "stretch_ic", "go_to_nature_ic", "try_new_things_ic", "pets_ic",
        "learn_ic", "flossing_ic", "take_vitamins_ic", "deep_breathing_ic", "meet_sunrise_ic", "flight_ic",
        "relationship_ic", "make_my_bed_ic", "cook_ic", "write_journal_ic", "friends_time_ic", "boat_ic",
        "money_ic", "early_wake_up_ic", "no_sugar_ic", "sleep_by_10_ic", "call_parents_ic", "photo_ic",
        "home_ic", "visualisation_ic", "no_fried_food_ic", "no_gadgets_ic", "surprise_gift_ic", "fix_ic",
        "growth_ic", "no_caffeine_ic", "fasting_ic", "rethink_my_day_ic", "hug_kiss_ic", "yoga_ic",
        "focus_on_goals_ic", "read_ic", "drink_water_ic", "affirmations_ic", "pay_your_bills_ic", "track_spendings_ic",
        "save_money_ic", "meditate_ic", "plan_spending_ic", "make_donation_ic", "do_shopping_list_ic", "water_the_plants_ic",
        "take_out_trash_ic", "clean_up_ic", "do_laundry_ic", "gardening_ic", "key_ic", "tv_ic"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
        setupPopup()
        setupCloseButton()
        addDismissGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let iconGridView = view.viewWithTag(101) {
            if let selectedIndex = icons.firstIndex(of: selectedIcon) {
                selectIcon(at: selectedIndex, from: iconGridView)
            } else {
                selectIcon(at: 0, from: iconGridView)
            }
        }
    }

    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func setupPopup() {
        let popupView = UIView()
        popupView.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        popupView.layer.cornerRadius = 12
        popupView.tag = 100
        view.addSubview(popupView)

        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(600)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Choose the icon"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .white
        popupView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
        }

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        popupView.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        let iconGridView = UIView()
        iconGridView.tag = 101
        scrollView.addSubview(iconGridView)

        iconGridView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        let iconSize = 64
        let iconSpacing = 24

        for (index, iconName) in icons.enumerated() {
            let iconView = UIView()
            iconView.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
            iconView.layer.cornerRadius = 16
            iconView.layer.borderColor = UIColor(red: 56/255, green: 56/255, blue: 58/255, alpha: 1).cgColor
            iconView.layer.borderWidth = 1
            iconView.layer.masksToBounds = true
            iconView.tag = index
            iconView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped(_:)))
            iconView.addGestureRecognizer(tapGesture)
            iconGridView.addSubview(iconView)

            let row = index / 3
            let col = index % 3

            iconView.snp.makeConstraints { make in
                make.size.equalTo(iconSize)
                make.leading.equalToSuperview().offset(col * (iconSize + iconSpacing) + iconSpacing)
                make.top.equalToSuperview().offset(row * (iconSize + iconSpacing))
            }

            let imageView = UIImageView(image: UIImage(named: iconName))
            imageView.contentMode = .scaleAspectFit
            iconView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.size.equalTo(32)
                make.center.equalToSuperview()
            }
        }

        let totalRows = (icons.count + 2) / 3
        let contentHeight = totalRows * (iconSize + iconSpacing) - iconSpacing + 24 // Add 24 pixels padding at the bottom
        iconGridView.snp.makeConstraints { make in
            make.height.equalTo(contentHeight)
        }
    }

    @objc private func iconTapped(_ sender: UITapGestureRecognizer) {
            guard let tappedView = sender.view else { return }
            let iconGridView = tappedView.superview
            selectIcon(at: tappedView.tag, from: iconGridView!)
        }
    
    private func selectIcon(at index: Int, from gridView: UIView) {
        for subview in gridView.subviews {
            let iconView = subview
            let isSelected = iconView.tag == index
            if isSelected {
                selectedIcon = icons[iconView.tag]
                onIconSelected?(selectedIcon)
            }
            iconView.backgroundColor = isSelected ? UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1) : UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
            iconView.layer.borderWidth = isSelected ? 0 : 1
            
            // Установка изображения иконки
            if let imageView = iconView.subviews.first as? UIImageView {
                imageView.image = UIImage(named: icons[iconView.tag])
            }
        }
    }

    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "greyCross"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Настройка констрейнтов для closeButton
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(56)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func closePopup() {
        onIconSelected?(selectedIcon)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if view.viewWithTag(100)?.frame.contains(location) == false {
            closePopup()
        }
    }
}
