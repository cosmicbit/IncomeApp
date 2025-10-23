//
//  IncomeApp.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI
import CoreData

@main
struct IncomeApp: App {
	
	let dataManager = DataManager.shared
	
    var body: some Scene {
        WindowGroup {
            HomeView()
				.environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
