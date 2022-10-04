//
//  AppDelegate.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        getTrendingSearchTerms()
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //Get trending search terms
    func getTrendingSearchTerms() {
        let resource = Resource<TrendingSearchResponse>.trendingSearchTerms()
        let session = URLSession(configuration: URLSessionConfiguration.default)
            
        guard let request = resource.request else { return }
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TrendingSearchResponse.self, from: data)
                SettingManager.defaultManager.trendingSearchTerms = response.data
                
            } catch let error {
                print("error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }

}

