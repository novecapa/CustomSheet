//
//  ImageRowView.swift
//  CustomSheet
//
//  Created by Josep Cerdá Penadés on 29/4/24.
//

import SwiftUI

struct ImageRowView: View {

    enum Constants {
        static let baseURL: String = "https://rickandmortyapi.com/api/character/avatar/"
        static let imageExt: String = ".jpeg"
        static let cornerRadius: CGFloat = 12
    }
    
    let id: Int
    let frameSize: CGFloat
    
    var body: some View {
        VStack {
            AsyncImage(
                url: URL(string: "\(Constants.baseURL)\(id)\(Constants.imageExt)"),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: frameSize,
                               height: frameSize)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                },
                placeholder: {
                    ProgressView()
                }
            )
            Spacer()
        }
    }
}

#Preview {
    ImageRowView(id: 1, frameSize: 300)
}
