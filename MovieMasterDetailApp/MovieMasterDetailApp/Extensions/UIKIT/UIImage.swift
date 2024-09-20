//
//  UIImage.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import UIKit

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0

    private var savedTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var savedUrl: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        // cancel prior task, if any

        weak var oldTask = savedTask
        savedTask = nil
        oldTask?.cancel()

        // reset image view’s image

        self.image = placeholder

        // allow supplying of `nil` to remove old image and then return immediately

        guard let url else { return }

        // check cache

        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        // download

        savedUrl = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.savedTask = nil

            // error handling

            if let error {
                // don't bother reporting cancelation errors

                if (error as? URLError)?.code == .cancelled {
                    return
                }

                print(error)
                return
            }

            guard let data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: url.absoluteString)

            if url == self?.savedUrl {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }

        // save and start new task

        savedTask = task
        task.resume()
    }
}
