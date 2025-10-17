//
//  TransactionTypeModel.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import Foundation


enum TransactionType: String, CaseIterable, Identifiable {
	case income, expense
	var id: Self { self }
}
