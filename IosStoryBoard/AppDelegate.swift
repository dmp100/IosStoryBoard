//
//  AppDelegate.swift
//  IosStoryBoard
//
//  Created by 성규현 on 3/20/25.
// test

import UIKit
import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://sgcnefzwgdnhkbrqwbds.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNnY25lZnp3Z2RuaGticnF3YmRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyMjQ5NzMsImV4cCI6MjA2NTgwMDk3M30.KQUo17ubwUAXRVkNIyjdYmBWZsqqQ2IN76EFleIuJsQ"
)



@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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


}

