//
//  SettingsView.swift
//  Income
//
//  Created by Philips on 22/10/25.
//

import SwiftUI

struct SettingsView: View {
	
	@AppStorage("orderDescending") private var orderDescending = false
	@AppStorage("currency") private var currency = Currency.usd
	@AppStorage("filterMinimum") private var filterMinimum = 0.0
	
	var numberFormatter: NumberFormatter {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
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
