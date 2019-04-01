//
//  MenuOptionCell.swift
//  zurnaFourth
//
//  Created by Yavuz on 15.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {
    
    //MARK: - Properties
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "#sampleText"
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
        
        addSubview(descriptionLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: descriptionLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: descriptionLabel)
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers
}
