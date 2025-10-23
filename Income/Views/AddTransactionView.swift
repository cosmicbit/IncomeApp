//
//  AddTransactionView.swift
//  Income
//
//  Created by Philips on 17/10/25.
//

import SwiftUI
import CoreData

struct AddTransactionView: View {
	
	@State private var amount = 0.0
	@State private var transactionTitle: String = ""
	@State private var selectedTransactionType: TransactionType = .expense
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showAlert = false
	var transactionToEdit: TransactionItem?
	@Environment(\.dismiss) private var dismiss
	@Environment(\.managedObjectContext) private var viewContext
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
					Text(transactionType.title.capitalized)
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
					transactionToEdit.amount = amount
					transactionToEdit.type = Int16(selectedTransactionType.rawValue)
					do {
						try viewContext.save()
					} catch {
						alertTitle = "Something went wrong"
						alertMessage = "Cannot update this transaction right now."
						showAlert = true
						return
					}
				} else {
					let transaction = TransactionItem(context: viewContext)
					transaction.id = UUID()
					transaction.title = transactionTitle
					transaction.type = Int16(selectedTransactionType.rawValue)
					transaction.amount = amount
					transaction.date = Date()
					do {
						try viewContext.save()
					} catch {
						alertTitle = "Something went wrong"
						alertMessage = "Cannot update this transaction right now."
						showAlert = true
						return
					}
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
				transactionTitle = transactionToEdit.wrappedTitle
				selectedTransactionType = transactionToEdit.wrappedTransactonType
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
