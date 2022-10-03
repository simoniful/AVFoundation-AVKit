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

### 2. 스트리밍 구성

로컬과 서버를 통한 미디어 불러오기 등 모든 데이터를 구성하여 네이티브 환경에서 재생 가능하도록 구성하면서 embedded 한 플레이어와 팝업 뷰 플레이어로 별도로 구분하였습니다. 간단하게 생각하면 URL만 플레이어 쪽에 제대로 전달하면 플레이어에서 재생되는 원리입니다. 이를 단일 미디어만 구성할지, 아니면 Queue를 통해 연속적인 재생을 구성할지 결정할 수 있었고, 개발하는 측면에서 웹 뷰와 비교했을 때 사용자 측면에서 어떤점이 더 익숙할지 고민을 많이 해보아야 한다고 생각합니다.

또한, 백그라운드에서 다른 앱과 함께 사용할 수 있는 서브 윈도우 형식의 PIP를 구성하는 점에서 기존의 VideoPlayer라는 default로 지원하는 플레이어의 한계점과 새롭게 지원하는 부분에서 AVPlayerViewController를 통한 확장된 기능 구현의 측면에서 편의성이 달랐습니다. 때문에 아직까지 더 변화할 부분이 많은 측면에서 항상 AVKit과 AVFoundation의 기능 추가에 대한 WWDC를 주목하고 있어야할 거 같습니다.

예제를 모두 SwiftUI로 구성하면서 선언형일 때 보다 간결해진 코드를 알 수 있어 가독성은 높았지만, UIKit으로 별도로 구성 예정입니다. 물론 Reactive하게 구성하는 데에서 제약이 많이 있을 거라 예상됩니다.

## KeyNote
[<img src = "" width = 400>]()

## References
+ [주희하다 블로그](https://caution-dev.github.io/tag/#AVKit)
+ [애플 공식문서](https://developer.apple.com/documentation/technologies?input=av)
