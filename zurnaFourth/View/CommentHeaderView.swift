//
//  CommentHeaderView.swift
//  zurnaFourth
//
//  Created by Yavuz on 18.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class CommentHeaderView: UICollectionReusableView {
    var camePost = ""
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
        textView.isEditable = false
        
        return textView
    }()
    let rateView: UIView = {
        let view = UIView()
        return view
    }()
    
    let upButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "upBtnImg"), for: UIControl.State.normal)
//        button.setTitle("Up", for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(upButtonAction), for: .touchUpInside)
        return button
    }()
    let downButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "downBtnImg"), for: UIControl.State.normal)
//        button.setTitle("Down", for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(downButtonAction), for: .touchUpInside)
        return button
    }()
    let upLabel: UILabel = {
        let label = UILabel()
        label.text = "1000"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let downLabel: UILabel = {
        let label = UILabel()
        label.text = "1000"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .clear
        
        
        addSubview(postTextView)
        addSubview(rateView)
        rateView.addSubview(upButton)
        rateView.addSubview(downButton)
        rateView.addSubview(upLabel)
        rateView.addSubview(downLabel)
        
        addConstraintsWithFormat(format: "H:|[v0][v1(50)]-1-|", views: postTextView, rateView)
        addConstraintsWithFormat(format: "V:|[v0(70)]", views: postTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: rateView)
        
        let rateCenterY = rateView.frame.height/3
        addConstraintsWithFormat(format: "H:[v0]|", views: upButton)
        addConstraintsWithFormat(format: "H:[v0]|", views: downButton)
        addConstraintsWithFormat(format: "H:[v0]|", views: upLabel)
        addConstraintsWithFormat(format: "H:[v0]|", views: downLabel)
        
//        addConstraintsWithFormat(format: "V:|-\(rateCenterY)-[v0][v1][v2][v3]-\(rateCenterY)-|", views: upLabel, upButton, downButton, downLabel)
        addConstraintsWithFormat(format: "V:|[v0][v1][v2][v3]|", views: upLabel, upButton, downButton, downLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func upButtonAction(sender: UIButton!) {
        //Up butonu islemleri
        print("up")
        Post.commentDownloadNPost(text: "", id: postId, comment: false, rate: true, view: false)
    }
    @objc func downButtonAction(sender: UIButton!) {
        //Down butonu islemleri
        print("down")
        Post.commentDownloadNPost(text: "", id: postId, comment: false, rate: false, view: false)
    }
}

