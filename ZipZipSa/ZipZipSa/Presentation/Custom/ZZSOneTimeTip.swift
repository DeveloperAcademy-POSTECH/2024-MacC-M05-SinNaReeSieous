//
//  ZZSOneTimeTip.swift
//  ZipZipSa
//

import SwiftUI

/// 새 기능을 알려주는 말풍선. 집 요약 카드의 주변 시설 이름 말풍선과 같은 모양에,
/// 무엇을 가리키는지 알 수 있도록 위쪽에 작은 꼬리를 단다.
struct ZZSTipBubble: View {
    /// 꼬리 높이 + caption1Regular 줄 높이(14) + 위아래 여백(5 + 5)
    static let height: CGFloat = arrowSize.height + 24
    static let arrowSize = CGSize(width: 12, height: 6)
    private static let fill = Color.black.opacity(0.7)

    let text: String
    /// 말풍선 오른쪽 끝에서 꼬리 중심까지의 거리
    let arrowInsetFromTrailing: CGFloat

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Triangle()
                .fill(Self.fill)
                .frame(width: Self.arrowSize.width, height: Self.arrowSize.height)
                .padding(.trailing, arrowInsetFromTrailing - Self.arrowSize.width / 2)
            Text(text)
                .fixedSize()
                .lineLimit(1)
                .foregroundStyle(Color.Text.onColorPrimary)
                .applyZZSFont(zzsFontSet: .caption1Regular)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Self.fill)
                )
        }
        .fixedSize()
    }

    private struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.closeSubpath()
            }
        }
    }
}

/// 처음 한 번만 말풍선을 띄운다. 띄운 순간 본 것으로 기록해 다시 뜨지 않는다.
/// 6초 뒤 저절로 사라지고, 말풍선을 탭해도 닫힌다.
private struct ZZSOneTimeTipModifier: ViewModifier {
    static let appearDelay: TimeInterval = 0.6
    static let visibleDuration: TimeInterval = 6

    @AppStorage private var didShow: Bool
    @State private var isShowing = false
    /// 대상 뷰의 실제 너비. 꼬리를 대상 가운데에 맞출 때 쓴다.
    @State private var anchorWidth: CGFloat = 0

    let text: String
    let isEnabled: Bool
    let alignment: Alignment
    let offset: CGSize
    let arrowInset: ArrowInset

    enum ArrowInset {
        /// 말풍선 오른쪽 끝에서 고정 거리
        case fixed(CGFloat)
        /// 대상 뷰의 가로 가운데 (말풍선 오른쪽 끝이 대상 오른쪽 끝에서 overhang만큼 나가 있을 때)
        case anchorCenter(overhang: CGFloat)
    }

    init(
        key: String,
        text: String,
        isEnabled: Bool,
        alignment: Alignment,
        offset: CGSize,
        arrowInset: ArrowInset
    ) {
        self._didShow = AppStorage(wrappedValue: false, key)
        self.text = text
        self.isEnabled = isEnabled
        self.alignment = alignment
        self.offset = offset
        self.arrowInset = arrowInset
    }

    private var arrowInsetFromTrailing: CGFloat {
        switch arrowInset {
        case .fixed(let inset): inset
        case .anchorCenter(let overhang): overhang + anchorWidth / 2
        }
    }

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { anchorWidth = $0 }
            .overlay(alignment: alignment) {
                if isShowing {
                    ZZSTipBubble(text: text, arrowInsetFromTrailing: arrowInsetFromTrailing)
                        .offset(offset)
                        .onTapGesture { hide() }
                        .transition(.opacity)
                }
            }
            .onAppear {
                guard isEnabled, !didShow else { return }
                didShow = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.appearDelay) {
                    withAnimation { isShowing = true }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.appearDelay + Self.visibleDuration) {
                    hide()
                }
            }
    }

    private func hide() {
        withAnimation { isShowing = false }
    }
}

extension View {
    /// 처음 한 번만 뜨는 안내 말풍선을 이 뷰(아이콘) 바로 아래에 띄운다.
    /// 꼬리는 이 뷰의 가로 가운데를 가리키고, 말풍선 오른쪽 끝은 이 뷰 오른쪽 끝에서 trailingOverhang만큼 더 나간다.
    func zzsOneTimeTipBelow(
        key: String,
        text: String,
        isEnabled: Bool = true,
        trailingOverhang: CGFloat = 0,
        spacing: CGFloat = 4
    ) -> some View {
        modifier(ZZSOneTimeTipModifier(
            key: key,
            text: text,
            isEnabled: isEnabled,
            alignment: .bottomTrailing,
            offset: CGSize(width: trailingOverhang, height: ZZSTipBubble.height + spacing),
            arrowInset: .anchorCenter(overhang: trailingOverhang)
        ))
    }

    /// 처음 한 번만 뜨는 안내 말풍선을 이 뷰의 오른쪽 위 안쪽에 띄운다.
    /// 툴바 버튼처럼 이 뷰 밖에 있는 대상을 가리킬 때 쓴다.
    func zzsOneTimeTipTopTrailing(
        key: String,
        text: String,
        isEnabled: Bool = true,
        top: CGFloat,
        trailing: CGFloat,
        arrowInsetFromTrailing: CGFloat
    ) -> some View {
        modifier(ZZSOneTimeTipModifier(
            key: key,
            text: text,
            isEnabled: isEnabled,
            alignment: .topTrailing,
            offset: CGSize(width: -trailing, height: top),
            arrowInset: .fixed(arrowInsetFromTrailing)
        ))
    }
}
