//
//  ZZSCollapsingTitleScrollView.swift
//  ZipZipSa
//

import SwiftUI

/// 큰 타이틀 + 고정 헤더(공간 탭) + 내용으로 이뤄진 체크리스트 스크롤 화면.
///
/// 타이틀이 반쯤 걸친 채로 멈추지 않도록, 스크롤이 멈추면 완전히 보이거나 완전히 가린 상태로 맞춘다.
/// 내용이 짧아 타이틀을 다 가릴 만큼 올라갈 수 없으면, 가린 상태에서만 내용에 최소 높이를 줘서
/// 올라갈 공간을 만든다. 탭(tab)을 바꿀 때 타이틀이 가려져 있었으면 그대로 가려 두어
/// 방금 누른 헤더가 움직이지 않게 한다. 맨 위로 돌아오면 최소 높이를 없앤다.
struct ZZSCollapsingTitleScrollView<Tab: Equatable, Title: View, Header: View, Content: View>: View {
    let tab: Tab
    var titleSpacing: CGFloat = 24
    var bottomMargin: CGFloat = 120
    @ViewBuilder let title: () -> Title
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content

    @State private var titleHeight: CGFloat = 0
    @State private var headerHeight: CGFloat = 0
    @State private var metrics = ScrollMetrics()
    /// 타이틀을 가린 상태를 유지하기 위해 내용에 최소 높이를 줄지
    @State private var keepsTitleCollapsed = false
    /// 코드로 스크롤을 옮기는 동안 맨 위 상태로 오인하거나 다시 스냅하지 않도록 막는다.
    @State private var isSettling = false

    private enum ScrollAnchor: Hashable {
        case expanded
        case collapsed
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    title()
                        .id(ScrollAnchor.expanded)
                        .onGeometryChange(for: CGFloat.self) { geometry in
                            geometry.size.height
                        } action: { newHeight in
                            titleHeight = newHeight
                        }
                    Spacer()
                        .frame(height: titleSpacing - 1)
                    // 이 지점이 화면 맨 위에 오면 타이틀이 가려지고 헤더가 맨 위에 붙는다.
                    // 높이가 0인 뷰는 scrollTo 대상에서 빠질 수 있어 1pt를 준다.
                    Color.clear
                        .frame(height: 1)
                        .id(ScrollAnchor.collapsed)
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section {
                            content()
                                .frame(minHeight: contentMinHeight, alignment: .top)
                        } header: {
                            header()
                                .onGeometryChange(for: CGFloat.self) { geometry in
                                    geometry.size.height
                                } action: { newHeight in
                                    headerHeight = newHeight
                                }
                        }
                    }
                }
            }
            .clipped()
            .scrollIndicators(.never)
            .contentMargins(.bottom, bottomMargin, for: .scrollContent)
            .onScrollGeometryChange(for: ScrollMetrics.self) { geometry in
                ScrollMetrics(geometry: geometry)
            } action: { _, newMetrics in
                metrics = newMetrics
                // 맨 위로 돌아와 타이틀이 보이면 최소 높이는 필요 없다.
                if !isSettling, keepsTitleCollapsed, offset <= 0.5 {
                    keepsTitleCollapsed = false
                }
            }
            .onScrollPhaseChange { _, newPhase in
                if newPhase == .idle {
                    snapTitle(proxy: proxy)
                }
            }
            .onChange(of: tab) { _, _ in
                // 맨 위(타이틀이 보이는 상태)였으면 그대로 둔다.
                guard offset > 0.5 else { return }
                // 최소 높이는 새 탭 내용과 같은 레이아웃에 반영되어 스크롤이 당겨지지 않는다.
                collapseTitle(proxy: proxy, animated: false)
            }
        }
    }
}

private extension ZZSCollapsingTitleScrollView {

    /// 맨 위 기준 스크롤 위치(0 = 타이틀이 전부 보임).
    /// 맨 위에서 contentOffset.y는 -상단 인셋이다.
    var offset: CGFloat {
        metrics.contentOffsetY + metrics.insetTop
    }

    /// 타이틀이 완전히 가려지는 스크롤 위치(collapsed 앵커가 맨 위에 올 때)
    var collapsedOffset: CGFloat {
        titleHeight + titleSpacing - 1
    }

    /// 헤더를 맨 위에 붙일 수 있는 내용 최소 높이. 타이틀을 가린 상태에서만 준다.
    ///
    /// 실측상 최대 스크롤 위치(맨 위 기준)는 contentSize - containerSize이고,
    /// contentSize는 타이틀 + 간격 + 헤더 + 섹션 높이다.
    /// 섹션이 containerSize - 헤더 높이 이상이면 최대 스크롤 위치가 타이틀 + 간격이 되어 타이틀을 다 가릴 수 있다.
    /// 섹션 실측 높이를 쓰면 최소 높이와 서로 물려 레이아웃이 끝없이 반복되므로 고정값만 쓴다.
    var contentMinHeight: CGFloat {
        guard keepsTitleCollapsed else { return 0 }
        return max(metrics.containerHeight - headerHeight, 0)
    }

    /// 스크롤이 멈췄을 때 타이틀이 걸쳐 있으면 가까운 쪽으로 맞춘다.
    func snapTitle(proxy: ScrollViewProxy) {
        guard !isSettling else { return }
        let offset = offset
        guard offset > 0.5, offset < collapsedOffset - 0.5 else { return }

        if offset >= collapsedOffset / 2 {
            collapseTitle(proxy: proxy, animated: true)
        } else {
            isSettling = true
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(ScrollAnchor.expanded, anchor: .top)
            }
            finishSettling(after: 0.35)
        }
    }

    /// 타이틀을 완전히 가린다. 내용이 짧아도 최소 높이로 올라갈 공간을 만든다.
    func collapseTitle(proxy: ScrollViewProxy, animated: Bool) {
        isSettling = true
        keepsTitleCollapsed = true

        // 최소 높이가 레이아웃에 반영된 뒤에 스크롤한다.
        DispatchQueue.main.async {
            if animated {
                withAnimation(.easeOut(duration: 0.25)) {
                    proxy.scrollTo(ScrollAnchor.collapsed, anchor: .top)
                }
            } else {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    proxy.scrollTo(ScrollAnchor.collapsed, anchor: .top)
                }
            }
            finishSettling(after: animated ? 0.35 : 0.1)
        }
    }

    func finishSettling(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            isSettling = false
        }
    }
}

/// 스크롤 위치 계산에 쓰는 ScrollGeometry 값
private struct ScrollMetrics: Equatable {
    var contentOffsetY: CGFloat = 0
    var containerHeight: CGFloat = 0
    var insetTop: CGFloat = 0

    init() {}

    init(geometry: ScrollGeometry) {
        contentOffsetY = geometry.contentOffset.y
        containerHeight = geometry.containerSize.height
        insetTop = geometry.contentInsets.top
    }
}
