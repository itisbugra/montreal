import UIKit
import AVFoundation
import QRCodeReader
import Amplify
import AmplifyPlugins
import GoogleSignIn
import AWSMobileClient
import SwiftUI
import NSLogger

class SignInViewController: UITableViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var didPressSignInWithGoogle: UILabel!
  @IBOutlet var resetPasswordTapGestureRecognizer: UITapGestureRecognizer!
  @IBOutlet weak var resetPasswordLabel: UILabel!
  @IBOutlet weak var eulaLabel: UILabel!
  @IBOutlet weak var eulaLinkLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //  Configure reset password gesture recognizer
    resetPasswordTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                               action: #selector(shouldPresentResetPassword(_:)))
    
    resetPasswordLabel
      .addGestureRecognizer(resetPasswordTapGestureRecognizer)
  }
  
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if segue.identifier == "signInToMainMenu" && segue.identifier == "signInWithGoogle"{
      emailTextField.text = emailTextField.text!
      passwordTextField.text = passwordTextField.text!
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      let email = emailTextField.text
      let password = passwordTextField.text
      
      Amplify.Auth
        .signIn(username: email, password: password, options: nil) { result in
          switch result {
          case .success:
            NSLog("Sign in succeeded")
            DispatchQueue.main.async {
              self.showMainMenu(sender: self.tableView)
            }
          case .failure(let error):
            NSLog("Sign in failed \(error)")
            DispatchQueue.main.async {
              self.tableView.cellForRow(at: indexPath)!.isSelected = false
              self.showError(error, sender: self.tableView)
            }
          }
        }
    } else if indexPath.section == 3 && indexPath.row == 0 {
      Amplify.Auth
        .signInWithWebUI(for: .google,
                         presentationAnchor: self.view.window!) { result in
          switch result {
          case .success:
            NSLog("AWS Amplify Google federated sign in succeeded")
            
            DispatchQueue.main.async {
              self.showMainMenu(sender: self.tableView)
            }
            
          case .failure(let error):
            NSLog("AWS Amplify Google federated sign in failed \(error)")
            
            DispatchQueue.main.async {
              self.tableView.cellForRow(at: indexPath)!.isSelected = false
              self.showError(error,
                             sender: self.tableView)
          }
        }
      }
    }
//    else if indexPath.section == 4 && indexPath.row == 0 {
//      let username = emailTextField.text!
//
//      Amplify.Auth
//        .resetPassword(for: username) { result in
//              do {
//                  let resetResult = try result.get()
//                  switch resetResult.nextStep {
//                  case .confirmResetPasswordWithCode(let deliveryDetails, let info):
//                      print("Confirm reset password with code send to - \(deliveryDetails) \(info)")
//                  case .done:
//                      print("Reset completed")
//                  }
//              } catch {
//                  print("Reset password failed with error \(error)")
//              }
//          }
//    }
  }
  
  @objc func shouldPresentResetPassword(_ sender: Any?) {
    self.performSegue(withIdentifier: "showResetPassword",
                      sender: sender)
  }
  
  @IBAction func unwindToSignInViewControllerCreatePassword(segue: UIStoryboardSegue) {
    
  }
  
  private func showMainMenu(sender: Any?) {
    self.performSegue(withIdentifier: "showMainMenu",
                      sender: self.tableView)
  }
  
  private func showError(_ error: Error, sender: Any?) {
    //  TODO: Handle the error
  }
}

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let tag = textField.tag
    let nextTextField = view.viewWithTag(tag + 1) as? UITextField
    
    nextTextField?.becomeFirstResponder()
    
    return true
  }
}

extension SignInViewController: QRCodeReaderViewControllerDelegate {
  func reader(_ reader: QRCodeReaderViewController,
              didScanResult result: QRCodeReaderResult) {
  }
  
  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    dismiss(animated: true,
            completion: nil)
  }
}
