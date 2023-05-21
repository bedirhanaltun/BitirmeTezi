//
//  MailViewController.swift
//  BitirmeTeziFinale
//
//  Created by Bedirhan Altun on 19.05.2023.
//

import UIKit

class MailViewController: UIViewController {

    @IBOutlet weak var mailTableView: UITableView!
    var mails : [Mails] = []
    var tokenForLogin : String? = UserDefaults.standard.object(forKey: "tokenForLogin") as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        mailTableView.delegate = self
        mailTableView.dataSource = self
        
        print("TokenForLogin: \(tokenForLogin)")
        
        fetchEmails(token: tokenForLogin ?? "123") { mailChecked in
            
            guard let mailListChecked = mailChecked else { return }
            
            self.mails = mailListChecked.mails
            
            DispatchQueue.main.async {
                self.mailTableView.reloadData()
            }
        }
    }
    
    func fetchEmails(token: String, completion: @escaping (MailModel?) -> Void) {
        guard let mailUrl = URL(string: "http://192.168.193.20:8080/api/v1/mail/getUsersEmails/all") else { return }
        
        var mailRequest = URLRequest(url: mailUrl)
        mailRequest.httpMethod = "GET"
        mailRequest.allHTTPHeaderFields = ["Authorization" : token]
        
        URLSession.shared.dataTask(with: mailRequest) { mailData, mailResponse, mailError in
            if let mailError = mailError {
                DispatchQueue.main.async {
                    completion(nil)
                    print("Mail error \(mailError.localizedDescription)")
                }
            }
            
            guard let mailData = mailData else {
                DispatchQueue.main.async {
                    print("Bad Data")
                    completion(nil)
                }
                return
            }
            
            guard let mailResponse = mailResponse as? HTTPURLResponse else {
                print("Bad response")
                return
                
            }
            
            do {
                let mailDataChecked = try JSONDecoder().decode(MailModel.self, from: mailData)
                
                DispatchQueue.main.async {
                    completion(mailDataChecked)
                }
            }
            catch {
                print(String(describing: error))
            }
        }
        .resume()
    }
    
}

extension MailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mailTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MailCell
        cell.titleLabel?.text = mails[indexPath.row].subject
        cell.fromUserLabel.text = mails[indexPath.row].fromUser
        
        cell.contentLabel.text = mails[indexPath.row].content
        return cell
    }
    
    
}
