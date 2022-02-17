//
//  AddImageCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 01/02/22.
//

import UIKit
import AVKit
import AVFoundation

class AddReviewImageCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddReviewImagecollectcellid"
    
    weak var delegate: AddReviewImageDelegate?
    
    var isEnabled: Bool = true {
        willSet {
            closeButton.isHidden = !newValue
        }
    }
    
    let videoPlayer: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.modalTransitionStyle = .crossDissolve
        playerController.modalPresentationStyle = .currentContext
        return playerController
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor(named: "text_color")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.fill")
        return imageView
    }()
    
    let videoView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(named: "text_color")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: UIImage(systemName: "play.circle.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.white))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.tintColor = .white
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.setContentMode(mode: .scaleAspectFit)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var media: ApplicationDB.ReviewMedia? {
        willSet {
            if newValue != nil {
                switch newValue!.type {
                case .video:
                    videoPlayer.delegate = self
                    videoPlayer.player = AVPlayer(url: newValue!.mediaUrl)
                    let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: newValue!.mediaUrl))
                    let time = CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                    do {
                        let image = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                        videoView.image = UIImage(cgImage: image).resized(toWidth: min(self.contentView.frame.height, self.contentView.frame.width))
                        imageView.isHidden = true
                        videoView.isHidden = false
                    }
                    catch {
                        print(error)
                    }
                case .image:
                    imageView.isHidden = false
                    videoView.isHidden = true
                    imageView.image = UIImage(contentsOfFile: newValue!.mediaUrl.path)?.resized(toWidth: min(self.contentView.frame.height, self.contentView.frame.width))
                }
            }
            self.setupLayout()
        }
    }
    
    var indexPath: IndexPath!
    
    func setupLayout() {
        
        videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlay)))
        closeButton.addTarget(self, action: #selector(onDeleteClick), for: .touchUpInside)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageClick)))
        contentView.addSubview(imageView)
        contentView.addSubview(videoView)
        contentView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            videoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            videoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            videoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            videoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            closeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            
        ])
    }
    
    @objc
    func onImageClick() {
        let imageSlideShow = ImageSlideShow()
        if let media = media {
            imageSlideShow.image = UIImage(contentsOfFile: media.mediaUrl.path)
        } else {
            imageSlideShow.image = UIImage(systemName: "photo.fill")
        }
        self.parentViewController?.present(imageSlideShow, animated: true)
    }
    
    @objc
    func onPlay() {
        self.parentViewController?.present(videoPlayer, animated: true, completion: nil)
    }
    
    @objc
    func onDeleteClick() {
        delegate?.deleteImage(at: indexPath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        imageView.image = UIImage(systemName: "photo.fill")
    }
    
}

extension AddReviewImageCollectionViewCell: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        playerViewController.player?.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        playerViewController.player?.play()
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        playerViewController.player?.pause()
    }
}

protocol AddReviewImageDelegate: AnyObject {
    func deleteImage(at index: IndexPath)
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
