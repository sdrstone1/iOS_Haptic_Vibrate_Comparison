# Vibrate Tester

- iOS에서 진동 관련 API 사용을 테스트하기 위한 샘플 앱
- CoreHaptics, UIImpactFeedbackGenerator, AudioServicesPlaySystemSoundWithCompletion
을 사용하여 진동 기능을 구현 함.


### CoreHaptics

CoreHaptics는 한 번만 톡 치거나, 연속적으로 작동할 수 있음.
연속적으로 작동할 때는 시간을 반드시 지정해야 함
Intensity와 Sharpness는 0.5가 기본값 

CoreHaptics를 사용하여 UIImpactFeedbackGenerator와 비슷하게 구현하려면
duration은 0.01 정도로 지정해야 함(0.0과는 다름)