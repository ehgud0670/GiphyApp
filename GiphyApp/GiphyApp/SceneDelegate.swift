//
//  SceneDelegate.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        guard let coreDataGiphyManager = coreDataGiphyManager else { return }
        
        window.rootViewController = tabBarController(with: coreDataGiphyManager)
        window.makeKeyAndVisible()
    }
    
    var coreDataGiphyManager: CoreDataGiphyViewModel? {
        guard let context = (UIApplication.shared.delegate
            as? AppDelegate)?.persistentContainer.viewContext else { return nil }
        
        return CoreDataGiphyViewModel(context: context)
    }
    
    private func tabBarController(with coreDataGiphyManager: CoreDataGiphyViewModel) -> UITabBarController {
        let tabBarController = UITabBarController().then {
            $0.tabBar.barTintColor = .black
            $0.tabBar.tintColor = .systemPink
        }
        
        let homeViewController = HomeViewController().then {
            $0.coreDataManager = coreDataGiphyManager
            $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        }
        
        let favoriteViewController = FavoriteViewController().then {
            $0.coreDataGiphyViewModel = coreDataGiphyManager
            $0.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "star.fill"), tag: 1)
        }
        
        let randomViewController = RandomViewController().then {
            $0.tabBarItem = UITabBarItem(title: "랜덤", image: UIImage(systemName: "questionmark"), tag: 2)
        }
        
        tabBarController.viewControllers = [homeViewController,
                                            favoriteViewController,
                                            randomViewController]
        
        return tabBarController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
