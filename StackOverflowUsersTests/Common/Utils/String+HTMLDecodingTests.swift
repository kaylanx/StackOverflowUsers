import Testing
@testable import StackOverflowUsers

struct StringHTMLDecodingTests {

    @Test("When string has html character code then string gets converted correctly")
    func decodeHTMLString() {
        let input = "Hello &amp; welcome"
        let expected = "Hello & welcome"
        #expect(input.htmlDecoded == expected)

        let userNameInput = "Christian C. Salvad&#243;"
        let expectedUserName = "Christian C. Salvadó"
        #expect(userNameInput.htmlDecoded == expectedUserName)
    }
}
