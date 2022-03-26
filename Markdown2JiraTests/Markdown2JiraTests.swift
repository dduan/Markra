import Markdown2Jira
import XCTest

class Markdown2JiraTests: XCTestCase {
    func testPlaintext() {
        XCTAssertEqual(
            markdown2Jira("Hello"),
            "Hello\n"
        )
    }

    func testEmphasize() {
        XCTAssertEqual(
            markdown2Jira("*Hello*"),
            "_Hello_\n"
        )
    }

    func testStrikeThrough() {
        XCTAssertEqual(
            markdown2Jira("~Hello~"),
            "-Hello-\n"
        )
    }

    func testStrong() {
        XCTAssertEqual(
            markdown2Jira("**Hello**"),
            "*Hello*\n"
        )
    }

    func testCode() {
        XCTAssertEqual(
            markdown2Jira("`Hello`"),
            "{{Hello}}\n"
        )
    }

    func testImageWithAltTextAndTitle() {
        XCTAssertEqual(
            markdown2Jira(#"![foo *bar*](/url "title")"#),
            #"!/url|,alt="foo bar",title="title"!"# + "\n"
        )
    }

    func testImageWithAltText() {
        XCTAssertEqual(
            markdown2Jira(#"![foo *bar*](/url)"#),
            #"!/url|,alt="foo bar"!"# + "\n"
        )
    }

    func testImageWithTitle() {
        XCTAssertEqual(
            markdown2Jira(#"![](/url "title")"#),
            #"!/url|,title="title"!"# + "\n"
        )
    }

    func testImage() {
        XCTAssertEqual(
            markdown2Jira(#"![](/url)"#),
            #"!/url!"# + "\n"
        )
    }

    func testLink() {
        XCTAssertEqual(
            markdown2Jira("[Hello, __world__](https://google.com)"),
            "[Hello, *world*|https://google.com]\n"
        )
    }

    func testLinkWithoutText() {
        XCTAssertEqual(
            markdown2Jira("[](https://google.com)"),
            "[https://google.com]\n"
        )
    }

    func testAutoLink() {
        XCTAssertEqual(
            markdown2Jira("<https://google.com>"),
            "[https://google.com]\n"
        )
    }

    func testCodeBlock() {
        XCTAssertEqual(
            markdown2Jira(
                """
                ```swift
                func f() {
                    print("hello")
                }
                ```
                """
            ),
            """
            {code:swift}
            func f() {
                print("hello")
            }
            {code}
            """
        )
    }

    func testBlockQuote() {
        XCTAssertEqual(
            markdown2Jira(
                """
                > hello _world_
                > you are welcome
                >
                > __paragraph__
                """
            ),
            """
            {quote}
            hello _world_
            you are welcome

            *paragraph*
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
