/*

Этот класс `ProfileButtonCell`:
1 - Отображает кнопку в профиле с изображением и заголовком, определёнными в модели `ProfileModel`.
2 - Настраивает внешний вид и расположение элементов в ячейке.
3 - Обновляет интерфейс ячейки при изменении модели, отображая соответствующие изображение и заголовок.

*/

import Foundation
import UIKit

class ProfileButtonCell: UITableViewCell, Reusable {
    
    var model: ProfileModel? {
        didSet {
            handleUI()
        }
    }
    
    private lazy var container: UIView = {
       let obj = UIView()
        obj.backgroundColor = .clear
        return obj
    }()

    private let generalImageView: UIImageView = {
        let obj = UIImageView()
        return obj
    }()
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        obj.textColor = .white
        return obj
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.selectionStyle = .none
        
        contentView.addSubview(container)
        contentView.backgroundColor = .clear
        container.addSubview(generalImageView)
        container.addSubview(titleLabel)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        generalImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(74.sizeH)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(generalImageView)
            make.leading.equalTo(generalImageView.snp.trailing).offset(16.sizeW)
        }
    }
}

//MARK: - helpers
extension ProfileButtonCell {
    private func handleUI() {
        guard let model = model else {
            return
        }
        
        generalImageView.image = model.image
        titleLabel.text = model.title
    }
}

