import UIKit

class ActivityAlertControllerPresentationController: UIPresentationController {
  var dimmerView: UIView!
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    dimmerView = UIView()
    dimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    dimmerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
    
    self.presentedView?.layer.cornerRadius = 8.0
    
    let centerXMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
    centerXMotionEffect.minimumRelativeValue = -10.0
    centerXMotionEffect.maximumRelativeValue = 10.0
    
    let centerYMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
    centerYMotionEffect.minimumRelativeValue = -10.0
    centerYMotionEffect.maximumRelativeValue = 10.0
    
    let motionEffectGroup = UIMotionEffectGroup()
    motionEffectGroup.motionEffects = [centerXMotionEffect, centerYMotionEffect]
    
    self.presentedView?.addMotionEffect(motionEffectGroup)
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    guard let presentedView = presentedView, let containerView = containerView else {
      return super.frameOfPresentedViewInContainerView
    }
    
    let size = presentedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    
    var frame = CGRect()
    frame.origin = CGPoint(x: containerView.frame.midX - size.width / 2.00, y: containerView.frame.midY - size.height / 2.00)
    frame.size = size
    
    return frame
  }
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    guard let containerView = containerView, let presentedView = presentedView else {
      return
    }
    
    dimmerView.alpha = 0.00
    dimmerView.frame = containerView.bounds
    containerView.insertSubview(dimmerView, at: 0)
    
    presentedView.center = containerView.center
    
    presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
      self.dimmerView.alpha = 1.00
    }, completion: nil)
  }
  
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    guard let containerView = containerView, let presentedView = presentedView else {
      return
    }
    
    dimmerView.frame = containerView.bounds
    presentedView.frame = frameOfPresentedViewInContainerView
  }
  
  override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()
    
    presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
      self.dimmerView.alpha = 0.00
    }, completion: nil)
  }
}
