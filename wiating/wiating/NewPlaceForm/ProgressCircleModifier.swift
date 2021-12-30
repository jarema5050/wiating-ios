//
//  ProgressCircleModifier.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 28/12/2021.
//

import SwiftUI

struct ProgressCircleModifier: View {
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var progress: Float = 0
    
    var body: some View {
        ZStack {
            Color.clear
            ProgressView(value: progress, total: Float(10.0))
                .progressViewStyle(GaugeProgressStyle())
                .frame(width: 45, height: 45)
                .contentShape(Rectangle())
                .onReceive(timer) { _ in
                    if progress < 10 { progress += 1 } else { progress = 0 }
                }
        }
        .background(BackgroundBlurView())
    }
}

struct ProgressCircleModifier_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircleModifier()
    }
}


struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ProgressModifier: ViewModifier {
    @Binding var isVisible: Bool
    
    func body(content: Content) -> some View {
        content.fullScreenCover(isPresented: $isVisible) { ProgressCircleModifier() }
    }
}

extension View {
    func progressCover(isPresented: Binding<Bool>) -> some View {
        modifier(ProgressModifier(isVisible: isPresented))
    }
}

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color("launch_color")
    var strokeWidth = 4.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(fractionCompleted))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: CGLineCap.square))
                .rotationEffect(.degrees(-90))
        }
    }
}

