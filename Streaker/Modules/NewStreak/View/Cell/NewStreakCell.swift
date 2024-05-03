/*

Этот класс NewStreakCell:
1 - Служит пользовательской ячейкой для отображения информации о типе привычки в таблице.
2 - Содержит элементы интерфейса, такие как изображения и текстовые метки, для представления каждой привычки.
3 - Автоматически обновляет свой интерфейс при изменении данных модели.

*/

import Foundation
import UIKit

class NewStreakCell: UITableViewCell, Reusable {
    
    var model: NewStreakModel? {
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
    
    private let arrowImageView: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "arrowIm")
        return obj
    }()
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 17, weight: .medium)
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
        container.addSubview(arrowImageView)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        generalImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(32.sizeH)
            make.top.bottom.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(generalImageView)
            make.leading.equalTo(generalImageView.snp.trailing).offset(16.sizeW)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(10.sizeH)
            make.width.equalTo(10.sizeW)
            make.trailing.equalToSuperview().inset(20.sizeW)
            make.centerY.equalTo(generalImageView)
        }
    }
}

//MARK: - helpers
extension NewStreakCell {
    private func handleUI() {
        guard let model = model else {
            return
        }
        
        generalImageView.image = model.image
        titleLabel.text = model.title
    }
}

