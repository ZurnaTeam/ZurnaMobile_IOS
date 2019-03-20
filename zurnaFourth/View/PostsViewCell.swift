//
//  PostsViewCell.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class PostsViewCell: BaseCell {
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Text"
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:1.00, green:0.90, blue:0.83, alpha:1.0) //UIColor(white: 0.95, alpha: 1)
//        view.backgroundColor = UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0)
        
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(postTextView)
        
//        addConstraintsWithFormat(format: "H:|-5-[v0]|", views: postTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: postTextView)
    }
    
}
