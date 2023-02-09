//
//  ScrollViewControllerRepresentable.swift
//  ScrollViewControllerRepresentable
//
//  Created by Keke Arif on 2023/2/9.
//

import SwiftUI

struct ScrollViewControllerRepresentable<Content>: UIViewControllerRepresentable where Content: View {

    // MARK: - Properties

    private let isScrolling: Binding<Bool>
    private let contentOffset: Binding<CGPoint>
    private let content: Content

    // MARK: - Initializers

    init(isScrolling: Binding<Bool>, contentOffset: Binding<CGPoint>, content: Content) {
        self.isScrolling = isScrolling
        self.contentOffset = contentOffset
        self.content = content
    }

    func makeUIViewController(context: Context) -> ScrollViewUIHostingController<Content> {
        ScrollViewUIHostingController(isScrolling: isScrolling, contentOffset: contentOffset, rootView: content)
    }
    
    func updateUIViewController(_ uiViewController: ScrollViewUIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
    }

}
