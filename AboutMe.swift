//
//  AboutMe.swift
//  Subak
//
//  Created by Agus Hery on 24/04/22.
//

import Foundation

import SwiftUI

struct AboutMe: View {
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    HStack {
                        Text("Hi, Judjes!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .kerning(1.3)
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding()
                    
                    Image("Background")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 500, alignment: .center)
                    Spacer(minLength: 0)
                    Text("Subak")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top)
                    Spacer(minLength: 0)
                    Text("Subak is a traditional ecologically sustainable irrigation system that binds Balinese agrarian society together within the village's Bale Banjar community center and Balinese temples. The water management is under the authority of the priests in water temples, who practice Tri Hita Karana Philosophy, a self-described relationship between humans, the earth and the gods. Tri Hita Karana draws together the realm of spirit, the human world and nature. On 6 July 2012, subak was enlisted as a UNESCO World Heritage Site. Cultural Landscape of Bali Province: the Subak System as a Manifestation of the Tri Hita Karana Philosophy, consist of Supreme Water Temple Pura Ulun Danu Batur and Lake Batur, Subak Landscape of Pakerisan Watershed, Subak Landscape of Catur Angga Baturkaru, and Royal Temple of Taman Ayun has been inscribed upon a World Heritage List of The Conservation concerning the protection of the World Cultural and Natural Heritage. Inscription on this list confirm the outstanding universal value of cultural or natural property which deserves protection for the benefit of all humanity")
                        .fontWeight(.medium)
                        .kerning(1.1)
                        .multilineTextAlignment(.center)
                    Spacer(minLength: 0)
                    Text("In this game, you are asked to search for words that have been provided. First you must click Shuffle and  clicking and dropping the character that you think fits the list provided. Enjoy !!!")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .kerning(1.3)
                        .multilineTextAlignment(.center)
                        .background(.blue)
                    Spacer(minLength: 0)
                }
            }
        }
    }
}
