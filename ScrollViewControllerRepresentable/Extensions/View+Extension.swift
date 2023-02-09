//
//  View+Extension.swift
//  ScrollViewControllerRepresentable
//
//  Created by Keke Arif on 2023/2/9.
//

import SwiftUI

extension View {

    func UIScrollView(isScrolling: Binding<Bool>, contentOffset: Binding<CGPoint>) -> some View {
            ScrollViewControllerRepresentable(isScrolling: isScrolling, contentOffset: contentOffset, content: self)
    }

}
