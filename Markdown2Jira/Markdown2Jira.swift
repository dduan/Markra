import Scmark
import Foundation

let kHighlightingLanguages: Set<String> = [
    "java", "actionscript", "ada", "applescript", "bash", "c", "c#", "c++", "css", "erlang", "go", "groovy",
    "haskell", "html", "javascript", "json", "lua", "nyan", "objc", "perl", "php", "python", "r", "ruby",
    "scala", "sql", "swift", "visualbasic", "xml", "yaml"
]

public func markdown2Jira(_ markdown: String) -> String {
    Parser(options: .smart).parse(document: markdown).renderJira()
}

extension Node {
    func renderJira() -> String {
        var stack: [NodeType] = []
        var texts: [String] = []
        var result: [String] = []
        var blockBeginnings: [Int] = []
        var listPrefixes: String = ""

        func consolidate() -> String {
            let result = texts.joined(separator: "")
            texts = []
            return result
        }

        for (event, node) in Tree(root: self) {
            guard let type = node.type() else {
                continue
            }

            switch (event, type) {
            case (.exit, .paragraph):
                result.append(consolidate())
            case (_, .text):
                guard stack.last != .image else {
                    break
                }

                texts.append(node.literal() ?? "")

            case (_, .softBreak):
                texts.append("\n")

            case
                (.enter, .strong),
                (.enter, .emphasize),
                (.enter, .link),
                (.enter, .image):
                stack.append(type)

            case (.enter, .heading):
                stack.append(type)

            case (.enter, .thematicBreak):
                result.append("----")

            case (.enter, .codeBlock):
                let fense = node.fenceInfo()
                let showFense = kHighlightingLanguages.contains(fense.lowercased())
                result.append("{code\(!showFense ? "" : ":\(fense)")}\n\(node.literal() ?? ""){code}")

            case  (_, .code):
                let literal = "{{\(node.literal() ?? "")}}"
                texts.append(literal)

            case (.enter, .blockQuote):
                blockBeginnings.append(result.count)
            case (.enter, .list):
                blockBeginnings.append(result.count)
                switch node.listType() ?? .bullet {
                case .bullet:
                    listPrefixes += "*"
                case .ordered:
                    listPrefixes += "#"
                }
            case (.exit, .list):
                guard let marker = blockBeginnings.popLast() else {
                    break
                }

                listPrefixes.removeLast()

                if listPrefixes.isEmpty {
                    let joinedLists = result[marker...].joined(separator: "\n")
                    result = result[0..<marker] + [joinedLists]
                }

            case (.enter, .item):
                blockBeginnings.append(result.count)
            case (.exit, .item):
                guard let marker = blockBeginnings.popLast() else {
                    break
                }


                let content = listPrefixes + " " + result[marker...].joined(separator: "\n")
                result = result[0..<marker] + [content]

            case (.exit, .blockQuote):
                guard let marker = blockBeginnings.popLast() else {
                    break
                }

                let content = result[marker...].joined(separator: "\n")
                result = result[0..<marker] + ["{quote}\n\(content)\n{quote}"]

            case (.exit, .strong):
                texts[texts.count - 1] = texts.last.map { "*" + $0 + "*" } ?? ""
                stack.removeLast()

            case (.exit, .emphasize):
                texts[texts.count - 1] = texts.last.map { "_" + $0 + "_" } ?? ""
                stack.removeLast()

            case (.exit, .heading):
                if let level = node.headingLevel() {
                    result.append("h\(level). \(consolidate())")
                }
            case (.exit, .link):
                if let link = node.url() {
                    texts[texts.count - 1] = texts.last.map { "[\($0)|\(link)]" } ?? ""
                }

            case (.exit, .image):
                if let link = node.url() {
                    texts.append( " !\(link)! ")
                }

                stack.removeLast()

            case _:
                break
            }
        }

        return result.joined(separator: "\n\n")
    }
}
