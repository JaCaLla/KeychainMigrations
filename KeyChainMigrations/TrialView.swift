//
//  ContentView.swift
//  FreeAccessApp
//
//  Created by JAVIER CALATRAVA LLAVERIA on 8/6/25.
//

import SwiftUI
import Security


struct TrialView: View {

    @StateObject private var viewModel: TrialViewModel = TrialViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            Text("Current Trial Version: \(String(describing: viewModel.trialInfo?.version))")
                .font(.title)
            if viewModel.isTrialActive {
                Text("Trial period active")
                    .font(.title)
                    .foregroundColor(.green)

                Text("Remining time: \(viewModel.timeRemaining) secs")
                    .font(.headline)
            } else {
                Text("Test period has expired")
                    .font(.title)
                    .foregroundColor(.red)
            }
            #if DEBUG
            Button("Resetear prueba") {
                Task {
                    await viewModel.resetTrial()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            #endif
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.initializeTrial()
            }
        }
        .onReceive(timer) { _ in
            viewModel.updateTrialStatus()
        }
    }
}



#Preview {
    TrialView()
}
