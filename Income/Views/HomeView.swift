//
//  ContentView.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI

struct HomeView: View {
	
	@State private var transactions: [Transaction] = []
	@State private var showEditTransactionView = false
	@State private var transactionToEdit: Transaction?
	@State private var showSettings = false
	
	@AppStorage("orderDescending") var orderDescending = false
	@AppStorage("currency") var currency = Currency.usd
	@AppStorage("filterMinimum") private var filterMinimum = 0.0
	
	private var displayTransactions: [Transaction] {
		let sortedTransactions = orderDescending ? transactions.sorted(by: { $0.date < $1.date }) : transactions.sorted(by: { $0.date > $1.date })
		let filteredTransactions = sortedTransactions.filter { $0.amount > filterMinimum }
		return filteredTransactions
	}
	
	private var expenses : String {
		let sumExpenses = transactions.filter({ $0.type == .expense }).reduce(0) { $0 + $1.amount }
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
		return numberFormatter.string(from: sumExpenses as NSNumber) ?? "US$0.00"
	}
	
	private var income : String {
		let sumIncome = transactions.filter({ $0.type == .income }).reduce(0) { $0 + $1.amount }
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
		return numberFormatter.string(from: sumIncome as NSNumber) ?? "US$0.00"
	}
	
	private var balance: String {
		let total = transactions.reduce(0) {
			switch $1.type {
			case .income:
				$0 + $1.amount
			case .expense:
				$0 - $1.amount
			}
		}
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
		return numberFormatter.string(from: total as NSNumber) ?? "US$0.00"
	}
	
	fileprivate func FloatingButton() -> some View {
		VStack {
			Spacer()
			NavigationLink {
				AddTransactionView(transactions: $transactions)
			} label: {
				Text("+")
					.font(.largeTitle)
					.frame(width: 70, height: 70)
					.foregroundStyle(.white)
					.padding(.bottom, 7)
			}
			.background(.primaryLightGreen)
			.clipShape(Circle())
		}
	}
	
	fileprivate func BalanceView() -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 8)
				.fill(.primaryLightGreen)
			VStack(alignment: .leading, spacing: 8) {
				HStack {
					VStack(alignment: .leading) {
						Text("BALANCE")
							.font(.caption)
							.foregroundStyle(.white)
						Text("\(balance)")
							.font(.system(size: 42, weight: .light))
							.foregroundStyle(.white)
					}
					Spacer()
				}
				.padding([.top])
				
				HStack(spacing: 25) {
					VStack(alignment: .leading) {
						Text("Expense")
							.font(.system(size: 15, weight: .semibold))
							.foregroundStyle(.white)
						Text("\(expenses)")
							.font(.system(size: 15, weight: .regular))
							.foregroundStyle(.white)
					}
					
					VStack(alignment: .leading) {
						Text("Income")
							.font(.system(size: 15, weight: .semibold))
							.foregroundStyle(.white)
						Text("\(income)")
							.font(.system(size: 15, weight: .regular))
							.foregroundStyle(.white)
					}
				}
				Spacer()
			}
			.padding(.horizontal)
		}
		.shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
		.frame(height: 150)
		.padding(.horizontal)
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack {
					BalanceView()
					List {
						ForEach(displayTransactions) { transaction in
							Button {
								transactionToEdit = transaction
							} label: {
								TransactionView(transaction: transaction)
									.foregroundStyle(.black)
							}
						}
						.onDelete(perform: delete)
					}
					.scrollContentBackground(.hidden)
				}
				FloatingButton()
			}
			.navigationTitle("Income")
			.navigationDestination(item: $transactionToEdit, destination: { transactionToEdit in
				AddTransactionView(transactions: $transactions, transactionToEdit: transactionToEdit)
			})
			.navigationDestination(isPresented: $showEditTransactionView, destination: {
				AddTransactionView(transactions: $transactions)
			})
			.sheet(isPresented: $showSettings, content: {
				SettingsView()
			})
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showSettings = true
					} label: {
						Image(systemName: "gearshape.fill")
							.foregroundStyle(.black)
					}
				}
			}
		}
    }
	
	private func delete(at offset: IndexSet) {
		transactions.remove(atOffsets: offset)
	}
}

#Preview {
    HomeView()
}
