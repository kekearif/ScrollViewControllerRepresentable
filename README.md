# ScrollViewControllerRepresentable
contentOffset and begin/end dragging support for SwiftUI ScrollView

The SwiftUI `ScrollView` currently lacks support for setting the content offset. There also isn't a way to determine if the user has started or finished dragging the `ScrollView`. I wanted to tap into the functionality of `UIScrollView` while still retaining the original composition of `ScrollView` in my SwiftUI code. By placing the `ScrollView` content in a `UIHostingController` and then converting it to a `UIViewControllerRepresentable`, it is possible to achieve this. The `UIHostingController` is defined as follows:

```
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
```

Since `ScrollView` is actually a `UIScrollView` wrapped for SwiftUI, we can locate the `UIScrollView` during the `viewDidAppear` method and then set the different delegate methods.

The `UIViewControllerRepresentable` is defined as:

```
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
```

Now an extension can be added to `View`:

```
extension View {

    func UIScrollView(isScrolling: Binding<Bool>, contentOffset: Binding<CGPoint>) -> some View {
            ScrollViewControllerRepresentable(isScrolling: isScrolling, contentOffset: contentOffset, content: self)
    }

}
```

Finally at the call site:

```
var body: some View {
    ScrollView {
        LazyVStack {
            ForEach(items, id: \.self) { item in
                makeItem(text: item)
            }
        }
        .padding()
    }
    .UIScrollView(isScrolling: $isScrolling, contentOffset: $contentOffset)
}
```

An interesting, albeit hacky, approach to achieve this functionality.
