//
//  ContentView.swift
//  CallKitNotificationNotUpdating
//
//  Created by Adi on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(text)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: .constant("Hello world!"))
    }
}
