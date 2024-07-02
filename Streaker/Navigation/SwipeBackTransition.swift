import UIKit

class SwipeBackTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isInverted: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenWidth = UIScreen.main.bounds.width
        toVC.view.frame = containerView.bounds // Устанавливаем toVC.view на место
        fromVC.view.frame.origin.x = 0 // Начальная позиция текущего экрана
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame.origin.x = self.isInverted ? screenWidth : -screenWidth // Двигаем текущий экран вправо или влево в зависимости от флага
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
