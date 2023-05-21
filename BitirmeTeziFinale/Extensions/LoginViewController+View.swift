//
//  LoginViewController+View.swift
//  BitirmeTeziFinale
//
//  Created by Bedirhan Altun on 21.05.2023.
//

import UIKit

extension LoginViewController {
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init()
            
        }
        
        
        guard let root = screen.windows.first?.rootViewController else { return .init()}
        
        return root
    }
    
    
    func getRoot() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init()
            
        }
        
        
        guard let root = screen.windows.first?.rootViewController else { return .init()}
        
        return root
    }
}
