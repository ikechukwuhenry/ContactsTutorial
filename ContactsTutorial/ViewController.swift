//
//  ViewController.swift
//  Contacts
//
//  Created by ikechukwu Michael on 11/11/2018.
//  Copyright © 2018 ikechukwu Michael. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    let cellId = "cellId123"
    let namesOfCEO = ["Steve", "Jack", "Ben", "Gray", "Moses", "Heth", "Zophar", "Machpelah"]
    let otherNames = ["Kelechi", "Tochukwu", "Eze igbo", "Benson", "Moses", "Caleb", "Macron", "Swift"]
    //    var twoDArrays = [ ExpandaleNames(isExpanded: true, names: ["Steve", "Jack", "Ben", "Gray", "Moses", "Heth", "Zophar", "Machpelah"]), ExpandaleNames(isExpanded: true, names: ["Kelechi", "Tochukwu", "Eze igbo", "Benson", "Moses", "Caleb", "Macron", "Swift"])
//    var twoDArrays = [ExpandaleNames(isExpanded: true, names: ["Steve", "Jack", "Ben", "Gray", "Moses", "Heth", "Zophar", "Machpelah"].map{FavoritableContact(name: $0, isFavorite: false)}), ExpandaleNames(isExpanded: true, names: ["Kelechi", "Tochukwu", "Eze igbo", "Benson", "Moses", "Caleb", "Macron", "Swift"].map{FavoritableContact(name: $0, isFavorite: false)})]
    var twoDArrays = [ExpandaleNames]()
    var showIndexPaths = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchContacts()
        navigationItem.title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Indexpath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return twoDArrays.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleOpenCl), for: .touchUpInside)
        button.tag = section
        return button
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDArrays[section].isExpanded {
            return 0
        }
        return twoDArrays[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        cell.link = self
        // let name = indexPath.section == 0 ? names[indexPath.row] : otherNames[indexPath.row]
        let myContact = twoDArrays[indexPath.section].names[indexPath.row]
        cell.textLabel?.text = myContact.contact.givenName + " " + myContact.contact.familyName
        cell.detailTextLabel?.text = myContact.contact.phoneNumbers.first?.value.stringValue
        if showIndexPaths {
//            cell.textLabel?.text = "\(contact.name) Section:\(indexPath.section) Row:\(indexPath.row)"
             cell.textLabel?.text = myContact.contact.givenName + " " + myContact.contact.familyName
        }
        cell.accessoryView?.tintColor = myContact.isFavorite ? .red : .lightGray
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    @objc func handleShowIndexPath(){
        print("Attempting reload animation of indexpath...")
        var indexPathToReload = [IndexPath]()
        for section in twoDArrays.indices {
            for index in twoDArrays[section].names.indices {
                let indexPath = IndexPath(row: index, section: section)
                indexPathToReload.append(indexPath)
            }
        }
        
        showIndexPaths = !showIndexPaths
        let animationStyle = showIndexPaths ? UITableView.RowAnimation.right : UITableView.RowAnimation.left
        
        tableView.reloadRows(at: indexPathToReload, with: animationStyle)
        
    }
    
    @objc func handleOpenCl(button: UIButton){
        print("tapping button")
        let section = button.tag
        
        var indexPathToReload = [IndexPath]()
        
        for index in twoDArrays[section].names.indices {
            let indexPath = IndexPath(row: index, section: section)
            indexPathToReload.append(indexPath)
        }
        
        
        let isExpanded = twoDArrays[section].isExpanded
        twoDArrays[section].isExpanded = !isExpanded
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        let _ = isExpanded ? tableView.deleteRows(at: indexPathToReload, with: .fade) : tableView.insertRows(at: indexPathToReload, with: .fade)
        
    }
    
    // method to call using custom delegation in ContactCell class
    
    func customDelegation(cell: UITableViewCell) {
        print("inside view controller")
        let indexPathTapped = tableView.indexPath(for: cell)
        print(indexPathTapped?.row)
        let contact = twoDArrays[indexPathTapped!.section].names[indexPathTapped!.row]
        let favorited = contact.isFavorite
        
        twoDArrays[indexPathTapped!.section].names[indexPathTapped!.row].isFavorite = !favorited
        //print(contact.)
        tableView.reloadRows(at: [indexPathTapped!], with: .fade)
    }
    
    //method to fetch user contacts
    private func fetchContacts(){
        print("inside fetch contacts")
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("failed to request access", err)
                return
            }
            if granted {
                print("access granted ..")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    var favoratableContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        print(contact.givenName)
                        favoratableContacts.append(FavoritableContact(contact: contact, isFavorite: false))
//                        favoratableContacts.append(FavoritableContact(name: contact.givenName + " " + contact.familyName, isFavorite: false))
                    })
                    let names = ExpandaleNames(isExpanded: true, names: favoratableContacts)
                    self.twoDArrays = [names]
                    print("new two d arrays")
                    
                }catch let err {
                    print("failed to enumerate contact", err)
                }
             
                
            }else {
                print("acces denied")
            }
        }
    }
}

