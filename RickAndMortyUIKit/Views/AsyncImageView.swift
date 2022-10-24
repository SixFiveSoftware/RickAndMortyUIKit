//
//  AsyncImageView.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/21/22.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) async {
        image = nil
        let fetcher = ThumbnailImageActor()
        if let img = try? await fetcher.fetch(url) {
            await MainActor.run {
                image = img
            }
        }
    }
}
