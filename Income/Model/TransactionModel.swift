//
//  TransactionModel.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model class TransactionModel {
    
    let id: UUID
    var title: String
    var type: TransactionType
    var amount: Double
    let date: Date
    
    init(id: UUID, title: String, type: TransactionType, amount: Double, date: Date) {
        self.id = id
        self.title = title
        self.type = type
        self.amount = amount
        self.date = date
    }
}

extension TransactionModel {
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func displayAmount(currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
    }
}

struct Transaction: Identifiable, Hashable {
	let id = UUID()
	let title: String
	let type: TransactionType
	let amount: Double
	let date: Date
	
}

extension Transaction {
	var displayDate: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		return dateFormatter.string(from: date)
	}
	
	func displayAmount(currency: Currency) -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
		return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
	}
}
