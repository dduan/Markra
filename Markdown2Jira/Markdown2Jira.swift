import Markdown

struct JIRARenderer: MarkupWalker {
    var paragraphs = [String]()
    var inlineLeaves = [String]()
    var listPrefixes = ""

    private mutating func joinLeaves() -> String {
        let result = self.inlineLeaves.joined()
        self.inlineLeaves = []
        return result
    }

    func render() -> String {
        assert(self.listPrefixes.isEmpty, "Renderer has unfinished list")
        assert(self.inlineLeaves.isEmpty, "Renderer has unfinished inline leaves")

        return self.paragraphs.joined(separator: "\n")
    }

    private mutating func visitList<L: ListItemContainer>(prefix: String, list: L) {
        let existingParagrahs = self.paragraphs
        self.paragraphs = []
        self.listPrefixes += prefix
        descendInto(list)
        self.listPrefixes.removeLast()
        if listPrefixes.isEmpty {
            self.paragraphs = existingParagrahs + [self.paragraphs.joined(separator: "\n")]
        } else {
            self.paragraphs = existingParagrahs + self.paragraphs
        }
    }

    mutating func visitOrderedList(_ orderedList: OrderedList) -> () {
        self.visitList(prefix: "#", list: orderedList)
    }

    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> () {
        self.visitList(prefix: "*", list: unorderedList)
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
        let existingParagraphs = self.paragraphs
        self.paragraphs = []
        descendInto(blockQuote)
        let quote = """
        {quote}
        \(paragraphs.joined(separator: "\n\n"))
        {quote}
        """
        self.paragraphs = existingParagraphs + [quote]
    }

    mutating func visitParagraph(_ paragraph: Paragraph) {
        descendInto(paragraph)
        assert(!self.inlineLeaves.isEmpty, "Empty paragraph is unexpected")
        let prefix = self.listPrefixes.isEmpty ? "" : "\(self.listPrefixes) "
        self.paragraphs.append(prefix + self.joinLeaves())
    }

    mutating func visitHeading(_ heading: Heading) {
        assert(self.inlineLeaves.isEmpty, "Inline leaves should be empty prior to heading")
        descendInto(heading)
        let content = self.joinLeaves()
        self.paragraphs.append("h\(min(6, heading.level)). \(content)")
    }

    mutating func visitLink(_ link: Link) {
        descendInto(link)
        let content = self.joinLeaves()
        let destination = link.destination ?? ""
        let shortFormat = content.isEmpty || destination == content
        let rendered = shortFormat ? "[\(destination)]" : "[\(content)|\(link.destination ?? "")]"
        self.inlineLeaves.append(rendered)
    }

    mutating func visitImage(_ image: Image) {
        descendInto(image)
        self.inlineLeaves = []
        var parts = [image.source ?? ""]

        var secondPart = ""
        if !image.plainText.isEmpty {
            secondPart += #",alt="\#(image.plainText)""#
        }

        if let title = image.title, !title.isEmpty {
            secondPart += #",title="\#(title)""#
        }

        if !secondPart.isEmpty {
            parts.append(secondPart)
        }

        self.inlineLeaves.append("!\(parts.joined(separator: "|"))!")
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) {
        let existingLeaves = self.inlineLeaves
        self.inlineLeaves = []
        descendInto(emphasis)
        let newLeaf = "_\(self.joinLeaves())_"
        self.inlineLeaves = existingLeaves + [newLeaf]
    }

    mutating func visitStrong(_ strong: Strong) {
        let existingLeaves = self.inlineLeaves
        self.inlineLeaves = []
        descendInto(strong)
        let newLeaf = "*\(self.joinLeaves())*"
        self.inlineLeaves = existingLeaves + [newLeaf]
    }

    mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
        self.paragraphs.append("""
        {code\(codeBlock.language.map { ":\($0)" } ?? "")}
        \(codeBlock.code){code}
        """)
    }

    // MARK: - Inline Leaves
    mutating func visitInlineCode(_ inlineCode: InlineCode) {
        self.inlineLeaves.append("{{\(inlineCode.code)}}")
    }

    mutating func visitText(_ text: Text) {
        self.inlineLeaves.append(text.plainText)
    }

    mutating func visitSoftBreak(_ softBreak: SoftBreak) {
        self.inlineLeaves.append("\n")
    }

    mutating func visitLineBreak(_ lineBreak: LineBreak) {
        self.inlineLeaves.append("\\\\")
    }
}

public func markdown2Jira(_ markdown: String) -> String {
    let document = Document(parsing: markdown)
    var renderer = JIRARenderer()
    renderer.visit(document)
    return renderer.render()
}
