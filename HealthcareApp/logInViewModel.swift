//
//  logInViewModel.swift
//  HealthcareApp
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelDelegate: class {
    
    func stateChanged(to state: LogInViewModel.State)
}



@objcMembers class LogInViewModel: NSObject {
    
    @objc dynamic var buttonText: String = "Login"
    
    @objc dynamic var username: String = ""
    

    
    
    var state: State {
        didSet {
            delegate?.stateChanged(to: state)
        }
    }
    
    
    
    var registered: Bool = false {
        didSet {
            if registered {
                handledRegistered()
            } else {
                handleUnRegistered()
            }
        }
    }
    
    enum State {
        case initial
        case waiting
        case invalid
        case authenticated
    }
    
    
    weak var delegate: LoginViewModelDelegate?
    
    override init() {
        self.state = .initial
        registered = (UserSettings.storedUserName () != nil)
        
        super.init()
        
        if registered {
            handledRegistered()
        } else {
            handleUnRegistered()
        }
    }
    
    
    func handledRegistered() {
        buttonText = "Login"
        username = UserSettings.storedUserName() ?? ""
    }
    
    
    func handleUnRegistered() {
        buttonText = "Register"
        
    }
    
    
    func login(username: String, password: String) {
        state = .waiting
        if !registered {
            UserSettings.saveLogin(username: username, password: password)
        } else {
            if UserSettings.validateLogin(username: username, password: password) {
                state = .authenticated
            } else {
                state = .invalid
            }
        }
    }

}
