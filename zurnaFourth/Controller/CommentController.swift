//
//  CommentController.swift
//  zurnaFourth
//
//  Created by Yavuz on 14.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate{
 
    private var camePost = sendedPost
    private var cameIndexPath: Int = sendedIndexPath
    private var camePostId: String = postId
    private var post: [Post] = [Post]()
    var upLabel = 0
    var downLabel = 0
    
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 16
    
    var comments: [String]? = [String]()

    //Comment Send
    let commentPostContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .lightGray
        textView.text = "Yorum yazın."
        textView.returnKeyType = .done
        textView.layer.borderWidth = 0.5
        textView.isUserInteractionEnabled = true
        textView.layer.cornerRadius = 20
        return textView
    }()
    let commentSendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.setTitle("Send", for: UIControl.State.normal)
        button.setTitleColor(.black, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(commentSendButtonAction), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.text == "Yorum yazın."{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text == ""{
            commentTextView.text = "Yorum yazın."
            commentTextView.textColor = .lightGray
            
        }
    }
    
    @objc func commentSendButtonAction(sender: UIButton!) {
        //Comment send butonu islemleri
        print("sendComment")
        
        if !commentTextView.text.isEmpty{
            if let comment = commentTextView.text{
                print(comment)
                Post.commentDownloadNPost(text: comment, id: camePostId, comment: true, rate: false, view: false)
                commentTextView.text = ""
                commentTextView.endEditing(true)
                //MARK burada comment yollanacak
            }
        }
    }
    
    fileprivate func getCommentsFromAPI() {
        let index = cameIndexPath
        Post.downloadStruct { (results:[Post]) in
            DispatchQueue.main.async {
                if let count = results[index].comments?.count{
                    for i in 0 ..< count{
                        if let text = results[index].comments![i].text{
                            self.comments?.append(text)
                        }
                    }
                }
                if let _ = results[index].content{
                    self.upLabel = (results[index].content?.like)!
                    self.downLabel = (results[index].content?.dislike)!
                }
                self.collectionView.reloadData()
            }
        }
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
        commentTextView.delegate = self
        commentPostContainerView.addSubview(topBorderView)
        commentPostContainerView.addConstraintsWithFormat(format: "H:|[v0]-1-[v1]|", views: commentTextView,commentSendButton)
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
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.register(CommentViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
    }
    
    //Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CommentHeaderView
        header.postTextView.text = camePost
        header.upLabel.text = upLabel.description
        header.downLabel.text = downLabel.description
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 80)
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
        
        cell.backgroundColor = .clear
        cell.frame.offsetBy(dx: 0, dy: 0)
        if let commentContent = comments?[indexPath.row]{
            cell.commentTextField.text = commentContent
            cell.commentTextField.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * padding, height: 50)
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
