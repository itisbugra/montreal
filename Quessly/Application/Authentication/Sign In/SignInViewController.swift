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
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var didPressSignInWithGoogle: UILabel!
  @IBOutlet var resetPasswordTapGestureRecognizer: UITapGestureRecognizer!
  @IBOutlet weak var resetPasswordLabel: UILabel!
  @IBOutlet weak var eulaLabel: UILabel!
  @IBOutlet weak var eulaLinkLabel: UILabel!
  
  var loading = false
  enum SignInResult {
    case success
    case failure(error: SignInError)
  }
  
  enum SignInError: Error {
    case unknown
    case internalError(error: Error)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //  Configure reset password gesture recognizer
    resetPasswordTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                               action: #selector(shouldPresentResetPassword(_:)))
    
    resetPasswordLabel
      .addGestureRecognizer(resetPasswordTapGestureRecognizer)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.usernameTextField.becomeFirstResponder()
    
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
    
    if segue.identifier == "signInToMainMenu" && segue.identifier == "signInWithGoogle" {
      usernameTextField.text = usernameTextField.text!
      passwordTextField.text = passwordTextField.text!
    }
  }
  
   func signIn(completion: ((SignInResult) -> Void)? = nil) {
    signIn(username: self.usernameTextField.text!,
           password: self.passwordTextField.text!,
           completion: completion)
  }
  
   func signIn(username: String, password: String, completion: ((SignInResult) -> Void)? = nil) {
    let username = usernameTextField.text
    let password = passwordTextField.text
    
    Amplify.Auth
      .signIn(username: username,
              password: password,
              options: nil) { result in
        DispatchQueue.main.async {
          switch result {
          case .success:
            completion?(.success)
            
          case .failure(let error):
            Logger.shared.log(.controller, .error, "Sign in failed")
            completion?(.failure(error: .internalError(error: error)))
          }
        }
      }
   }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.section == 1 && indexPath.row == 0 {
      
      self.presentLoadingAlert {
        self.signIn { result in
          self.dismiss(animated: true) {
            switch result {
            case .success:
              self.showMainMenu(sender: nil)
              Logger.shared.log(.controller, .important, "Sign in was successful")
              
            case .failure(let error):
              Logger.shared.log(.controller, .error, "An error occured while signing a user")
              
              DispatchQueue.main.async {
                self.tableView.cellForRow(at: indexPath)!.isSelected = false
                self.showError(error, sender: self.tableView)
              }
            }
          }
        }
      }
      //      let username = usernameTextField.text
      //      let password = passwordTextField.text
      //
      //      Amplify.Auth
      //        .signIn(username: username, password: password, options: nil) { result in
      //          switch result {
      //          case .success:
      //            Logger.shared.log(.controller, .important, "Sign in was successful.")
      //
      //            DispatchQueue.main.async {
      //              self.showMainMenu(sender: self.tableView)
      //            }
      //          case .failure(let error):
      //            Logger.shared.log(.controller, .error, "Sign in failed.")
      //            Logger.shared.log(.controller, .important, error.debugDescription)
      //
      //            DispatchQueue.main.async {
      //              self.tableView.cellForRow(at: indexPath)!.isSelected = false
      //              self.showError(error, sender: self.tableView)
      //            }
      //          }
      //        }
    } else if indexPath.section == 3 && indexPath.row == 0 {
      Amplify.Auth
        .signInWithWebUI(for: .google,
                         presentationAnchor: self.view.window!) { result in
          switch result {
          case .success:
            Logger.shared.log(.controller, .important, "AWS Amplify Google federated sign in succeeded")
            
            DispatchQueue.main.async {
              self.showMainMenu(sender: self.tableView)
            }
            
          case .failure(let error):
            Logger.shared.log(.controller, .error, "AWS Amplify Google federated sign in failed.")
            Logger.shared.log(.controller, .important, error.debugDescription)
            
            DispatchQueue.main.async {
              self.tableView.cellForRow(at: indexPath)!.isSelected = false
              self.showError(error,
                             sender: self.tableView)
            }
          }
        }
    }
  }
  
  @objc func shouldPresentResetPassword(_ sender: Any?) {
    Logger.shared.log(.controller, .info, "Presenting reset password scene.")
    
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
