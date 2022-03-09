import UIKit
import AVFoundation
import QRCodeReader

class SignInViewController: UITableViewController {
  lazy var codeReaderViewController: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
      $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
      $0.showTorchButton = false
      $0.showSwitchCameraButton = false
      $0.showCancelButton = true
      $0.showOverlayView = false
      $0.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
  }
    
    return QRCodeReaderViewController(builder: builder)
  }()
  
  @IBAction func showSignInWithQR(_ sender: UIBarButtonItem) {
    codeReaderViewController.delegate = self
    codeReaderViewController.modalPresentationStyle = .formSheet
    
    codeReaderViewController.completionBlock = { result in
      
    }
    
    present(codeReaderViewController, animated: true, completion: nil)
  }
}

extension SignInViewController: QRCodeReaderViewControllerDelegate {
  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
  }
  
  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    dismiss(animated: true, completion: nil)
  }
  
}
