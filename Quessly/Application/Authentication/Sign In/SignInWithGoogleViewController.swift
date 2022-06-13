////
////  SignInWithGoogleViewController.swift
////  Quessly
////
////  Created by Ersin Yildirim on 12.03.2022.
////  Copyright © 2022 Quessly. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Amplify
//
//class SignInWithGoogleViewController: UITableViewController {
//    @IBAction func didPressSignInWithGoogle(_ sender: UIButton) {
//      Amplify.Auth
//        .signInWithWebUI(for: .google,
//                            presentationAnchor: self.view.window!) { result in
//          switch result {
//          case .success:
//            NSLog("AWS Amplify Google federated sign in succeeded")
//
//          case .failure(let error):
//            NSLog("AWS Amplify Google federated sign in failed \(error)")
//      }
//    }
//  }
//}
