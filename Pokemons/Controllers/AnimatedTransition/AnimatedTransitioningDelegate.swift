import Foundation

protocol AnimatedTransitioningDelegate {
    func prepareToTransition()
    func performTransitioning()
    func performHalfTransitioning()
    func performSecondHalfTransitioning()
    func completionOfTransition()
}
