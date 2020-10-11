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

    func testCodeBlock() {
        XCTAssertEqual(
            markdown2Jira(
                """
                ```swift
                func f() {}
                ```
                """
            ),
            """
            {code:swift}
            func f() {}
            {code}
            """
        )
    }

    func testBlockQuote() {
        XCTAssertEqual(
            markdown2Jira(
                """
                > hello
                > world
                """
            ),
            """
            {quote}
            hello
            world
            {quote}
            """
        )
    }

    func testHeader() {
        XCTAssertEqual(
            markdown2Jira(
                """
                # one
                ## two
                ### three
                #### four
                """
            ),
            """
            h1. one

            h2. two

            h3. three

            h4. four
            """
        )
    }

    func testOrderedList() {
        XCTAssertEqual(
            markdown2Jira(
                """
                1. one
                2. two
                3. three
                """
            ),
            """
            # one
            # two
            # three
            """
        )
    }

    func testUnorderedList() {
        XCTAssertEqual(
            markdown2Jira(
                """
                * one
                * two
                * three
                """
            ),
            """
            * one
            * two
            * three
            """
        )
    }

    func testNestedLists() {
        XCTAssertEqual(
            markdown2Jira(
                """
                * one
                * two
                  1. three
                  2. four
                * five
                """
            ),
            """
            * one
            * two
            *# three
            *# four
            * five
            """
        )
    }
}
