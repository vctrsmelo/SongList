//
//  AppDelegate.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        
        let viewModel = ShuffleListViewModel(service: SongsAPIService())
        navigationController.pushViewController(ShuffleListViewController(viewModel: viewModel), animated: false)
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()

        return true
    }

}

