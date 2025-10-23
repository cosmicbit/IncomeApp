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
	
	private init() {
		container.loadPersistentStores { storeDescription, error in
			if let error = error {
				print(error.localizedDescription)
			}
		}
	}
}
