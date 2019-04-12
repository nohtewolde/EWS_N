//
//  UserList.swift
//  EWSN
//
//  Created by Noh Tewolde on 4/11/19.
//  Copyright © 2019 Noh Tewolde. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserList: UIViewController {

    @IBOutlet weak var tblUsers: UITableView!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "USERS"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blueBackground")!)
        ref = Database.database().reference()
    }

//    func getUsers(completionHandler : @escaping ([UserModel]?)->Void) {
//        let user = Auth.auth().currentUser
//        var friendArray : [UserModel] = []
//        let friendListdispatchGroup = DispatchGroup()
//        self.ref.child("User").child(user!.uid).child("FRIENDS").observeSingleEvent(of: .value) { (snapshot) in
//            if let friends = snapshot.value as? [String:Any] {
//                for friend in friends {
//                    friendListdispatchGroup.enter()
//                    
//                    self.ref.child("User").child(friend.key).observeSingleEvent(of: .value) { (friendSnapShot) in
//                        guard let singleFriend = friendSnapShot.value as? Dictionary<String, Any> else {return}
//                        let info = ["fname": singleFriend["FirstName"] as! String,
//                                    "lname": singleFriend["Lastname"] as! String,
//                                    "email": singleFriend["Email"] as! String,
//                                    "address": singleFriend["Address"] as! String ,
//                                    "phone": singleFriend["Phone"] as! String,
//                                    "password": nil,
//                                    "image": nil,
//                                    "latitude": (singleFriend["latitude"] as! Double),
//                                    "longitude": (singleFriend["longitude"] as! Double)] as [String : Any?]
//                        var userModel = UserModel(friend.key, info: info)
//                        
//                        self.getUserImg(id: userModel.uid, completionHandler: { (data, error) in
//                            if error == nil && !(data == nil){
//                                userModel.image = UIImage(data: data!)
//                            }
//                            friendArray.append(userModel)
//                            friendListdispatchGroup.leave()
//                        })
//                    }
//                }
//                friendListdispatchGroup.notify(queue: .main) {
//                    completionHandler(friendArray)
//                }
//            } else {
//                completionHandler(nil)
//            }
//        }
//    }
    
    
    
}

extension UserList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblUsers.dequeueReusableCell(withIdentifier: "Cell") as? UserCell
        
        return cell!
    }
    
    
}
