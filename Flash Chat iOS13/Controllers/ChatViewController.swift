//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    let db = Firestore.firestore()
    
    var message: [Message] = []
        
           
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    func loadMessages() {
        
    
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener  { (querySnapshot, error) in
             
             self.message = []
             
        if let e = error {
            print("there was an issue\(e)")
        } else {
            if let snapshotDocuments =  querySnapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    if let sender = data[K.FStore.senderField] as? String, let massegeBody = data[K.FStore.bodyField] as? String {
                        let newMessage = Message(sender: sender, body: massegeBody)
                        self.message.append(newMessage)
                        
                        // esto es para que busque la info ya que si no dependemos de la conexion a internet y no es lo suficientemente rapida para traer la info
                        DispatchQueue.main.async {
                            // aca recarga los msj
                            self.tableView.reloadData()
                            // esto es para mostrar el ultimo msj cuando se envia
                            let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                        
                    }
                }
            }
        }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender,K.FStore.bodyField:messageBody, K.FStore.dateField:Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("error con la carga de datos\(e)")
                    
                   
                }
            }
            self.messageTextfield.text = ""
            
            
        }
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
        
    }
    
}

extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = message[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages.body
        
        // para diferenciar quien envia el msj
        if messages.sender == Auth.auth().currentUser?.email {
            cell.leftImagenView.isHidden = true
            cell.rightImagenView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImagenView.isHidden = false
            cell.rightImagenView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            
        }
        
        
        return cell
    }
    
    
    
    
}

extension ChatViewController: UITableViewDelegate {
    
}
