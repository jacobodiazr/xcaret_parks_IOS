//
//  ManageLoginBR.swift
//  XCARET!
//
//  Created by Angelica Can on 9/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

open class ManageLoginBR {
    static let shared = ManageLoginBR()
    let facebookReadPermissions = ["public_profile"]
    
    func signUpUserPass(viewControlSelf : UIViewController?, userRegister: UserApp, pass: String, completion: @escaping (Bool, Error?)->()){
        //Obtenemos la credencial
        let credential = EmailAuthProvider.credential(withEmail: userRegister.email, password: pass)
        self.linkAuthentication(viewControlSelf: viewControlSelf, userRegister: userRegister, authCredential: credential) { (success, error) in
            completion(success, error)
        }
    }
    
    func signUpFacebook(viewControlSelf : UIViewController?, completion: @escaping (Bool, Error?)->()){
        //Vamos por las credenciales para facebook
        getCredentialFacebook(viewControlSelf: viewControlSelf) { (authCredential) in
            self.linkAuthentication(viewControlSelf: viewControlSelf, authCredential: authCredential, completion: { (success, error) in
                completion(success, error)
            })
        }
    }
    
    func linkAuthentication(viewControlSelf : UIViewController?, userRegister: UserApp, authCredential: AuthCredential?, completion: @escaping (Bool, Error?)->()){
        LoadingView.shared.showActivityIndicator(uiView: viewControlSelf!.view)
        Auth.auth().currentUser?.link(with: authCredential!, completion: { (user, error) in
            if let error = error {
                LoadingView.shared.hideActivityIndicator(uiView: viewControlSelf!.view)
                completion(false, error)
                return
            }
            //Si se authentico el usuario
            let userApp: UserApp = self.getInfoUserAuth()
            if !userRegister.uid.isEmpty {
                userRegister.provider = userApp.provider
                FirebaseDB.shared.linkAuthenticateUserApp(user: userRegister, completion: { (isSave, userApp) in
                    LoadingView.shared.hideActivityIndicator(uiView: viewControlSelf!.view)
                    if isSave {
                        print("Se guardó usuario")
                        completion(true, nil)
                    }else{
                        completion(false, nil)
                        print("No se guardó")
                    }
                })
                
//                FirebaseDB.shared.authenticateUserApp(user: userRegister, completion: { (isSave, userApp) in
//                    LoadingView.shared.hideActivityIndicator(uiView: viewControlSelf!.view)
//                    if isSave{
//                        print("Se guardó usuario")
//                        completion(true, nil)
//                    }else{
//                        completion(false, nil)
//                        print("No se guardó")
//                    }
//                })
            }
        })
    }
    
    func linkAuthentication(viewControlSelf : UIViewController?, authCredential: AuthCredential?, completion: @escaping (Bool, Error?)->()){
        LoadingView.shared.showActivityIndicator(uiView: viewControlSelf!.view)
        Auth.auth().currentUser?.link(with: authCredential!, completion: { (user, error) in
            if let error = error {
                LoadingView.shared.hideActivityIndicator(uiView: viewControlSelf!.view)
                completion(false, error)
                return
            }
            //Si se authentico el usuario
            let userApp: UserApp = self.getInfoUserAuth()
            if !userApp.uid.isEmpty {
                FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (isSave, userApp) in
                    LoadingView.shared.hideActivityIndicator(uiView: viewControlSelf!.view)
                    if isSave{
                        print("Se guardó usuario")
                        completion(true, nil)
                    }else{
                        completion(false, nil)
                        print("No se guardó")
                    }
                })
            }
        })
    }
    
    
    func getCredentialFacebook(viewControlSelf : UIViewController?, completion: @escaping (AuthCredential?)->()){
        let loginManager = LoginManager()
        var credential : AuthCredential!
        loginManager.logIn(permissions: facebookReadPermissions, from: viewControlSelf) { (loginResult, error) in
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
                    print("PErmision \(loginResult?.token?.tokenString ?? "X")")
                    credential = FacebookAuthProvider.credential(withAccessToken: (loginResult?.token!.tokenString)!)
                }else{
                    print("Problemas login facebook")
                }
                completion(credential)
            }
        }
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


