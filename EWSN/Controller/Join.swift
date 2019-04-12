//
//  Join.swift
//  EWSN
//
//  Created by Noh Tewolde on 4/9/19.
//  Copyright © 2019 Noh Tewolde. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Join: UIViewController {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var firstname: UITextField!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blueBackground")!)
        firstname.becomeFirstResponder()
        ref = Database.database().reference()
    }
    @IBAction func gender(_ sender: UISwitch) {
        if sender.isOn{
            gender.text = "Female"
        } else {
            gender.text = "Male"
        }
    }
    
    @IBAction func Register(_ sender: UIButton) {
        lblMessage.text = ""
        let response = validate()
        switch response {
        case .success:
            createUserAccount()
        case .failure(_, let message):
            lblMessage.text = lblMessage.text! + message.localized()
            print(message.localized())
        }
        
    }
    
    func createUserAccount(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (result, error) in
            if error == nil{
                if let user = result?.user {
                    let dict = ["Firstname": self.firstname.text! , "Lastname" : self.lastname.text!, "Email" : user.email, "password" : self.password.text!, "Gender" : self.gender.text! ]
                    self.ref.child("User").child(user.uid).setValue(dict)
                    // For updating an instance use code below
                    //let dict = ["Fname": "Gaga"]
                    //self.ref.child("User").child(user.uid).updateChildValues(dict)
                }
            }else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func validate() -> Valid{
        let response = Validation.shared.validate(values: (ValidationType.email, email.text!),
                                                  (ValidationType.password, password.text!),
                                                  (ValidationType.stringWithFirstLetterCaps, lastname.text!),
                                                  (ValidationType.stringWithFirstLetterCaps, firstname.text!),
                                                  (ValidationType.alphabeticString, gender.text!))
        return response
    }
    
}
