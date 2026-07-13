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

    func testLogoutResetsVoiceState() {
        let model = AppModel(isLoggedIn: true)
        model.voiceState = .listening
        model.markLoggedOut()
        XCTAssertEqual(model.route, .firstUseLogin)
        XCTAssertEqual(model.voiceState, .notConnected)
    }
}
