//
//  LoginViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/7/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import CryptoKit


class LoginViewController: UIViewController , GIDSignInDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var buttonLoginStyle: UIButton!
    @IBOutlet weak var buttonForgorPasswordStyle: UIButton!
    @IBOutlet weak var buttonLoginFBStyle: UIButton!
    @IBOutlet weak var buttonLoginGoogleStyle: UIButton!
    @IBOutlet weak var buttonCreateAccountStyle: UIButton!
    @IBOutlet weak var buttonGuest: UIButton!
    @IBOutlet weak var imgeBackground: UIImageView!
    @IBOutlet weak var btnApple: UIButton!
    private var currentNonce: String?
    @IBOutlet weak var constraintGoogle: NSLayoutConstraint!
    @IBOutlet weak var contraintFacebook: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLogin: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLoginWith: NSLayoutConstraint!
    
    
    let facebookReadPermissions = ["public_profile", "email"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        constraintTopLogin.constant = UIDevice().getTopLogin()
        constraintTopLoginWith.constant = UIDevice().getTopLoginWith()
        
        self.extensionGestureHideKeyboard()
        self.imgeBackground.image = UIImage(named: "\(UIDevice().getFolder())signup")
        if appDelegate.enviromentProduction == TypeEnviroment.develop{
            //txtEmail.text = "acan@experienciasxcaret.com.mx"
//            txtEmail.text = "jacobo.diaz3@hotmail.com"
            //txtEmail.text = "kira_am85@hotmail.com"
            //txtPassword.text = "123456"
            
            
            /*let button = UIButton(type: .roundedRect)
            button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
            button.setTitle("Crash", for: [])
            button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)*/
        }
        
        if #available(iOS 13.0, *) {
            btnApple.isHidden = false
            constraintGoogle.constant = 40
            contraintFacebook.constant = 40
        }else{
            btnApple.isHidden = true
            constraintGoogle.constant = 0
            contraintFacebook.constant = 0
        }
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        //Crashlytics.sharedInstance().crash()
        fatalError()
    }
    
    override func viewDidLayoutSubviews() {
        self.txtEmail.setBottonLineDefault()
        self.txtPassword.setBottonLineDefault()
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        /*SF*/
        let pageAttr = ["txt_pwd": true]
        (AppDelegate.getKruxTracker()).trackPageView("Login", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        self.validateUser()
    }
    
    @IBAction func btnGuest(_ sender: UIButton) {
        /*FB**/
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Security.rawValue, title: TagsID.guest.rawValue)
        /*SF*/
        let pageAttr = ["txt_anonymous": true]
        (AppDelegate.getKruxTracker()).trackPageView("Login", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        Auth.auth().signInAnonymously { (user, error) in
            self.configStatusButtons(isEnabled: false)
            if error != nil {
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.configStatusButtons(isEnabled: true)
                self.handleError(error!)
            }else{
                let uid = user?.user.uid
                print("Se autenticó anonimamente \(uid!)")
                let userApp = self.getInfoUserAuth()
                if !userApp.uid.isEmpty {
                    print("StatusSF: authenticateUserApp btnGuest")
                    FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (success, userSaved) in
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.configStatusButtons(isEnabled: true)
                        if success{
                            print("Se guardó usuario")
                            self.goToParkXcaret()
                        }else{
                            print("No se guardó")
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func btnLoginFB(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Security.rawValue, title: TagsID.facebook.rawValue)
        let loginManager = LoginManager()
        /*SF*/
        let pageAttr = ["btnFacebook": true]
        (AppDelegate.getKruxTracker()).trackPageView("Login", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        
        loginManager.logIn(permissions: facebookReadPermissions, from: self) { (loginResult, error) in
            if error != nil{
                print("hubo un error")
                loginManager.logOut()
            }else if loginResult!.isCancelled {
                print("cancell")
                loginManager.logOut()
            }else{
                //Verificamos que tenga permisos
                var allPermsGranted = true
                let grantedPermissions = Array(loginResult!.grantedPermissions).map({ "\($0)" })
                for permission in self.facebookReadPermissions {
                    if !grantedPermissions.contains(permission){
                        allPermsGranted = false
                        break
                    }
                }
                
                if allPermsGranted {
                    print("Permision \(loginResult?.token?.tokenString ?? "X")")
                    let credential = FacebookAuthProvider.credential(withAccessToken: (loginResult?.token!.tokenString)!)
                    self.authUserWithSocial(authCredential: credential)
                }else{
                    print("Problemas login facebook")
                }
            }
        }
    }
    
    
    @IBAction func btnLoginGoogle(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Security.rawValue, title: TagsID.google.rawValue)
        /*SF*/
        let pageAttr = ["btnGoogle": true]
        (AppDelegate.getKruxTracker()).trackPageView("Login", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        self.configStatusButtons(isEnabled: false)
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
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
    
    @IBAction func btnAppleLogin(_ sender: Any) {
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
    
    
    
    private func configStatusButtons(isEnabled : Bool){
        self.buttonLoginStyle.isEnabled = isEnabled
        self.buttonForgorPasswordStyle.isEnabled = isEnabled
        self.buttonLoginFBStyle.isEnabled = isEnabled
        self.buttonLoginGoogleStyle.isEnabled = isEnabled
        self.buttonCreateAccountStyle.isEnabled = isEnabled
        self.buttonGuest.isEnabled = isEnabled
        self.btnApple.isEnabled = isEnabled
    }
    
    //Autenticacion con redes sociales
    private func authUserWithSocial(authCredential: AuthCredential){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        self.configStatusButtons(isEnabled: false)
        Auth.auth().signIn(with: authCredential) { (user, error) in
            if let error = error {
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.configStatusButtons(isEnabled: true)
                self.handleError(error)
                return
            }
            //Enviar a buscar el tipo de proveedor
            let userApp: UserApp = self.getInfoUserAuth()
            if !userApp.uid.isEmpty {
                print("StatusSF: authenticateUserApp Social")
                FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (isSave, userApp) in
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    self.configStatusButtons(isEnabled: true)
                    if isSave{
                        self.goToParkXcaret()
                    }else{
                        print("No se guardó")
                    }
                })
            }
        }
    }
    
    func validateUser(){
        let email = self.txtEmail.text
        let pass = self.txtPassword.text
        
        if !(email?.isEmpty)! && !(pass?.isEmpty)! {
            AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Security.rawValue, title: TagsID.login.rawValue)
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            
            Auth.auth().signIn(withEmail: email!, password: pass!) { (user, error) in
                if error != nil {
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    self.handleError(error!)
                }else{
                    let userApp: UserApp = self.getInfoUserAuth()
                    if !userApp.uid.isEmpty {
                        print("StatusSF: authenticateUserApp validateUser")
                        FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (isUser, UserAppAuth) in
                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                            self.configStatusButtons(isEnabled: true)
                            if isUser {
                                self.goToParkXcaret()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.configStatusButtons(isEnabled: false)
        if (error) != nil {
            self.configStatusButtons(isEnabled: true)
            print("Error al loguearse por google: \(error.localizedDescription)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        self.authUserWithSocial(authCredential: credential)
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
    
    private func goToParkXcaret(){
        //Vamos a buscar los favoritos
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let mainNC = AppStoryboard.HomeParks.instance.instantiateViewController(withIdentifier: "HomeParksNC")
        mainNC.view.frame = rootViewController.view.frame
        mainNC.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainNC
        })
    }
    
    
    @IBAction func createAccount(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Security.rawValue, title: TagsID.signup.rawValue)
        /*SF*/
        let pageAttr = ["txt_signup": true]
        (AppDelegate.getKruxTracker()).trackPageView("Login", pageAttributes:pageAttr, userAttributes:nil)
        /**/
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Security.rawValue, title: TagsID.forgot.rawValue)
        /*SF*/
        let pageAttr = ["txt_forgot": true]
        (AppDelegate.getKruxTracker()).trackPageView("Login", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPassword.resignFirstResponder()
            validateUser()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        if let nonce = currentNonce, let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let appleIDToken = appleIDCredential.identityToken, let appleIDTokenString = String(data: appleIDToken, encoding: .utf8){
            
            let authCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: authCredential) { (user, error) in
                if let error = error {
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    self.configStatusButtons(isEnabled: true)
                    self.handleError(error)
                    return
                }
                
                //Enviar a buscar el tipo de proveedor
                let userApp: UserApp = self.getInfoUserAuth()
                if !userApp.uid.isEmpty {
                    print("StatusSF: authenticateUserApp apple")
                    FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (isSave, userApp) in
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.configStatusButtons(isEnabled: true)
                        if isSave{
                            print("Se guardó usuario")
                            self.goToParkXcaret()
                        }else{
                            print("No se guardó")
                        }
                    })
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
