//
//  TransactionModel.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import Foundation

struct Transaction: Identifiable {
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
	
	var displayAmount: String {
		let numberFormatter = NumberFormatter()
		numberFormatter.currencySymbol = "US$"
		numberFormatter.numberStyle = .currency
		numberFormatter.maximumFractionDigits = 2
		return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
	}
}
