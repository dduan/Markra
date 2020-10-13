import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var markdown: UTType {
        UTType(importedAs: "ca.duan.markra.plain-text", conformingTo: .plainText)
    }
}

struct MarkdownDocument: FileDocument {
    var text: String
    let id = UUID()
    init(text: String = "") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.markdown] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }

        text = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
