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
        
        let injectedArtistsIDs = ["909253", "1171421960", "358714030", "1419227", "264111789"]
        let viewModel = ShuffleListViewModel(artistsIDs: injectedArtistsIDs, service: SongsAPIService())
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(ShuffleListViewController(viewModel: viewModel), animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}

