//
//  ContactCell.swift
//  Contacts
//
//  Created by ikechukwu Michael on 11/11/2018.
//  Copyright © 2018 ikechukwu Michael. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    var link: ViewController?
    
    var starButton = UIButton(type: .system)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        starButton = UIButton(type: .system)
        //starButton.setTitle("Star..", for: .normal)
        starButton.setImage(UIImage(named: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.addTarget(self, action: #selector(handleFavoriteButton), for: .touchUpInside)
        accessoryView = starButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFavoriteButton(){
        print("favorite")
        // starButton.tintColor = .lightGray
        link?.customDelegation(cell: self)
    }
}


