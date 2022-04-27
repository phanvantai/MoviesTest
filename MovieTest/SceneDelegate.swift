//
//  SceneDelegate.swift
//  MovieTest
//
//  Created by TaiPV on 4/27/22.
//

import UIKit

/// Just for demo
/// vm/repositories/usecases and other dependencies should belong an injection container
/// Base url/ api key should be in build config/encrypted asset
let apiDataTransferService: DataTransferService = {
    let config = ApiDataNetworkConfig(baseURL: URL(string: "https://api.themoviedb.org")!, queryParameters: ["api_key": "26763d7bf2e94098192e629eb975dab0"])
    
    let apiDataNetwork = DefaultNetworkService(config: config)
    return DefaultDataTransferService(with: apiDataNetwork)
}()

let imageDataTransferService: DataTransferService = {
    let config = ApiDataNetworkConfig(baseURL: URL(string: "https://image.tmdb.org")!)
    let imagesDataNetwork = DefaultNetworkService(config: config)
    return DefaultDataTransferService(with: imagesDataNetwork)
}()

let defaultMoviesListVM = DefaultMoviesListViewModel(discoverMoviesUseCase: DefaultDiscoverMoviesUseCase(moviesRepository: DefaultMoviesRepository(dataTransferService: apiDataTransferService)))


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController(rootViewController: MoviesListViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}

