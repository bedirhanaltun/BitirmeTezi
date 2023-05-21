//
//  MailModel.swift
//  BitirmeTeziFinale
//
//  Created by Bedirhan Altun on 21.05.2023.
//

import Foundation

struct MailModel : Codable {
    let mails : [Mails]
}

struct Mails : Codable {
    let subject : String
    let content : String
    let fromUser : String
    let toUser : String
    
}
