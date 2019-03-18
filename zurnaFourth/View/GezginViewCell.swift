//
//  GezginViewCell.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class GezginViewCell: BaseCell {
    let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Text"
        label.font = UIFont.systemFont(ofSize: 15)
        label.restorationIdentifier = "cellId"
        label.backgroundColor = .clear
        return label
        
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(countryLabel)
        addConstraintsWithFormat(format: "H:|-5-[v0]|", views: countryLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: countryLabel)
    }

}

