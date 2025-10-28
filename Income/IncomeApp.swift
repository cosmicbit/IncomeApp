//
//  IncomeApp.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI
import SwiftData

@main
struct IncomeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: [
                    TransactionModel.self
                ])
        }
    }
}
