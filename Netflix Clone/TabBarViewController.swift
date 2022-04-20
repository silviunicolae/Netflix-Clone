//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 20.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let vcHome = UINavigationController(rootViewController: HomeViewController())
        let vcSearch = UINavigationController(rootViewController: SearchViewController())
        let vcComing = UINavigationController(rootViewController: ComingSoonViewController())
        let vcDownload = UINavigationController(rootViewController: DownloadsViewController())
        
        vcHome.tabBarItem.image = UIImage(systemName: "house")
        vcSearch.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vcComing.tabBarItem.image = UIImage(systemName: "square.on.square")
        vcDownload.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vcHome.title = "Home"
        vcSearch.title = "Search"
        vcComing.title = "Coming Soon"
        vcDownload.title = "Downloads"
        
        tabBar.tintColor = .label
        
        
        setViewControllers([vcHome, vcSearch, vcComing, vcDownload], animated: true)
    }


}

