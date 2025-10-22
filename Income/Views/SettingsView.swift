//
//  SettingsView.swift
//  Income
//
//  Created by Philips on 22/10/25.
//

import SwiftUI

struct SettingsView: View {
	
	@State private var orderDescending = false
	@State private var currency = Currency.usd
	@State private var filterMinimum = 0.0
	
	var numberFormatter: NumberFormatter {
		let numberFormatter = NumberFormatter()
		numberFormatter.currencySymbol = "US$"
		numberFormatter.numberStyle = .currency
		return numberFormatter
	}
	
    var body: some View {
		NavigationStack {
			List {
				HStack {
					Toggle(isOn: $orderDescending) {
						Text("Order \(orderDescending ? "(Earliest)" : "(Latest)")")
					}
				}
				HStack {
					Picker("Currency", selection: $currency) {
						ForEach(Currency.allCases) {
							currency in
							Text(currency.title)
						}
					}
				}
				HStack {
					Text("Filter Minimum")
					TextField("", value: $filterMinimum, formatter: numberFormatter)
						.multilineTextAlignment(.trailing)
				}
			}
			.navigationTitle("Settings")
		}
    }
}

#Preview {
    SettingsView()
}
