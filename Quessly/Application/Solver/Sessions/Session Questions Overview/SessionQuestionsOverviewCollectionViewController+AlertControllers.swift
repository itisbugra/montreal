import UIKit

extension SessionQuestionsOverviewCollectionViewController {
  //  MARK: - Alerts
  
  func presentFilterAlert(currentFilter: ListingFilter?,
                          animated: Bool,
                          completion: @escaping (ListingFilter?) -> Void) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let marked = UIAlertAction(title: "Marked",
                               style: .default,
                               checked: currentFilter == .some(.marked)) { _ in
      completion(.marked)
    }
    
    let unseen = UIAlertAction(title: "Unseen",
                               style: .default,
                               checked: currentFilter == .some(.unseen)) { _ in
      completion(.unseen)
    }
    
    let all = UIAlertAction(title: "All",
                            style: .default,
                            checked: currentFilter == nil) { _ in
      completion(nil)
    }
    
    let actions = [marked, unseen, all]
    
    actions.forEach { alertController.addAction($0) }
    
    present(alertController,
            animated: animated,
            completion: nil)
  }
}
