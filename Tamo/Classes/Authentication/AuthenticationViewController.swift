//
//  AuthenticationViewController.swift
//  Tamo
//
//  Created by Reashed Tulon on 25/2/21.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var usersArray = [Users]()
    var givenEmail: String?
    var givenPassword: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionToGetUserDetails(notification:)), name: notificationObserverToGetUserdetails, object: nil)
    }
    
    @objc func notificationActionToGetUserDetails(notification: NSNotification) {
        let error = notification.object
        if (error == nil) {
            if notification.userInfo != nil {
                usersArray = notification.userInfo!["response"] as! [Users]
                var isEmailMatched: Bool?
                var isPasswordMatched: Bool?
                var finalUser: Users?
                
                let semaphore = DispatchSemaphore(value: 0)
                let serialQueue = DispatchQueue(label: "com.queue.Serial")

                serialQueue.async {
                    AuthenticationManager.shared.checkIfUserEmailMatched(email: self.givenEmail!, userArray: self.usersArray) { (isMatched) in
                        isEmailMatched = isMatched
                        semaphore.signal()
                    }
                    semaphore.wait()
                    
                    if isEmailMatched == false {
                        self.popupAlert(title: "Not Found!", message: "\(String(describing: self.givenEmail!)) hasn't been used yet!", actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                        }])
                    } else {
                        AuthenticationManager.shared.checkIfUserPasswordMatched(password: self.givenPassword!, userArray: self.usersArray) { (isMatched, user) in
                            isPasswordMatched = isMatched
                            finalUser = user
                            semaphore.signal()
                        }
                        semaphore.wait()
                        
                        if isPasswordMatched == false {
                            self.popupAlert(title: "Wrong Password!", message: "The password is incorrect!", actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                }
                            }])
                        } else {
                            DispatchQueue.main.async {
                                self.saveUserIntoCoreData(user: finalUser!)
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.popupAlert(title: "Sorry!", message: notification.object as! String, actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in }])
            }
        }
    }
    
    func initialViewSetUp() {
        self.title = "Sign In"
        self.hideKeyboardWhenTapOnScreen()
        emailTextField.becomeFirstResponder()
        signInButton.roundedButton(borderWidth: 0, cornerRadius: 5, borderColor: .clear)
        emailTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationObserver()
        initialViewSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        if self.emailTextField.text?.isEmpty ?? true {
            self.popupAlert(title: "Required!", message: "Please enter your email address first!", actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in }])
            
        } else if self.passwordTextField.text?.isEmpty ?? true {
            self.popupAlert(title: "Required!", message: "Please enter your password!", actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in }])
            
        } else if !self.emailTextField.text!.isValidEmail {
            self.popupAlert(title: "Please check!", message: "Your email address is not valid!", actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in }])
            
        } else {
            activityIndicator.startAnimating()
            GetRequest.shared.retrieveDataFromUserList()
            givenEmail = self.emailTextField.text!
            givenPassword = self.passwordTextField.text!
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if self.emailTextField.text?.isEmpty == false {
                if !self.emailTextField.text!.isValidEmail {
                    self.popupAlert(title: "Please check!", message: "Your email address is not valid!", actionTitles: ["OK"], actionStyle: [.default], action: [{ ok in }])
                    
                }
            }
        }
    }
    
    func saveUserIntoCoreData(user: Users) {
        UserDefaults.standard.set(user.authToken, forKey: "authToken")
        UserDefaults.standard.set(user.userId, forKey: "userID")
        
        let dic = ["userId": user.userId!,
                   "authToken": user.authToken!,
                    "email": user.email!,
                    "password": user.password!,
                    "avatar": user.avatar!,
                    "firstName": user.firstName!,
                    "lastName": user.lastName!] as [String : Any]
        
        CoreDataService.shared.saveUser(object: dic)
        self.activityIndicator.stopAnimating()
        CommonService.shared.gotoEventsViewController()
    }
    
    deinit {
        removeNotificationObserver(viewController: self)
    }
}
