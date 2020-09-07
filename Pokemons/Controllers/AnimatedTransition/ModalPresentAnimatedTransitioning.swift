import UIKit

class ModalPresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to)
            else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        let delegate = toVC as? AnimatedTransitioningDelegate
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        UISelectionFeedbackGenerator().selectionChanged()
        delegate?.prepareToTransition()
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                toView.frame = finalFrame
                delegate?.performTransitioning()
                toView.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2) {
                delegate?.performHalfTransitioning()
                toView.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                delegate?.performSecondHalfTransitioning()
                toView.layoutIfNeeded()
            }
        }) { finished in
            delegate?.completionOfTransition()
            transitionContext.completeTransition(finished)
        }
    }
    
    
}
