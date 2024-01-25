//
//  ContentView.swift
//  demo project
//
//  Created by Conan Chou on 1/25/24.
//

import SwiftUI
import AppKit
import QuickLookUI


struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                if let path = Bundle.main.path(forResource: "quote", ofType: "png") {
                    let url = URL(fileURLWithPath: path)
                    print(url)
                    let panelController = QuotesQLViewController()
                    panelController.previewFile(self, url: url)
                } else {
                    print("not found")
                }
            } label: {
                Text("click me")
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}

class QuotesQLViewController: NSViewController, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    var url: URL!
    
    @objc func previewFile(_ sender: Any, url: URL) {
        self.url = url
        if let panel = QLPreviewPanel.shared() {
            panel.dataSource = self
            panel.delegate = self
            panel.makeKeyAndOrderFront(nil)
        }
        
    }
    
    @objc func copyToClipboard() {
        // read the image data from the url into memory
        guard let image = NSImage(contentsOf: self.url) else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
    }
    
    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        return true
    }

    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = self
        panel.delegate = self
    }

    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = nil
        panel.delegate = nil
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return 1
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return self.url as QLPreviewItem
    }
}
