//
//  ViewController.swift
//  BitirmeTeziFinale
//
//  Created by Bedirhan Altun on 19.05.2023.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift


class LoginViewController: UIViewController {
    
    let signInConfig = GIDConfiguration(clientID: "912067323625-ko0qd4r5eplncenmeokpv3541d28po9m.apps.googleusercontent.com",serverClientID: "912067323625-htgebd2uj0o9i9td64vpus52ibv6731s.apps.googleusercontent.com")
    var loginToken : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.configuration = signInConfig
        let additionalScopes = [
            "https://www.googleapis.com/auth/gmail.labels",
            "https://www.googleapis.com/auth/gmail.send",
            "https://www.googleapis.com/auth/gmail.readonly",
            "https://www.googleapis.com/auth/gmail.compose",
            "https://www.googleapis.com/auth/gmail.insert",
            "https://www.googleapis.com/auth/gmail.modify",
            "https://www.googleapis.com/auth/gmail.settings.basic",
            "https://www.googleapis.com/auth/gmail.settings.sharing",
          ]
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self, hint: "", additionalScopes: additionalScopes) { user, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            self.loginRequest(idToken: user?.user.idToken?.tokenString ?? "2", authToken: user?.serverAuthCode ?? "2") { login in
                self.loginToken = login?.token ?? "16"
                print(self.loginToken)
                UserDefaults.standard.set(self.loginToken, forKey: "tokenForLogin")
            }
            self.performSegue(withIdentifier: "tabBarController", sender: nil)
        }
        
        
    }
    
    func loginRequest(idToken: String, authToken: String, completion: @escaping (LoginModel?) -> Void) {
        guard let url = URL(string: "http://192.168.193.20:8080/api/v1/user/login") else { return }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.httpMethod = "POST"
        loginRequest.allHTTPHeaderFields = ["X-IdToken" : idToken, "X-AuthToken" : authToken]
        
        URLSession.shared.dataTask(with: loginRequest) { loginData, loginResponse, loginError in
            if let loginError = loginError {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            guard let loginData = loginData else {
                print("Bad Data")
                return
                
            }
            
            guard let loginResponse = loginResponse as? HTTPURLResponse else {
                print("Bad Response")
                return
                
            }
            
            do {
                let loginResponseChecked = try JSONDecoder().decode(LoginModel.self, from: loginData)
                
                DispatchQueue.main.async {
                    completion(loginResponseChecked)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        .resume()
        
    }
    

 
}
