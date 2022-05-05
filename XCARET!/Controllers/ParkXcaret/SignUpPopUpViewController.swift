//
//  SignUpPopUpViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 9/9/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase
import GoogleSignIn
import CryptoKit
import AuthenticationServices

protocol ModalHandler {
    func modalDismissed()
}

class SignUpPopUpViewController: UIViewController {
    private var currentNonce: String?
    @IBOutlet weak var widthViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblSignup: UITableView!
    var delegate : ModalHandler?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.widthViewConstraint.constant = UIScreen.main.bounds.width - 40
        self.tblSignup.delegate = self
        self.tblSignup.dataSource = self
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpPopUpViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSocial", for: indexPath) as! ItemSignupSocialTableViewCell
            cell.delegateSocialLogin = self
             return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCreateUser", for: indexPath) as! ItemSignupCreateTableViewCell
            cell.mainViewController = self
            cell.delegateUserPassLogin = self
             return cell
        }
    }
}

extension SignUpPopUpViewController : SocialLoginDelegate, UserPassLoginDelegate {
    func getUserPassLogin(type: String, userApp: UserApp, pass: String) {
        if type == "UP" {
            ManageLoginBR.shared.signUpUserPass(viewControlSelf: self, userRegister: userApp, pass: pass) { (success, error) in
                print(success)
                if success {
                    UpAlertView(type: .info, message: "Se ha viculado tu cuenta exitosamente").show(completion: {
                        self.dismiss(animated: true, completion: {
                            self.delegate?.modalDismissed()
                        })
                    })
                }else{
                    if error != nil {
                        self.handleError(error!)
                    }
                }
            }
        }
    }
    
    func getSocialLogin(type: String) {
        if type == "F"{
            ManageLoginBR.shared.signUpFacebook(viewControlSelf: self) { (success, error) in
                if success {
                    UpAlertView(type: .info, message: "Se ha viculado tu cuenta exitosamente").show(completion: {
                        self.dismiss(animated: true, completion: {
                            self.delegate?.modalDismissed()
                        })
                    })
                }else{
                    if error != nil {
                        self.handleError(error!)
                    }
                }
            }
        }else if type == "G" {
            //GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
        }else if type == "A"{
            if #available(iOS 13.0, *) {
                self.currentNonce = randomNonceString()
                let appleIDprovider = ASAuthorizationAppleIDProvider()
                let request = appleIDprovider.createRequest()
                request.requestedScopes = [.email,.fullName]
                request.nonce = sha256(currentNonce!)
                
                let autorizationController = ASAuthorizationController(authorizationRequests: [request])
                autorizationController.delegate = self
                autorizationController.presentationContextProvider = self
                autorizationController.performRequests()
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func getInfoUserAuth() -> UserApp{
        let userApp : UserApp = UserApp()
        let userAuth = Auth.auth().currentUser
        
        if let userIdUser = userAuth?.uid{
            userApp.uid = userIdUser
        }
        
        if (userAuth?.isAnonymous)! {
            let name = ((Constants.LANG.current == "es") ? "Invitado" : "Guest")
            userApp.name = name
            userApp.email = "\(name.lowercased().replacingOccurrences(of: "ó", with: "o"))@\(Date().string(format: "yyyyMMddHHmmss"))"
            userApp.provider = (userAuth?.providerID)!
        }else{
            
            let userd = userAuth?.providerData[0]
            
            if let providerUser = userAuth?.providerData[0].providerID {
                userApp.provider = providerUser
            }
            
            if let emailUser = userAuth?.providerData[0].email{
                userApp.email = emailUser
            }
            if let nameUser = userAuth?.providerData[0].displayName {
                userApp.name = nameUser
            }
            if let phoneUser = userAuth?.providerData[0].phoneNumber {
                userApp.phone = phoneUser
            }
            if let photoProfile = userAuth?.providerData[0].photoURL{
                print("url Photo\(photoProfile)")
            }
        }
        
        return userApp
    }
    
}

extension SignUpPopUpViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            //self.configStatusButtons(isEnabled: true)
            print("Error al loguearse por google: \(error.localizedDescription)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        ManageLoginBR.shared.linkAuthentication(viewControlSelf: self, authCredential: credential) { (success, error) in
            if success {
                UpAlertView(type: .info, message: "Se ha viculado tu cuenta exitosamente").show(completion: {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.modalDismissed()
                    })
                })
            }else{
                if error != nil {
                    self.handleError(error!)
                }
            }
        }
    }
    
}

extension SignUpPopUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //LoadingView.shared.showActivityIndicator(uiView: self.view)
        if let nonce = currentNonce, let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let appleIDToken = appleIDCredential.identityToken, let appleIDTokenString = String(data: appleIDToken, encoding: .utf8){
            
            let authCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: authCredential) { (user, error) in
                if let error = error {
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    //self.configStatusButtons(isEnabled: true)
                    self.handleError(error)
                    return
                }
                
                ManageLoginBR.shared.linkAuthentication(viewControlSelf: self, authCredential: authCredential) { (success, error) in
                    if success {
                        UpAlertView(type: .info, message: "Se ha viculado tu cuenta exitosamente").show(completion: {
                            self.dismiss(animated: true, completion: {
                                self.delegate?.modalDismissed()
                            })
                        })
                    }else{
                        if error != nil {
                            print(error!)
                            self.dismiss(animated: true, completion: {
                                self.delegate?.modalDismissed()
                            })
                            
//                            self.handleError(error!)
                        }
                    }
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

