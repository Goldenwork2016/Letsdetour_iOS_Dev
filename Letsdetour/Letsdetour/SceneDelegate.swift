//
//  SceneDelegate.swift
//  Letsdetour
//
//  Created by Jaypreet on 21/08/21.
//

import UIKit
import FBSDKLoginKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let urlinfo = userActivity.webpageURL{
            
          print ("Universial Link Open at SceneDelegate on App Start ::::::: \(urlinfo.absoluteString)")
          self.OpenDeepLinkView(url: urlinfo.absoluteString ?? "")

          print( "Deeplink" + "\(urlinfo.absoluteString)")
        }
        
        //deeplink Open
        if connectionOptions.urlContexts.first?.url != nil {
          let urlinfo = connectionOptions.urlContexts.first?.url
            
            print ("Deeplink Open at SceneDelegate on App Start ::::::: \(String(describing: urlinfo))")

          self.OpenDeepLinkView(url: urlinfo?.absoluteString ?? "")

        }
        
        guard let _ = (scene as? UIWindowScene) else { return }

    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }


    // Universial link Open when app is onPause
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let urlinfo = userActivity.webpageURL{
            
            print ("Universial Link Open at SceneDelegate on App Pause  ::::::: \(urlinfo)")
          self.OpenDeepLinkView(url: urlinfo.absoluteString ?? "")


          
        
        }
    }
    
    
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//
//        let urlinfo = URLContexts.first?.url
//        print ("Deeplink Open on SceneDelegate at App Pause :::::::: \(String(describing: urlinfo))")
//      self.OpenDeepLinkView(url: urlinfo?.absoluteString ?? "")
//    }
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
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    func getParameter(url: String, param: String) -> Bool? {
      guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.contains(where: { $0.name == param })
    }
    func OpenDeepLinkView(url : String)  {
        if DataManager.CurrentUserData == nil{
            return
        }
        let test1 = getQueryStringParameter(url: url, param: "link")
        print(test1 ?? "")
        let test2 = getQueryStringParameter(url: test1 ?? "", param: "invitedby")
        print(test2 ?? "")
        
        
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
        if getParameter(url: test2 ?? "", param: "feed")!{
        }
        if getParameter(url: test2 ?? "", param: "inviteBy")!{
        }
        if getParameter(url: test2 ?? "", param: "travel")!{
        }
        
//        let home = mainStoryboard.instantiateViewController(withIdentifier: "PopularGroupsViewController") as! PopularGroupsViewController
//        home.isDeepLink = true
//        home.DeepLinkId = test2 ?? ""
//        let homeNavigation = UINavigationController(rootViewController: home)
//        homeNavigation.isNavigationBarHidden = true
//        homeNavigation.modalPresentationStyle = .fullScreen
        
        
        
      
                                                         
//        window?.rootViewController = homeNavigation
        window?.makeKeyAndVisible()

       
//        }
    }
}

