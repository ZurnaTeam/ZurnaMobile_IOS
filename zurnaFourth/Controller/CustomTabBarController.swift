//
//  CustomTabBarController.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        let postsController = PostsController(collectionViewLayout: layout)
        let gezginController = GezginController(collectionViewLayout: layout)
        
        let homeNavController = UINavigationController(rootViewController: postsController)
        homeNavController.tabBarItem.title = "Home"
        homeNavController.tabBarItem.image = UIImage(named: "home")
        
        navigationController?.pushViewController(gezginController, animated: true)
        gezginController.tabBarItem.title = "Gezgin"
        gezginController.tabBarItem.image = UIImage(named: "rocket")
        
        viewControllers = [homeNavController,gezginController]
    }
    private func createDummyNavControllerWithTitle(title: String) -> UINavigationController{
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        return navController
    }
}
