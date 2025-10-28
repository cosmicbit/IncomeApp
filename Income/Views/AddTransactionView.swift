//
//  AddTransactionView.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
	
	@State private var amount = 0.0
	@State private var transactionTitle: String = ""
	@State private var selectedTransactionType: TransactionType = .expense
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showAlert = false
	var transactionToEdit: TransactionModel?
	@Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
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
				
				if let transactionToEdit = transactionToEdit {
                    transactionToEdit.title = transactionTitle
                    transactionToEdit.type = selectedTransactionType
                    transactionToEdit.amount = amount
				} else {
                    let transaction = TransactionModel(
                        id: UUID(),
                        title: transactionTitle,
                        type: selectedTransactionType,
                        amount: amount,
                        date: Date()
                    )
                    context.insert(transaction)
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
	AddTransactionView()
}
