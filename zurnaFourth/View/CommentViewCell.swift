//
//  CommentViewCell.swift
//  zurnaFourth
//
//  Created by Yavuz on 18.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class CommentViewCell: BaseCell {
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Sample Text"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .clear
        textField.isUserInteractionEnabled = false
        return textField
    }()
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:1.00, green:0.90, blue:0.83, alpha:1.0)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(commentTextField)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: textBubbleView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: textBubbleView)
        addConstraintsWithFormat(format: "H:|-5-[v0]|", views: commentTextField)
        addConstraintsWithFormat(format: "V:|[v0]|", views: commentTextField)
        
    }
    
}
