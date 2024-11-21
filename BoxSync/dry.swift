//
//  dry.swift
//  BoxSync
//
//  Created by Dimitris Chatzigeorgiou on 21/11/24.
//

import SwiftUI


// MARK: Code for the background of the views
struct BackgroundView: View {
    
    var body: some View {
        ZStack {
            Image("ocean")
                .resizable()
                .scaledToFill()

        }
        
    }
}


// MARK: Modifier for glass item contents
struct glassText: ViewModifier{
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View{
        content
            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
            .fontWeight(.semibold)
            .kerning(1.2)
    }
}
