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
	
	var expenses : String {
		var sumExpenses = 0.0
		transactions.forEach {
			if $0.type == .expense {
				sumExpenses += $0.amount
			}
		}
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.currencySymbol = "US$"
		return numberFormatter.string(from: sumExpenses as NSNumber) ?? "US$0.0"
	}
	
	var income : String {
		var sumIncome = 0.0
		transactions.forEach {
			if $0.type == .income {
				sumIncome += $0.amount
			}
		}
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.currencySymbol = "US$"
		return numberFormatter.string(from: sumIncome as NSNumber) ?? "US$0.0"
	}
	
	var balance: String {
		var total = 0.0
		transactions.forEach {
			switch $0.type {
			case .income:
				total += $0.amount
			case .expense:
				total -= $0.amount
			}
		}
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.currencySymbol = "US$"
		return numberFormatter.string(from: total as NSNumber) ?? "US$0.0"
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
						ForEach(transactions) { transaction in
							Button {
								transactionToEdit = transaction
							} label: {
								TransactionView(transaction: transaction)
									.foregroundStyle(.black)
							}
						}
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
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						
					} label: {
						Image(systemName: "gearshape.fill")
							.foregroundStyle(.black)
					}
				}
			}
		}
    }
}

#Preview {
    HomeView()
}
