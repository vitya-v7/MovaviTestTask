//
//  SceneDelegate.swift
//  TestTaskMovavi
//
//  Created by Admin. on 04.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let newsView = AbstractFactory.createNewsListModule()
		let navVc = UINavigationController.init(rootViewController: newsView)
		self.window = UIWindow(windowScene: windowScene)
		self.window!.rootViewController = navVc
		self.window!.makeKeyAndVisible()
	}
}

