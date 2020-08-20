import UIKit

class ActivityAlertControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  override fileprivate init() {
    super.init()
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.2
  }
}

class ActivityAlertControllerPresentAnimatedTransitioning: ActivityAlertControllerAnimatedTransitioning {
  override public init() {
    super.init()
  }
  
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.view(forKey: .to) else {
        return
    }
    
    let duration = transitionDuration(using: transitionContext)
    
    transitionContext.containerView.addSubview(toView)
    
    toView.transform = CGAffineTransform(scaleX: 1.60, y: 1.60)
    toView.alpha = 0.00
    
    UIView.animate(withDuration: duration, animations: {
      toView.transform = .identity
      toView.alpha = 1.00
    }) { _ in
      transitionContext.completeTransition(true)
    }
  }
}

class ActivityAlertControllerDismissAnimatedTransitioning: ActivityAlertControllerAnimatedTransitioning {
  override public init() {
    super.init()
  }
  
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromView = transitionContext.view(forKey: .from) else {
        return
    }
    
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
      fromView.alpha = 0.00
    }) { _ in
      fromView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
  }
}
