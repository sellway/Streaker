import UIKit
import Lottie

class ConfettiAnimationManager {
    private var confettiAnimationView: LottieAnimationView?
    private weak var parentView: UIView?

    init(parentView: UIView) {
        self.parentView = parentView
        setupConfettiAnimation()
    }

    private func setupConfettiAnimation() {
        confettiAnimationView = .init(name: "confetti")
        confettiAnimationView!.isHidden = true
        confettiAnimationView!.contentMode = .scaleAspectFit
        confettiAnimationView!.loopMode = .playOnce
        parentView?.addSubview(confettiAnimationView!)
        confettiAnimationView!.translatesAutoresizingMaskIntoConstraints = false
    }

    func playAnimation(relativeTo button: UIButton) {
        guard let parentView = parentView else { return }

        // Удаление предыдущих ограничений
        confettiAnimationView!.removeFromSuperview()
        parentView.addSubview(confettiAnimationView!)

        // Установка новых ограничений относительно нажатой кнопки
        NSLayoutConstraint.activate([
            confettiAnimationView!.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            confettiAnimationView!.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            confettiAnimationView!.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.5),
            confettiAnimationView!.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1.5)
        ])

        confettiAnimationView!.isHidden = false
        parentView.bringSubviewToFront(confettiAnimationView!)
        confettiAnimationView!.play { [weak self] finished in
            if finished {
                self?.confettiAnimationView!.isHidden = true
            }
        }
    }
}
