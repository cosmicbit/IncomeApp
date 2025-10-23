//
//  AddTransactionView.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI

struct AddTransactionView: View {
	
	@State private var amount = 0.0
	@State private var transactionTitle: String = ""
	@State private var selectedTransactionType: TransactionType = .expense
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showAlert = false
	@Binding var transactions: [Transaction]
	var transactionToEdit: Transaction?
	@Environment(\.dismiss) var dismiss
	@AppStorage("currency") private var currency = Currency.usd
	
	var numberFormatter: NumberFormatter {
		let numberFormatter = NumberFormatter()
		numberFormatter.locale = currency.locale
		numberFormatter.numberStyle = .currency
		return numberFormatter
	}
	
    var body: some View {
        VStack {
            TextField("0.00", value: $amount, formatter: numberFormatter)
				.font(.system(size: 60, weight: .thin))
				.multilineTextAlignment(.center)
				.keyboardType(.numberPad)
			Rectangle()
				.fill(Color(uiColor: .lightGray))
				.frame(height: 0.5)
				.padding(.horizontal, 30)
			Picker("Choose Type", selection: $selectedTransactionType) {
				ForEach(TransactionType.allCases) { transactionType in
					Text(transactionType.rawValue.capitalized)
						.tag(transactionType)
				}
			}
			TextField("Title", text: $transactionTitle)
				.font(.system(size: 15))
				.textFieldStyle(.roundedBorder)
				.padding(.horizontal, 30)
				.padding(.top)
			Button {
				guard transactionTitle.count >= 2 else {
					alertTitle = "Invalid Title"
					alertMessage = "Title must be 2 or more characters long"
					showAlert = true
					return
				}
				
				let transaction = Transaction(title: transactionTitle, type: selectedTransactionType, amount: amount, date: Date())
				if let transactionToEdit = transactionToEdit {
					guard let indexOfTransaction = transactions.firstIndex(of: transactionToEdit) else {
						alertTitle = "Something went wrong"
						alertMessage = "Cannot update this transaction right now."
						showAlert = true
						return
					}
					let updatedTransaction = Transaction(title: transactionTitle, type: selectedTransactionType, amount: amount, date: transactionToEdit.date)
					transactions[indexOfTransaction] = updatedTransaction
				} else {
					transactions.append(transaction)
				}
				dismiss()
			} label: {
				Text(transactionToEdit == nil ? "Create" : "Update")
					.font(.system(size: 15, weight: .semibold))
					.foregroundStyle(.white)
					.frame(height: 40)
					.frame(maxWidth: .infinity)
					.background(.primaryLightGreen)
					.clipShape(RoundedRectangle(cornerRadius: 6))
			}
			.padding(.top)
			.padding(.horizontal, 30)
			Spacer()
        }
		.padding(.top)
		.onAppear(perform: {
			if let transactionToEdit = transactionToEdit {
				amount = transactionToEdit.amount
				transactionTitle = transactionToEdit.title
				selectedTransactionType = transactionToEdit.type
			}
		})
		.alert(alertTitle, isPresented: $showAlert) {
			Button {
			} label: {
				Text("OK")
			}
		} message: {
			Text(alertMessage)
		}

    }
}

#Preview {
	AddTransactionView(transactions: .constant([]))
}
