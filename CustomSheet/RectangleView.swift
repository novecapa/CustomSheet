//
//  RectangleView.swift
//  CustomSheet
//
//  Created by Josep Cerdá Penadés on 29/4/24.
//

import SwiftUI

struct RectangleView: View {
    let color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(color)
                .frame(maxWidth: .infinity)
            Text("Custom Sheet")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
