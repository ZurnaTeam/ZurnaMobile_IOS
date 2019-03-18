//
//  FooterView.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    let postTextView: UITextView = {
        let textView = UITextView()
        //        textField.text = "Sa naber "
        textView.backgroundColor = .white
        
        textView.font = UIFont.systemFont(ofSize: 15)
        //textField.borderStyle = UITextField.BorderStyle.roundedRect
        //        textField.autocorrectionType = UITextAutocorrectionType.no
        //        textField.keyboardType = UIKeyboardType.default
        //        textField.returnKeyType = UIReturnKeyType.done
        //        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        //        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.black.cgColor
        
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.isUserInteractionEnabled = true
        
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "gonderBtn"), for: UIControl.State.normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .yellow
        
        //        let containerView = UIView()
        //        addSubview(containerView)
        //        containerView.isUserInteractionEnabled = true
        
        //        addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        //        addConstraintsWithFormat(format: "V:[v0]", views: containerView)
        
        addSubview(postTextView)
        addSubview(sendButton)
        
        let centerY = frame.height/4
        //        let centerX = frame.width/2
        print(centerY)
        
        addConstraintsWithFormat(format: "H:|[v0][v1(50)]-1-|", views: postTextView, sendButton)
        addConstraintsWithFormat(format: "V:|[v0(70)]", views: postTextView)
        addConstraintsWithFormat(format: "V:|-\(centerY)-[v0]-\(centerY)-|", views: sendButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
