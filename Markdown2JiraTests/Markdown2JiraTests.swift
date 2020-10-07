import XCTest
@testable import Markdown2Jira

class Markdown2JiraTests: XCTestCase {
    func testPlaintext() {
        XCTAssertEqual(
            markdown2Jira("Hello"),
            "Hello"
        )
    }


    func testEmphasize() {
        XCTAssertEqual(
            markdown2Jira("*Hello*"),
            "_Hello_"
        )
    }

    func testStrong() {
        XCTAssertEqual(
            markdown2Jira("**Hello**"),
            "*Hello*"
        )
    }

    func testCode() {
        XCTAssertEqual(
            markdown2Jira("`Hello`"),
            "{{Hello}}"
        )
    }
}
