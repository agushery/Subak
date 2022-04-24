//
//  Onboarding.swift
//  Subak
//
//  Created by Agus Hery on 24/04/22.
//

import Foundation
import SwiftUI

struct Onboarding: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    NavigationLink(destination: AboutMe()) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Introduce")
                        }
                    }
                }
                HStack {
                    NavigationLink(destination: GameView()) {
                        HStack {
                            Image(systemName: "play")
                            Text("Play Now")
                        }
                    }
                }
            }
            .navigationTitle("Subak Apps")
            AboutMe()
        }
    }
}
