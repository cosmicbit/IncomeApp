//
//  Currency.swift
//  Income
//
//  Created by Philips on 22/10/25.
//

import Foundation

enum Currency: Int, CaseIterable, Identifiable {
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
	
	var locale: Locale {
		switch self {
		case .usd:
			Locale(identifier: "en_US")
		case .pounds:
			Locale(identifier: "en_GB")
		}
	}
}
