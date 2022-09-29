///// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var flashMode: AVCaptureDevice.FlashMode = .auto
    var cameraView = CameraView()
    
    var body: some View {
        VStack {
            ZStack {
                cameraView
                VStack {
                    HStack {
                        Button {
                            switch flashMode {
                            case .off:
                                flashMode = .on
                            case .on:
                                flashMode = .auto
                            case .auto:
                                flashMode = .off
                            @unknown default:
                                flashMode = .auto
                            }
                        } label: {
                            HStack {
                                Image(systemName: (flashMode == .auto || flashMode == .on) ? "bolt" : "bolt.slash")
                                    .foregroundColor(.white)
                                Text(flashMode.description)
                                    .foregroundColor(.white)
                            }.padding()
                        }
                        Spacer()
                        Button {
                            cameraView.switchCamera()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .padding()
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            cameraView.takePhoto(flashMode: flashMode)
                        } label: {
                            Image(systemName: "record.circle")
                                .font(.system(size: 44.0))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension AVCaptureDevice.FlashMode {
    var description: String {
        switch self {
        case .off:
            return "Off"
        case .on:
            return "On"
        case .auto:
            return "Auto"
        @unknown default:
            return "Unknown"
        }
    }
}
