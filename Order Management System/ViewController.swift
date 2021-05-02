//
//  ViewController.swift
//  Order Management System
//
//  Created by Apalya on 24/04/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var regUserName: UITextField!
    @IBOutlet weak var regUserPhone: UITextField!
    @IBOutlet weak var regUserLocation: UITextField!
    @IBOutlet weak var regPassword: UITextField!
    @IBOutlet weak var regConfirmPasswd: UITextField!
    @IBOutlet weak var regSubmit: UIButton!
    
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var rememberCheck: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var isRememberMeEnabled:Bool = false
    var profileData:UserProfile? = nil
    
    let userContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var admin:[User]?
    var availAdminUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        showRegister("")
        fetchAdminLogin()
        checkUserLogin()
    }
    
    func fetchAdminLogin() {
        do{
            self.admin = try userContext.fetch(User.fetchRequest())
            if self.admin?.count ?? 0 < 1{
                return
            }
            availAdminUser = self.admin?[0]
        }catch{
            print("error while fetching Admin")
        }
    }
    
    func checkUserLogin() {
        if self.admin?.count ?? 0 < 1{
            showRegister("")
            return
        }
        
        if self.getUserLogin() == true{
            self.navigateToOrderListPage()
        }else{
            self.showSignin("")
            let rememberStatus:Bool = self.getRememberMeStatus()
            self.rememberMyCred(isEnabled: rememberStatus)
        }
    }

    @IBAction func showSignin(_ sender: Any) {
        self.registerView.isHidden = true
        self.signinView.isHidden = false
        self.registerBtn.backgroundColor = .white
        self.signinBtn.backgroundColor = .gray
        self.view.bringSubviewToFront(self.signinView)
        
        if isRememberMeEnabled {
            // Assign userName and password data here
        }
    }
    
    @IBAction func showRegister(_ sender: Any) {
        self.registerView.isHidden = false
        self.signinView.isHidden = true
        self.registerBtn.backgroundColor = .gray
        self.signinBtn.backgroundColor = .white
        self.view.bringSubviewToFront(self.registerView)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let userName:String = self.regUserName.text ?? ""
        let userPhone:String = self.regUserPhone.text ?? ""
        let userLocation:String = self.regUserLocation.text ?? ""
        let userpswd:String = self.regPassword.text ?? ""
        let cnfPswd:String = self.regConfirmPasswd.text ?? ""
        if userName.count == 0 || userpswd.count == 0 || cnfPswd.count == 0 || userPhone.count == 0 || userLocation.count == 0
        {
            self.showAlertForUser(message:"Please Enter Essential Details")
            return
        }
        
        if userpswd.elementsEqual(cnfPswd) == false{
            
            self.showAlertForUser(message:"Please enter correct password")
            return
        }
        
        let admin:User = User(context: self.userContext)
        admin.userName = userName
        admin.userPhone = userPhone
        admin.userAddress = userLocation
        admin.userPassword = userpswd
        
        do{
            try self.userContext.save()
        }catch{
            print("error while adding Admin")
        }
        
        self.fetchAdminLogin()
        showSignin("")
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let availAdmin:User = self.availAdminUser {
            let userName:String =  availAdmin.userName ?? ""
            let userpswd:String = availAdmin.userPassword ?? ""
            print(userName)
            print(userpswd)
            if userName.elementsEqual(self.loginUserName.text ?? "") == false || userpswd.elementsEqual(self.loginPassword.text ?? "") == false
            {
                self.showAlertForUser(message:"Please enter correct Credentials")
                return
            }
            else{
                //Login status will be saved in User defaults
                self.saveUserLOgin()
                self.navigateToOrderListPage()
            }
        }
    }
    
    func navigateToOrderListPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated:true, completion:nil)
    }
    
        
    @IBAction func rememberMe(_ sender: Any) {
        self.rememberMyCred(isEnabled: !self.isRememberMeEnabled)
    }
    
    // login status of user stored in userdefaults
    func saveUserLOgin() {
        let defaults : UserDefaults = UserDefaults.standard
        defaults.set(true , forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    func getUserLogin() -> Bool {
        let defaults : UserDefaults = UserDefaults.standard
        let isUserLogged = defaults.object(forKey: "userLoggedIn")
        if isUserLogged != nil && (isUserLogged as! Bool) == true {
            return true
        }
        return false
    }
    
    
    func rememberMyCred( isEnabled:Bool) {
        let defaults : UserDefaults = UserDefaults.standard
        if isEnabled {
            self.isRememberMeEnabled = true
            defaults.set(true , forKey: "rememberMyCred")
            self.rememberCheck.setImage(UIImage(systemName:"checkmark"), for: .normal)
        }else{
            self.isRememberMeEnabled = false
            defaults.set(true , forKey: "rememberMyCred")
            self.rememberCheck.setImage(UIImage(named:""), for: .normal)
        }
        defaults.synchronize()
        
    }
    
    func getRememberMeStatus() -> Bool {
        let defaults : UserDefaults = UserDefaults.standard
        let isRemember = defaults.object(forKey: "rememberMyCred")
        if isRemember != nil && (isRemember as! Bool) == true {
            return true
        }
        return false
    }
    
    @objc func showAlertForUser(message: String)
    {
        let alertController = UIAlertController(title: "Order Management", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localizedCapitalized, style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async(){
            self.present(alertController, animated: true, completion:nil)
        }
    }
}

