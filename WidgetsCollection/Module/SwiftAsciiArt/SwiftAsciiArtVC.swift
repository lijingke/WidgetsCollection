//
//  SwiftAsciiArtVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/9.
//

import Foundation
import UIKit

enum ImageProcessingError: Error {
    case couldNotCreatePNGData
}

class SwiftAsciiArtVC: BaseViewController {
    fileprivate let labelFont = UIFont(name: "Menlo", size: 7)!
    fileprivate let maxImageSize = CGSize(width: 310, height: 310)
    fileprivate lazy var palette: AsciiPalette = .init(font: self.labelFont)
    
    fileprivate var currentLabel: UILabel?
    @IBOutlet var busyView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureZoomSupport()
    }

    override func getNavigatorConfig() -> NavigatorConfig? {
        return NavigatorConfig.newConfig().rightBarButton(image: UIImage(systemName: "square.and.arrow.up"), action: #selector(shareAction))
    }

    // MARK: - Rendering
    
    fileprivate func displayImageNamed(_ imageName: String) {
        displayImage(UIImage(named: imageName)!)
    }
    
    fileprivate func displayImage(_ image: UIImage) {
        busyView.isHidden = false
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let // Rotate first because the orientation is lost when resizing.
                rotatedImage = image.imageRotatedToPortraitOrientation(),
                resizedImage = rotatedImage.imageConstrainedToMaxSize(self.maxImageSize),
                asciiArtist = AsciiArtist(resizedImage, self.palette),
                asciiArt = asciiArtist.createAsciiArt()
            
            DispatchQueue.main.async {
                self.displayAsciiArt(asciiArt)
                self.busyView.isHidden = true
            }
            Log.info(asciiArt)
        }
    }
    
    fileprivate func displayAsciiArt(_ asciiArt: String) {
        let label = UILabel()
        label.font = labelFont
        label.lineBreakMode = NSLineBreakMode.byClipping
        label.numberOfLines = 0
        label.text = asciiArt
        label.sizeToFit()
        label.backgroundColor = .white
        
        currentLabel?.removeFromSuperview()
        currentLabel = label
        
        scrollView.addSubview(label)
        scrollView.contentSize = label.frame.size
        
        updateZoomSettings(animated: false)
        scrollView.contentOffset = CGPoint.zero
    }
    
    // MARK: - Zooming support
    
    fileprivate func configureZoomSupport() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
    }
    
    fileprivate func updateZoomSettings(animated: Bool) {
        let
            scrollSize = scrollView.frame.size,
            contentSize = scrollView.contentSize,
            scaleWidth = scrollSize.width / contentSize.width,
            scaleHeight = scrollSize.height / contentSize.height,
            scale = max(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = scale
        scrollView.setZoomScale(scale, animated: animated)
    }
}

// MARK: - Event

extension SwiftAsciiArtVC {
    @objc func shareAction() {
        if let view = currentLabel {
            let image = convertViewToImage(view: view)
            try? exportImageAsPNG(image, filename: "Preview")
        } else {
            Loading.showToastHint(with: "请选择一张图片", to: self.view)
        }
    }
    
    func convertViewToImage(view: UIView) -> UIImage {
        Loading.showLoading(to: self.view)
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        Loading.hideLoading(from: self.view)
        return image
    }

    private func exportImageAsPNG(_ image: UIImage, filename: String) throws {
        guard let pngData = image.pngData() else { throw ImageProcessingError.couldNotCreatePNGData }
        let temporaryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(filename)
            .appendingPathExtension("png")
        try pngData.write(to: temporaryURL, options: [])
        // present UIActivityViewController with the temporaryURL
        let vc = VisualActivityViewController(url: temporaryURL)
        presentActionSheet(vc, from: view)
    }
    
    private func presentActionSheet(_ vc: VisualActivityViewController, from view: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.bounds
            vc.popoverPresentationController?.permittedArrowDirections = [.right, .left]
        }
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Event

extension SwiftAsciiArtVC {
    @IBAction func handleKermitTapped(_ sender: AnyObject) {
        displayImageNamed("kermit")
    }
    
    @IBAction func handleBatmanTapped(_ sender: AnyObject) {
        displayImageNamed("batman")
    }
    
    @IBAction func handleMonkeyTapped(_ sender: AnyObject) {
        displayImageNamed("monkey")
    }
    
    @IBAction func handlePickImageTapped(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        show(imagePicker, sender: self)
    }
}

// MARK: - UINavigationControllerDelegate

extension SwiftAsciiArtVC: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate

extension SwiftAsciiArtVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            displayImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension SwiftAsciiArtVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return currentLabel
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
