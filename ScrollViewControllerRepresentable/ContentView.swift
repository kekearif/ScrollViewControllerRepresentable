//
//  ContentView.swift
//  ScrollViewControllerRepresentable
//
//  Created by Keke Arif on 2023/2/9.
//

import SwiftUI

struct ContentView: View {

    private enum Constants {
        static let backgroundColor = Color.white
        static let textColor = Color.white
        static let itemBackgroundColor = Color.blue
    }

    // MARK: - Properties

    @State private var isScrolling = false
    @State private var contentOffset = CGPoint.zero

    private let strings = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]

    // MARK: - Views

    var body: some View {
        ZStack {
            Constants.backgroundColor
                .ignoresSafeArea()

            ScrollView {
                LazyVStack {
                    ForEach(strings, id: \.self) { text in
                        makeItem(text: text)
                    }
                }
                .padding()
            }
            .UIScrollView(isScrolling: $isScrolling, contentOffset: $contentOffset)
        }
        .onChange(of: isScrolling) { isScrolling in
            print("isScrolling? \(isScrolling)")
        }
        .onChange(of: contentOffset) { contentOffset in
            print("contentOffset? \(contentOffset)")
        }
    }

    // MARK: - Factory

    @ViewBuilder private func makeItem(text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .foregroundColor(Constants.textColor)
            .padding()
            .background(Constants.itemBackgroundColor)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
