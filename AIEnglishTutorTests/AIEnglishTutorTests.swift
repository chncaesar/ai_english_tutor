import XCTest
@testable import AIEnglishTutor

@MainActor
final class AIEnglishTutorTests: XCTestCase {
    func testInitialRouteRequiresLoginWhenLoggedOut() {
        let model = AppModel(isLoggedIn: false)
        XCTAssertEqual(model.route, .firstUseLogin)
    }

    func testInitialRouteShowsMainWhenLoggedIn() {
        let model = AppModel(isLoggedIn: true)
        XCTAssertEqual(model.route, .mainVoiceChat)
    }

    func testLogoutResetsVoiceState() async {
        let model = AppModel(isLoggedIn: true)
        model.voiceState = .listening
        await model.markLoggedOut()
        XCTAssertEqual(model.route, .firstUseLogin)
        XCTAssertEqual(model.voiceState, .notConnected)
    }

    func testChatGPTSignInShowsChineseBlockerWithoutFakeLogin() async {
        let model = AppModel(isLoggedIn: false)

        await model.signInWithChatGPT()

        XCTAssertFalse(model.isLoggedIn)
        XCTAssertEqual(model.route, .firstUseLogin)
        XCTAssertEqual(
            model.voiceState,
            .error("当前版本尚未完成 ChatGPT Plus/Pro 登录验证，请等待后续版本。")
        )
    }
}
