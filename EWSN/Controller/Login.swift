//
//  Login.swift
//  EWSN
//
//  Created by Noh Tewolde on 4/9/19.
//  Copyright © 2019 Noh Tewolde. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Login: UIViewController {
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var failureMesage: UILabel!
    @IBOutlet weak var username: UITextField!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blueBackground")!)
        username.becomeFirstResponder()
        ref = Database.database().reference()
    }


    @IBAction func login(_ sender: UIButton) {
        signUserAccount()
        let nc = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        present(nc!, animated: true, completion: nil)
    }
    
    
    @IBAction func newUserSignUp(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Join")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
    }
    
    func signUserAccount(){
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (result, error) in
            if error == nil{
                if let user = result?.user {
                    print(user.email!)
                    self.failureMesage.text = "Successful login"
                } else {
                    print((error?.localizedDescription)!)
                }
            } else {
                self.failureMesage.text = "Failure to login. Check your username or password"
            }
        }
    }
    
}
