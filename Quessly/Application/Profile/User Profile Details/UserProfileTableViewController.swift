import UIKit
import FontAwesome_swift
import Static
import Amplify
import SwiftUI
import AWSMobileClient
import NSLogger
/**
 Shows details of the user profile.
 
 - SeeAlso: MainMenuTableViewController
 */
class UserProfileTableViewController: TableViewController {
  enum SignOutResult {
    case success
    case failure(error: SignOutError)
  }
  
  enum SignOutError: Error {
    case unknown
    case internalError(error: Error)
  }
  
  enum RememberDeviceResult {
    case success
    case failure(error: RememberDeviceError)
  }
  enum RememberDeviceError: Error{
    case unkonw
    case internalError(error: Error)
  }
  
  enum ForgetDeviceResult {
    case success
    case failure(error: ForgetDeviceError)
  }
  enum ForgetDeviceError: Error {
    case unknown
    case internalError(error: Error)
  }
  
  convenience init() {
    self.init(style: .grouped)
  }
  
  //  MARK: - UIViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    
    dataSource.sections = [
      Section(rows: [
        Row(cellClass: UserProfileTableViewControllerProfileTableViewCell.self),
      ]),
      Section(rows: [
        Row(text: "Manage Devices",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemGreen, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "desktopcomputer")!]),
      ]),
      Section(rows: [
        Row(text: "Account",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemBlue, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage.fontAwesomeIcon(name: .key, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))]),
        Row(text: "Notifications",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemRed, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "app.badge")!])
      ]),
      Section(rows: [
        Row(text: "Help",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemBlue, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "info")!]),
        Row(text: "Suggest To Your Friend",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemRed, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "heart.fill")!])
      ]),
      Section(rows: [
        Row(text: "Sign Out",
            accessory: Row.Accessory.none,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [
              UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemRed,
              UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage.fontAwesomeIcon(name: .signOutAlt, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))
            ]
           )
      ])
    ]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    title = "Profile"
    
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
    tableView.backgroundColor = .systemGroupedBackground
  }
  
  //  MARK: - Remote procedure calls
  
  /// User can log out whenever they want to log out their account
  func signOut(completion: ((SignOutResult) -> Void)?) {
    Amplify.Auth
      .signOut { result in
        DispatchQueue.main.async {
          switch result {
          case .success:
            Logger.shared.log(.controller, .info, "AWS Amplify Sign out succeeded")
            
            completion?(.success)
            
          case .failure(let error):
            Logger.shared.log(.controller, .error, "AWS Amplify Sign out failed \(error)")
            
            completion?(.failure(error: .internalError(error: error)))
          }
        }
      }
  }
  
  /// Users can remember their devices
  func rememberDevice(completion: ((RememberDeviceResult) -> Void)?) {
    Amplify.Auth
      .rememberDevice() { result in
        DispatchQueue.main.async {
          switch result {
          case .success:
            Logger.shared.log(.controller, .info, "Remember device succeeded")
            NSLog("Remember Device succeeded")
            
          case .failure(let error):
            Logger.shared.log(.controller, .error, "Remember device failed with error \(error)")
            NSLog("Remember device failed with error")
          }
        }
      }
  }
  
  ///Users can forget their devices
  func forgetDevice(completion: ((ForgetDeviceResult) -> Void)?) {
    Amplify.Auth
      .forgetDevice() { result in
        DispatchQueue.main.async {
          switch result {
          case .success:
            Logger.shared.log(.controller, .info, "Forget device succeeded")
            NSLog("Forget device succeeded")
          case .failure(let error):
            Logger.shared.log(.controller, .error, "Forget device failed with error \(error)")
            NSLog("Forget device failed with error")
          }
        }
      }
  }
  
  //  MARK: - Navigation
  
  private func presentSignInMenu(sender: Any?) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    let initialViewController = storyboard.instantiateViewController(
        withIdentifier: "AuthenticationNavigationController"
      )

    UIApplication.shared.keyWindow!.rootViewController = initialViewController
    UIApplication.shared.keyWindow!.makeKeyAndVisible()
  }
}

extension UserProfileTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      return 80
    default:
      return 43.5
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 1 && indexPath.row == 0 {
      self.presentForgetDeviceAlert() { isForgetDevice in
        self.dismiss(animated: true) {
          if isForgetDevice {
            self.forgetDevice { result in
              switch result {
              case .success:
                self.presentSignInMenu(sender: nil)
                
              case .failure(let error):
                fatalError(error.localizedDescription)
              }
            }
          }
        }
      }
    }
    
    else if indexPath.section == 4 && indexPath.row == 0 {
      self.presentSignOutAlert() { isSignOutConfirmed in
        self.dismiss(animated: true) {
          self.presentLoadingAlert {
            self.dismiss(animated: true) {
              if isSignOutConfirmed {
                self.signOut { result in
                  switch result {
                  case .success:
                    self.presentSignInMenu(sender: nil)
                    
                  case .failure(let error):
                    fatalError()
                  }
                }
              }
            }
          }
        }
      }
//      self.presentSignOutAlert() { isSignOutConfirmed in
//        self.dismiss(animated: true) {
//          if isSignOutConfirmed {
//            self.signOut { result in
//              switch result {
//              case .success:
//                self.presentSignInMenu(sender: nil)
//
//              case .failure(let error):
//                fatalError(error.localizedDescription)
//              }
//            }
//          }
//        }
//      }
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let sectionCount = tableView.numberOfSections
    
    return section == sectionCount - 1 ? (UINib(nibName: "UserProfileTableViewControllerVersionCopyrightFooterView", bundle: .main).instantiate(withOwner: self, options: nil)[0] as! UIView) : nil
  }
}
