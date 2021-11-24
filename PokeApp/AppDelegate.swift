//
//  AppDelegate.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 28.04.2021.
//

import UIKit
import Swinject
import SwinjectStoryboard

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let container: Container = {
        let container = Container()
        container.register(PokemonDataSource.self, factory: { resolver in
            PokemonNetworkDataSource()
        })
        container.register(Store<PokemonState, PokemonAction>.self, factory: { resolver in
            Store(
                    middlewares: [
                        GetPokemonDetailsMiddlewareFactory.makeMiddleware(dataSource: container.resolve(PokemonDataSource.self)!),
                        NextPageMiddlewareFactory.makeMiddleware(dataSource: container.resolve(PokemonDataSource.self)!),
                        RefreshMiddlewareFactory.makeMiddleware(dataSource: container.resolve(PokemonDataSource.self)!),
                    ],
                    defaultValue: PokemonState(),
                    reducer: PokemonReducerFactory.makeReducer()
            )
        })

        return container
    }()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        injectDependencies()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        let swinjectStoryboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window.rootViewController = swinjectStoryboard.instantiateInitialViewController()

        return true
    }

    private func injectDependencies() {
        container.storyboardInitCompleted(ViewController.self) { (resolver, viewController) in
            viewController.store = resolver.resolve(Store<PokemonState, PokemonAction>.self)
        }
    }
}

