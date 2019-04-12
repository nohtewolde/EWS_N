//
//  FriendList.swift
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

class FriendList: UIViewController {

    @IBOutlet weak var tblFriends: UITableView!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FRIENDS"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blueBackground")!)
        ref = Database.database().reference()
    }
    
    func addFriend(friendId: String, completionHandler: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        self.ref.child("User").child(user!.uid).child("FRIENDS").updateChildValues([friendId : "FriendID"]) { (error, ref) in
            completionHandler(error)
        }
    }
    
    func removeFriend(friendId: String, completionHandler: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        self.ref.child("User").child(user!.uid).child("FRIENDS").child(friendId).removeValue() { (error, ref) in
            completionHandler(error)
        }
    }
//    adding and removing friends
    
    func getFriends(completionHandler : @escaping ([UserModel]?)->Void) {
        let user = Auth.auth().currentUser
        var friendArray : [UserModel] = []
        let friendListdispatchGroup = DispatchGroup()
        self.ref.child("User").child(user!.uid).child("FRIENDS").observeSingleEvent(of: .value) { (snapshot) in
            if let friends = snapshot.value as? [String:Any] {
                for friend in friends {
                    friendListdispatchGroup.enter()
                    
                    self.ref.child("User").child(friend.key).observeSingleEvent(of: .value) { (friendSnapShot) in
                        guard let singleFriend = friendSnapShot.value as? Dictionary<String, Any> else {return}
                        let info = ["fname": singleFriend["FirstName"] as! String,
                                    "lname": singleFriend["Lastname"] as! String,
                                    "email": singleFriend["Email"] as! String,
                                    "address": singleFriend["Address"] as! String ,
                                    "phone": singleFriend["Phone"] as! String,
                                    "password": nil,
                                    "image": nil,
                                    "latitude": (singleFriend["latitude"] as! Double),
                                    "longitude": (singleFriend["longitude"] as! Double)] as [String : Any?]
                        var userModel = UserModel(friend.key, info: info)
                        
                        self.getUserImg(id: userModel.uid, completionHandler: { (data, error) in
                            if error == nil && !(data == nil){
                                userModel.image = UIImage(data: data!)
                            }
                            friendArray.append(userModel)
                            friendListdispatchGroup.leave()
                        })
                    }
                }
                friendListdispatchGroup.notify(queue: .main) {
                    completionHandler(friendArray)
                }
            } else {
                completionHandler(nil)
            }
        }
    }

    func getUserImg(id : String, completionHandler: @escaping (_ data: Data?, _ error: String?) -> Void){
        if let user = Auth.auth().currentUser{
            let imagename = "UserImage/\(String(user.uid)).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imagename)
            storageRef.getData(maxSize: 1*300*300) { (data, error) in
                let img = UIImage(data: data!)
                print(img)
            }
        }
    }
    
}

extension FriendList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFriends.dequeueReusableCell(withIdentifier: "Cell") as? FriendCell
        
        return cell!
    }
    
    
}
