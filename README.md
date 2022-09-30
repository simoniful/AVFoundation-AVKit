# AVFoundation
iOS AVFoundation / AVKit 기반의 미디어 파일 핸들링

## Description
+ WWDC - What's new in AVKit
+ WWDC - What’s new in AVFoundation
+ WWDC - Delivering Intuitive Media Playback with AVKit
+ Raywenderich 실습 - AVFoundation을 통한 Video 플레이어, 스트리밍 실습
+ 주희하다 Blog 해설 기반 실습

## Getting Start
> AVFoundation, AVKit, SwiftUI

## Issue
### 1. AVCaptureDeviceInput을 통한 디바이스의 접근과 제어 + 비디오 파일 병합

Camera 프로젝트를 구성해보면서 preview, 촬영 및 전후방 카메라 전환, 플래쉬 모드를 설정하며 디바이스의 기능 전환에 대한 접근을 위해 AVKit에서 제공하는 기능을 구현해보았습니다. 간단한 설정과 delegate 연결을 통한 데이터 output을 받고 PhotosUI를 사용하여 PHPhotoLibrary에 접근하여 저장하는 과정에서 다양한 settings 과정과 설정가능한 옵션들이 있었습니다.

현재 기본으로 제공되는 카메라 어플이 굉장히 섬세하게 만들어졌기에, 실제 서비스하는 어플에서 커스텀한 기능을 넣기위한 여러 부분을 고민해보아야 합니다. 만약 카메라로 촬영한 데이터를 넘겨받고 다시 전송하는 경우, 데이터 주입과 관련하여 화면 전환 시 적절한 방식으로 구성하는 wireFrame과 카메라 접근과 관련된 auth 등 체크리스트를 작성하는게 좋을 거 같습니다.

그리고, 추가적으로 병합과 관련하여 portrait와 landscape의 차이로 인해서 영상 구성이 망가지는 걸 방지하기 위한 리사이징과 백그라운드 재생을 위한 작업 등 단순하게 웹 뷰에서 제공되는 플레이어와는 다르게 네이티브한 플레이어를 구성하는 부분에서 고려해야할 점이 많았습니다. 리사이징 하는 부분에서 scale 조정과 병합된 URL path를 구성하면서 길어지는 코드로 인해서 어려움이 있었습니다. 실제로 작성할 때는 주석이 반드시 필요할 거 같네요.

## KeyNote
[<img src = "" width = 400>]()

## References
+ [주희하다 블로그](https://caution-dev.github.io/tag/#AVKit)
+ [애플 공식문서](https://developer.apple.com/documentation/technologies?input=av)
