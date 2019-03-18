//
//  PostsViewCell.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class PostsViewCell: BaseCell {
    let postTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Sample Text"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .clear
        textField.isUserInteractionEnabled = false
        return textField
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(postTextField)
        addConstraintsWithFormat(format: "H:|-5-[v0]|", views: postTextField)
        addConstraintsWithFormat(format: "V:|[v0]|", views: postTextField)
    }
    
}
