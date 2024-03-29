import UIKit
import QuartzCore

enum SlideOutState {
  case BothCollapsed
  case LeftPanelExpanded
  case RightPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate, UIGestureRecognizerDelegate {
  var centerNavigationController: UINavigationController!
  var centerViewController: CenterViewController!

  var currentState: SlideOutState = .BothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .BothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
  }

  var leftViewController: SidePanelViewController?
  var rightViewController: SidePanelViewController?

  let centerPanelExpandedOffset: CGFloat = 60

  override func viewDidLoad() {
    super.viewDidLoad()

    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self

    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)

    centerNavigationController.didMoveToParentViewController(self)
    
  }

  // MARK: CenterViewController delegate methods

  func toggleLeftPanel() {
    let notAlreadyExpanded = (currentState != .LeftPanelExpanded)

    if notAlreadyExpanded {
      addLeftPanelViewController()
    }

    animateLeftPanel(shouldExpand: notAlreadyExpanded)
  }

  func toggleRightPanel() {
    let notAlreadyExpanded = (currentState != .RightPanelExpanded)

    if notAlreadyExpanded {
      addRightPanelViewController()
    }

    animateRightPanel(shouldExpand: notAlreadyExpanded)
  }

  func collapseSidePanels() {
    switch (currentState) {
    case .RightPanelExpanded:
      toggleRightPanel()
    case .LeftPanelExpanded:
      toggleLeftPanel()
    default:
      break
    }
  }

  func addLeftPanelViewController() {
    if (leftViewController == nil) {
      leftViewController = UIStoryboard.leftViewController()
      leftViewController!.menuItems = MenuItem.allMenus()

      addChildSidePanelController(leftViewController!)
    }
  }

  func addRightPanelViewController() {
  }

  func addChildSidePanelController(sidePanelController: SidePanelViewController) {
    sidePanelController.delegate = centerViewController

    view.insertSubview(sidePanelController.view, atIndex: 0)

    addChildViewController(sidePanelController)
    sidePanelController.didMoveToParentViewController(self)
  }

  func animateLeftPanel(#shouldExpand: Bool) {
    if (shouldExpand) {
      currentState = .LeftPanelExpanded

      animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
    } else {
      animateCenterPanelXPosition(targetPosition: 0) { finished in
        self.currentState = .BothCollapsed

        self.leftViewController!.view.removeFromSuperview()
        self.leftViewController = nil;
      }
    }
  }

  func animateRightPanel(#shouldExpand: Bool) {
    if (shouldExpand) {
      currentState = .RightPanelExpanded

      animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
    } else {
      animateCenterPanelXPosition(targetPosition: 0) { _ in
        self.currentState = .BothCollapsed

        self.rightViewController!.view.removeFromSuperview()
        self.rightViewController = nil;
      }
    }
  }

  func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
      self.centerNavigationController.view.frame.origin.x = targetPosition
      }, completion: completion)
  }

  func showShadowForCenterViewController(shouldShowShadow: Bool) {
    if (shouldShowShadow) {
      centerNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
}

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
  class func menuStoryboard() -> UIStoryboard { return UIStoryboard(name: "Menu", bundle: NSBundle.mainBundle()) }

  class func leftViewController() -> SidePanelViewController? {
    return menuStoryboard().instantiateViewControllerWithIdentifier("SidePanelViewController") as? SidePanelViewController
  }
  
  class func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("MainViewController") as? CenterViewController
  }
}