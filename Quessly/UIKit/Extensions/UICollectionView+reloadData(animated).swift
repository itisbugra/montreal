import UIKit

extension UICollectionView {
  func reloadData(animated: Bool) {
    guard animated else {
      reloadData()
      
      return
    }
    
    performBatchUpdates({
      reloadSections(IndexSet(0...(numberOfSections - 1)))
    }, completion: nil)
  }
}
