//
//  ContentView.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
	
	@State private var transactionToEdit: TransactionItem?
	@State private var showSettings = false
	
	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest(sortDescriptors: []) var transactions: FetchedResults<TransactionItem>
	@AppStorage("orderDescending") var orderDescending = false
	@AppStorage("currency") var currency = Currency.usd
	@AppStorage("filterMinimum") private var filterMinimum = 0.0
	
	private var displayTransactions: [TransactionItem] {
		let sortedTransactions = orderDescending ? transactions.sorted(by: { $0.wrappedDate < $1.wrappedDate }) : transactions.sorted(by: { $0.wrappedDate > $1.wrappedDate })
		let filteredTransactions = sortedTransactions.filter { $0.amount > filterMinimum }
		return filteredTransactions
	}
	
	private var expenses : String {
		let sumExpenses = transactions.filter({ $0.wrappedTransactonType == .expense }).reduce(0) { $0 + $1.amount }
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
		return numberFormatter.string(from: sumExpenses as NSNumber) ?? "US$0.00"
	}
	
	private var income : String {
		let sumIncome = transactions.filter({ $0.wrappedTransactonType == .income }).reduce(0) { $0 + $1.amount }
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = currency.locale
		return numberFormatter.string(from: sumIncome as NSNumber) ?? "US$0.00"
	}
	
	private var balance: String {
		let total = transactions.reduce(0) {
			switch $1.wrappedTransactonType {
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
				AddTransactionView()
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
				AddTransactionView(transactionToEdit: transactionToEdit)
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
	
	private func delete(at offsets: IndexSet) {
		for index in offsets {
			let transactionToDelete =  transactions[index]
			viewContext.delete(transactionToDelete)
		}
		
	}
}

#Preview {
	let dataManager = DataManager.sharedPreview
	return HomeView().environment(\.managedObjectContext, dataManager.container.viewContext)
}
