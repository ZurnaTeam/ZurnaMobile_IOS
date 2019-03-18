//
//  ExtensionForUIView.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class ExtensionForUIView: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let redView = UIView()
//
//        let blueView = UIView()
//        blueView.backgroundColor = .blue
//
//        let greenView = UIView()
//        greenView.backgroundColor  = .green
//
//        [redView, blueView, greenView].forEach{ view.addSubview($0)}
//
//        redView.backgroundColor = .red
//
//        redView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 100, height: 100))
//        redView.heightAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
//
//        blueView.anchor(top: redView.bottomAnchor, leading: nil, trailing: redView.trailingAnchor, bottom: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
//        blueView.anchorSize(to: redView)
//
//        greenView.anchor(top: redView.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: redView.leadingAnchor, bottom: blueView.bottomAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
//
//        let purpleView = UIView()
//            purpleView.backgroundColor = .purple
//            view.addSubview(purpleView)
//           purpleView.fillSuperView()
//
//    }
    
}
extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func fillSuperView(){
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.bottomAnchor)
    }
    
    func anchorSize(to view: UIView){
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero ){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }

        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
            
        }
    }
    
}
