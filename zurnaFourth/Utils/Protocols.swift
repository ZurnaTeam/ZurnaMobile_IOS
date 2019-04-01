//
//  Protocols.swift
//  zurnaFourth
//
//  Created by Yavuz on 18.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

protocol PostControllerDelegate {
    func getPost(post: String)
}

protocol MenuOptionCellDelegate : class {
    func listForHashtag()
}
