//
//  Currency.swift
//  Income
//
//  Created by Philips on 22/10/25.
//

enum Currency: CaseIterable, Identifiable {
	var id: Self {self}
	case usd, pounds
	
	var title: String {
		switch self {
		case .usd:
			"USD"
		case .pounds:
			"Pounds"
		}
	}
}
