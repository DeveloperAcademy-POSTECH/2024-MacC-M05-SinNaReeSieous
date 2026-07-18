//
//  ChecklistTemplatePresetSelectView.swift
//  ZipZipSa
//

import SwiftUI

/// 체크리스트 생성 플로우 루트: 템플릿 선택 → 편집.
/// 편집 화면의 이름 입력 푸시(navigationDestination(isPresented:))는 중첩 푸시에서
/// 무한 렌더 루프를 일으키므로, 각 단계를 자기 NavigationStack의 루트로 두고 전환한다.
struct ChecklistTemplateCreateFlowView: View {
    /// 생성 플로우(fullScreenCover) 전체를 닫는다.
    let onClose: () -> Void

    @State private var selectedPreset: ChecklistTemplatePreset?

    var body: some View {
        if let preset = selectedPreset {
            NavigationStack {
                ChecklistTemplateEditView(
                    template: nil,
                    initialCodes: preset.questionCodes,
                    onClose: onClose
                )
            }
        } else {
            NavigationStack {
                ChecklistTemplatePresetSelectView(
                    onSelect: { selectedPreset = $0 },
                    onClose: onClose
                )
            }
        }
    }
}

/// 체크리스트 생성 첫 단계 — 질문 템플릿 선택 화면.
/// 프리셋(기본/자세히보기/빠르게보기/직접 추가하기)을 고르면
/// 해당 질문 세트로 채워진 편집 화면으로 넘어간다.
struct ChecklistTemplatePresetSelectView: View {
    let onSelect: (ChecklistTemplatePreset) -> Void
    /// 생성 플로우(fullScreenCover) 전체를 닫는다.
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Title
                    PresetCardList
                }
            }
            .scrollIndicators(.never)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton
            }
        }
    }
}

private extension ChecklistTemplatePresetSelectView {

    var BackButton: some View {
        Button {
            onClose()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .applyZZSFont(zzsFontSet: .iconTitle1)
                Text(ZipLiteral.ChecklistTemplate.back)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Button.tertiary)
        }
    }

    var Title: some View {
        Text(ZipLiteral.ChecklistTemplate.presetSelectTitle)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }

    var PresetCardList: some View {
        VStack(spacing: 10) {
            ForEach(ChecklistTemplatePreset.allCases) { preset in
                Button {
                    onSelect(preset)
                } label: {
                    PresetCardLabel(preset: preset)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    func PresetCardLabel(preset: ChecklistTemplatePreset) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(preset.name)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .title2)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(minHeight: 48, alignment: .top)
            Text("\(preset.questionCount)\(ZipLiteral.ChecklistTemplate.questionCountSuffix)")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .caption1Regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.Button.secondaryYellow)
        }
    }
}

#Preview {
    ChecklistTemplateCreateFlowView(onClose: {})
}
