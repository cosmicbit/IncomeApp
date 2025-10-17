//
//  ContentView.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI

struct HomeView: View {
	
	@State private var transactions: [Transaction] = [
		Transaction(title: "Apple", type: .expense, amount: 5.00, date: Date()),
		Transaction(title: "Apple", type: .expense, amount: 5.00, date: Date())
	]
	@State private var showEditTransactionView = false
	@State private var transactionToEdit: Transaction?
	
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
					VStack {
						Text("BALANCE")
							.font(.caption)
							.foregroundStyle(.white)
						Text("$2")
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
						Text("$22")
							.font(.system(size: 15, weight: .regular))
							.foregroundStyle(.white)
					}
					
					VStack(alignment: .leading) {
						Text("Income")
							.font(.system(size: 15, weight: .semibold))
							.foregroundStyle(.white)
						Text("$22")
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
