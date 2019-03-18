//
//  HeaderView.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 15)
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
        
        addSubview(postTextView)
        addSubview(sendButton)
        
        let centerY = frame.height/4
        
        addConstraintsWithFormat(format: "H:|[v0][v1(50)]-1-|", views: postTextView, sendButton)
        addConstraintsWithFormat(format: "V:|[v0(70)]", views: postTextView)
        addConstraintsWithFormat(format: "V:|-\(centerY)-[v0]-\(centerY)-|", views: sendButton) 

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

