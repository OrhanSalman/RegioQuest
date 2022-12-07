//
//  Onboarding.swift
//  RegioQuest
//
//  Created by Orhan Salman on 29.11.22.
//

import SwiftUI
import CloudKit
import os

final class CloudKitService {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: CloudKitService.self)
    )

    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
}

@MainActor final class AccountServiceViewModel: ObservableObject {
    private static let logger = Logger(
//        subsystem: "com.aaplab.fastbot",
        subsystem: "de.salman.RegioQuest",
        category: String(describing: AccountServiceViewModel.self)
    )

    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine

    private let cloudKitService = CloudKitService()

    func fetchAccountStatus() async {
        do {
            accountStatus = try await cloudKitService.checkAccountStatus()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
}


struct AccountServiceView: View {
    @StateObject private var viewModel = AccountServiceViewModel()
    @State private var accountStatusAlertShown = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("startUsingApp") {
            if viewModel.accountStatus != .available {
                accountStatusAlertShown = true
            } else {
                dismiss()
            }
        }
        .alert("iCloudAccountDisabled", isPresented: $accountStatusAlertShown) {
            Button("cancel", role: .cancel, action: {})
        }
        .task {
            await viewModel.fetchAccountStatus()
        }
    }
}



struct AccountServiceView_Previews: PreviewProvider {
    static var previews: some View {
        AccountServiceView()
    }
}
