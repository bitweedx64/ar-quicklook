//
//  ContentView.swift
//  ar-quicklook
//
//  Created by Shay Zhang on 2021/9/21.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}

struct ContentView: View {
    // State used to toggle showing our sheet containing AR QL preview
    @State var showingPreview = false
    
    // Turns off & on the ability to change the preview size within ARKit.
    @State var allowsScaling = false
    @State var url = ""
    @State var working = false
    @State var location = URL(string: "https://abnernat-usdz.s3.ap-southeast-1.amazonaws.com/DownloadedScene.usdz")
    
    var body: some View {
        VStack {
            TextField("https://yourmodelurl.com/...", text: $url)
                .border(Color.orange, width: 1)
                .cornerRadius(3.0)
                .padding(3.0)
            ProgressView()
                .isHidden(!working)
            Button("Show Preview") {
                // Action that runs when the button is tapped.
                // This one toggles the showing-preview state.
                
                working = true
                let downloadTask = URLSession.shared.downloadTask(with: URL(string: url)!) {
                    urlOrNil, responseOrNil, errorOrNil in
                    // check for and handle errors:
                    // * errorOrNil should be nil
                    // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299
                    
                    guard let fileURL = urlOrNil else { return }
                    do {
                        let documentsURL = try
                            FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
                        let savedURL = documentsURL.appendingPathComponent("DownloadedScene.usdz")
                        try FileManager.default.moveItem(at: fileURL, to: savedURL)
                        self.showingPreview.toggle()
                        location = savedURL
                        print(savedURL)
                        working = false
                    } catch {
                        print ("file error: \(error)")
                    }
                }
                downloadTask.resume()
            }
            .disabled(working)
            // This modifier tells SwiftUI to present a view in a modal sheet
            // when a state variable is set to true, and to dismiss it
            // when set to false.
            .sheet(isPresented: $showingPreview) {
                // Sheet content: the quick look view with a header bar containing
                // a simple 'close' button that closes the sheet.
                VStack {
                    // Top row: button, aligned left
                    HStack {
                        Button("Close") {
                            // Toggle the preview display off again.
                            // Swiping down (the system gesture to dismiss a sheet)
                            // will cause SwiftUI to toggle our state property as well.
                            self.showingPreview.toggle()
                        }
                        // The spacer fills the space following the button, in effect
                        // pushing the button to the leading edge of the view.
                        Spacer()
                    }
                    .padding()
                    
                    // Quick-look view goes here
                    ARQuickLookView(name: "DownloadedScene", allowScaling: self.allowsScaling)
                }
            }
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
