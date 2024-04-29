//
//  ContentView.swift
//  CustomSheet
//
//  Created by Josep Cerdá Penadés on 29/4/24.
//

import SwiftUI

struct ContentView: View {

    enum Constants {
        // Rectangle
        static let rectBackColor: Color = .blue
        static let rectangleHeight: CGFloat = 30
        static let roundRectCornerRadius: CGFloat = 10
        static let roundRectWidth: CGFloat = 60
        static let roundRectHeight: CGFloat = 6
        // Top view values
        static let topWidthAdjust: CGFloat = 60
        // Bottom view values
        static let animationHeight: CGFloat = 40
        static let animationTime: CGFloat = 0.5
        static let adjustMin: CGFloat = 180
        static let adjustMax: CGFloat = 320
    }

    private let imageListId: [Int] = [1, 2, 3, 4, 5, 6, 7]

    @State private var topViewHeight: CGFloat = 0
    @State private var bottomViewHeight: CGFloat = 0
    @State private var totalAvailableHeight: CGFloat = 0
    @State private var minViewHeight: CGFloat = 400

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: .zero) {
                RectangleView(color: Constants.rectBackColor)
                    .frame(height: topViewHeight)
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .frame(height: Constants.rectangleHeight)
                    RoundedRectangle(cornerRadius: Constants.roundRectCornerRadius)
                        .frame(width: Constants.roundRectWidth,
                               height: Constants.roundRectHeight)
                }
                .gesture(DragGesture()
                    .onChanged({ value in
                        let speedOrDragAmount = value.translation.height
                        guard bottomViewHeight <= proxy.size.width + Constants.topWidthAdjust else {
                            return
                        }
                        topViewHeight += speedOrDragAmount
                        bottomViewHeight -= speedOrDragAmount
                    }).onEnded({ value in
                        if bottomViewHeight > Constants.adjustMin ||
                            bottomViewHeight > Constants.adjustMax {
                            withAnimation {
                                setupBottomMinHeight()
                                topViewHeight = totalAvailableHeight - bottomViewHeight
                            }
                        } else if bottomViewHeight < minViewHeight {
                            withAnimation {
                                bottomViewHeight = Constants.animationHeight
                                topViewHeight = totalAvailableHeight - bottomViewHeight
                            }
                        } else if topViewHeight < minViewHeight {
                            withAnimation {
                                setupBottomMinHeight()
                                topViewHeight = totalAvailableHeight - bottomViewHeight
                            }
                        } else if bottomViewHeight > totalAvailableHeight - minViewHeight {
                            withAnimation {
                                bottomViewHeight = totalAvailableHeight - minViewHeight
                                topViewHeight = minViewHeight
                            }
                        } else if topViewHeight > totalAvailableHeight - minViewHeight {
                            withAnimation {
                                topViewHeight = totalAvailableHeight - minViewHeight
                                setupBottomMinHeight()
                            }
                        }
                    })
                )
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(imageListId, id: \.self) { id in
                            ImageRowView(id: id, frameSize: proxy.size.width)
                        }
                        
                    }
                    .frame(height: bottomViewHeight)
                }
            }
            .onAppear() {
                totalAvailableHeight = proxy.size.height
                bottomViewHeight = Constants.animationHeight
                minViewHeight = proxy.size.width + bottomViewHeight
                topViewHeight = totalAvailableHeight - bottomViewHeight
                startAnimation()
            }
        }
        .ignoresSafeArea()
    }

    private func setupBottomMinHeight() {
        bottomViewHeight = minViewHeight
    }

    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationTime) {
            withAnimation {
                bottomViewHeight += Constants.animationHeight
                topViewHeight = totalAvailableHeight - bottomViewHeight
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationTime) {
                    withAnimation {
                        bottomViewHeight -= Constants.animationHeight
                        topViewHeight = totalAvailableHeight - bottomViewHeight
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
