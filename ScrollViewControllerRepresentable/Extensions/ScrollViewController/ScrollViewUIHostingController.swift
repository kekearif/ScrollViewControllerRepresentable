//
//  ScrollViewUIHostingController.swift
//  ScrollViewControllerRepresentable
//
//  Created by Keke Arif on 2023/2/9.
//

import SwiftUI

final class ScrollViewUIHostingController<Content>:
    UIHostingController<Content>, UIScrollViewDelegate where Content: View {

    // MARK: - Properties

    private let isScrolling: Binding<Bool>
    private var contentOffset: Binding<CGPoint>
    private var scrollView: UIScrollView?
    private var isFirstViewDidAppear = true

    // MARK: - Initializers


    init(isScrolling: Binding<Bool>, contentOffset: Binding<CGPoint>, rootView: Content) {
        self.isScrolling = isScrolling
        self.contentOffset = contentOffset

        super.init(rootView: rootView)
    }

    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        // Should only search for the scroll view once
        guard isFirstViewDidAppear else { return }

        scrollView = findScrollView(in: view)
        scrollView?.delegate = self
        isFirstViewDidAppear = false
    }

    // MARK: - Scroll View Find

    func findScrollView(in view: UIView?) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }

        for subview in view?.subviews ?? [] {
            if let scrollView = findScrollView(in: subview) {
                return scrollView
            }
        }

        return nil
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling.wrappedValue = true
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        isScrolling.wrappedValue = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffset.wrappedValue = scrollView.contentOffset
    }

}
