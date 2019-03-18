//
//  BaseCell.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
    }
        
}
