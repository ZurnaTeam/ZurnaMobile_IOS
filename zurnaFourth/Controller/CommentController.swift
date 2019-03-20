//
//  CommentController.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let urlPost = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
    let session = URLSession.shared
    
    private var camePost = sendedPost
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 16
    
    var comments: [String]? = [String]()

    //Comment Send
    let commentPostContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .red
        //            textView.text = "deneme"
        textView.isUserInteractionEnabled = true
        textView.layer.cornerRadius = 15
        return textView
    }()
    let commentSendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Send", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
   
    
    override func viewDidLoad() {
        
        setupCollectionViewLayout()
        
        setupCollectionView()
        tabBarController?.tabBar.isHidden = true
        view.addSubview(commentPostContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: commentPostContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(40)]", views: commentPostContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: commentPostContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupCommentSendComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        getCommentsFromAPI()
    }
    
    fileprivate func getCommentsFromAPI() {
        let task = self.session.dataTask(with: self.urlPost!) { (data, response, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertController.Style.alert)
                let okBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
            }else{
                if data != nil{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                        
                        DispatchQueue.main.async {
                            //print(jsonResult)
                            for i in 0..<jsonResult.count{
                                self.comments?.append(jsonResult["title"]! as! String)
                            }
                            self.collectionView.reloadData()
                        }
                    }catch{
                        
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    @objc func handleKeyboard(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint?.constant = isKeyboardShowing ?  -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if isKeyboardShowing{
                    let indexPath = IndexPath(item: (self.comments!.count-1), section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    private func setupCommentSendComponents(){
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        commentPostContainerView.addSubview(commentTextView)
        commentPostContainerView.addSubview(commentSendButton)
        commentPostContainerView.addSubview(topBorderView)
        commentPostContainerView.addConstraintsWithFormat(format: "H:|-5-[v0][v1]|", views: commentTextView,commentSendButton)
        commentPostContainerView.addConstraintsWithFormat(format: "V:[v0(40)]|", views: commentTextView)
        commentPostContainerView.addConstraintsWithFormat(format: "V:[v0(40)]|", views: commentSendButton)
        
        commentPostContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        commentPostContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
    
    fileprivate func setupCollectionViewLayout() {
        //layout customization
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .yellow
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.register(CommentViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
    }
    
    //Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CommentHeaderView
        header.postTextView.text = camePost
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 70)
    }
    
    //Collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = comments?.count{
            return count
        }
        return 0
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentViewCell
        
        cell.backgroundColor = .black
        cell.frame.offsetBy(dx: 0, dy: 0)
        if let commentContent = comments?[indexPath.row]{
            cell.commentTextField.text = commentContent
            cell.commentTextField.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * padding, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        commentTextView.endEditing(true)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
