//
//  File.swift
//  Income
//
//  Created by Philips on 23/10/25.
//

import Foundation
import CoreData

class DataManager {
	
	let container = NSPersistentContainer(name: "IncomeData")
	static let shared = DataManager()
	static let sharedPreview: DataManager = {
		let manager = DataManager(inMemory: true)
		let transaction = TransactionItem(context: manager.container.viewContext)
		transaction.title = "Lunch"
		transaction.amount = 5
		transaction.date = Date()
		transaction.id = UUID()
		return manager
	}()
	
	private init(inMemory: Bool = false) {
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
		}
		
		container.loadPersistentStores { storeDescription, error in
			if let error = error {
				print(error.localizedDescription)
			}
		}
	}
}
