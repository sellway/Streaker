

import UIKit
import SnapKit

class StatsView: UIView {
    
    private lazy var testImage: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "testStats")
        return obj
    }()
    

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension StatsView {
    private func setup() {
        
        addSubview(testImage)

        self.backgroundColor = .theme(.streakerGrey)
        makeConstraints()
    }
    
    private func makeConstraints() {

        testImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}
