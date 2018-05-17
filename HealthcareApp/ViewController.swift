//
//  ViewController.swift
//  HealthcareApp
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var rememberLoginSwitch: UISwitch!
    
    
    let viewModel = LogInViewModel()
    let disposeBag = DisposeBag()
    let switchState = UserDefaults.standard.bool(forKey: "loginSwitch")
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        
        viewModel.delegate = self
        
        setupBindings()
        
        loginButton.setTitle(viewModel.buttonText, for: .normal)
        
        if switchState == true {
            usernameField.text = viewModel.username
        } else {
            return
        }
        
        usernameField.textContentType = .username
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rememberLoginSwitch.setOn(switchState, animated: true)
    }
    
    
    
 
    @objc var observation = [NSKeyValueObservation]()
    
    
    func setupBindings() {

        observation.append(viewModel.observe(\.buttonText, options: [.new]) { [weak self] object, change in
            guard let text = change.newValue else {
                return
            }
            self?.loginButton.setTitle(text, for: .normal)
            print ("Changed")
            
            })
        
        observation.append(viewModel.observe(\.username, options: [.new]) { [weak self] object, change in
            guard let text = change.newValue else {
                return
                
            }
            self?.usernameField.text = text
            
        })
    }
    
    // RE-FACTOR THIS
    
    @IBAction func rememberLoginSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            usernameField.text = viewModel.username
            UserDefaults.standard.set(true, forKey: "loginSwitch")
        } else {
            usernameField.text = ""
            UserDefaults.standard.set(false, forKey: "loginSwitch")
        }
        
    }
    
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }
        
        viewModel.login(username: username, password: password)
    }
    
    
}

extension ViewController: LoginViewModelDelegate {
    
    struct Route {
        static let login = "LoginSegue"
    }
    
    func stateChanged(to state: LogInViewModel.State) {
        switch state {
        case .initial:
            setInitialState()
        case .waiting:
            setWaitingState()
        case .invalid:
            setInvalidState()
        case .authenticated:
            setAuthenticatedState()
        }
    }
    
    
    func setInitialState() {
        activityIndicator.stopAnimating()
    }
    
    func setWaitingState() {
        activityIndicator.startAnimating()
    }
    
    func setAuthenticatedState() {
        performSegue(withIdentifier: Route.login, sender: nil)
    }
    
    func setInvalidState() {
        
        let alert = UIAlertController(title: "Error", message: "Invalid log in credentials", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}

