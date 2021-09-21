//
//  ARQuickLookView.swift
//  ar-quicklook
//
//  Created by Shay Zhang on 2021/9/21.
//

import SwiftUI
import QuickLook
import ARKit

struct ARQuickLookView: UIViewControllerRepresentable {
    // Properties: the file name (without extension), and whether we'll let
    // the user scale the preview content.
    var url: URL
    var allowScaling: Bool = true
    
    func makeCoordinator() -> ARQuickLookView.Coordinator {
        // The coordinator object implements the mechanics of dealing with
        // the live UIKit view controller.
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        // Create the preview controller, and assign our Coordinator class
        // as its data source.
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ controller: QLPreviewController,
                                context: Context) {
        // nothing to do here
    }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: ARQuickLookView
        private lazy var fileURL: URL = parent.url
        
        init(_ parent: ARQuickLookView) {
            self.parent = parent
            super.init()
        }
        
        // The QLPreviewController asks its delegate how many items it has:
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        // For each item (see method above), the QLPreviewController asks for
        // a QLPreviewItem instance describing that item:
        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            let fileURL = parent.url
            print(fileURL)
            let item = ARQuickLookPreviewItem(fileAt: fileURL)
            item.canonicalWebPageURL = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/drummertoy/")
            item.allowsContentScaling = parent.allowScaling
            return item
        }
    }
}

struct ARQuickLookView_Previews: PreviewProvider {
    static var previews: some View {
        ARQuickLookView(url: URL(string: "https://abnernat-usdz.s3.ap-southeast-1.amazonaws.com/DownloadedScene.usdz")!)
    }
}

