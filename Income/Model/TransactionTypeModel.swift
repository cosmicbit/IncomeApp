//
//  TransactionTypeModel.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import Foundation


enum TransactionType: Int, CaseIterable, Identifiable {
	case income, expense
	var id: Self { self }
	
	var title: String {
		switch self {
		case .income:
			"income"
		case .expense:
			"expense"
		}
	}
}
