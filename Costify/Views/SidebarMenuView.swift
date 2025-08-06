//
//  SidebarMenuView.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//

import SwiftUI

struct SidebarMenuView: View {
    var body: some View {
        Menu {
            Button {
                // Profile logic or navigation
            } label: {
                Label("Profile", systemImage: "person.circle")
            }
            Button {
                // Analytics logic or navigation
            } label: {
                Label("Analytics", systemImage: "chart.pie")
            }
            Button {
                // Log out or close app
            } label: {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
            }
        } label: {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .padding(.trailing, 8)
        }
    }
}
