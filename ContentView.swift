//
//  ContentView.swift
//  ChatDemoApp
//
//  Created by Venkateswari Devara on 21/08/26.
//

import SwiftUI
import ChatKit

struct ContentView: View {
    var body: some View {
        ChatKit.createChatView()
    }
}

#Preview {
    ContentView()
}
