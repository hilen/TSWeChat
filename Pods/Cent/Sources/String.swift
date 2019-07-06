//
//  String.swift
//  Cent
//
//  Created by Ankur Patel on 6/30/14.
//  Copyright (c) 2014 Encore Dev Labs LLC. All rights reserved.
//

import Foundation

public extension String {

    public var length: Int {
        get {
            return self.count
        }
    }

    public var camelCase: String {
        get {
            return self.deburr().words().reduceWithIndex(initial: "") { (result, index, word) -> String in
                let lowered = word.lowercased()
                return result + (index > 0 ? lowered.capitalized(with: .none) : lowered)
            }
        }
    }

    public var kebabCase: String {
        get {
            return self.deburr().words().reduceWithIndex(initial: "", combine: { (result, index, word) -> String in
                return result + (index > 0 ? "-" : "") + word.lowercased()
            })
        }
    }

    public var snakeCase: String {
        get {
            return self.deburr().words().reduceWithIndex(initial: "", combine: { (result, index, word) -> String in
                return result + (index > 0 ? "_" : "") + word.lowercased()
            })
        }
    }

    public var startCase: String {
        get {
            return self.deburr().words().reduceWithIndex(initial: "", combine: { (result, index, word) -> String in
                let padding = (index > 0) ? " " : ""
                return result + padding + word.capitalized(with: .none)
            })
        }
    }

    /// Get character at a subscript
    ///
    /// - parameter index: Index for which the character is returned
    /// - returns: Character at index i
    public subscript(index: Int) -> Character? {
        if let char = Array(self).get(index: index) {
            return char
        }
        return .none
    }

    /// Get character at a subscript
    ///
    /// - parameter i: Index for which the character is returned
    /// - returns: Character at index i
    public subscript(pattern: String) -> String? {
        if let range = Range(Regex(pattern).rangeOfFirstMatch(testStr: self)) {
            return self[range]
        }
        return .none
    }

    /// Get substring using subscript notation and by passing a range
    ///
    /// - parameter range: The range from which to start and end the substring
    /// - returns: Substring
    public subscript(range: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: range.lowerBound)
        let end = self.index(startIndex, offsetBy: range.upperBound)
        return self.substring(with: start..<end)
    }

    /// Get substring using subscript notation and by passing a range
    ///
    /// - parameter range: The range from which to start and end the substring
    /// - returns: Substring
    public subscript(range: CountableClosedRange<Int>) -> String {
        let start = self.index(startIndex, offsetBy: range.lowerBound)
        let end = self.index(startIndex, offsetBy: range.upperBound + 1)
        return self.substring(with: start..<end)
    }

    /// Get the start index of string
    ///
    /// - parameter str: String to get index of
    /// - returns: start index of .None if not found
    public func indexOf(str: String) -> Int? {
        return self.indexOfRegex(pattern: Regex.escapeStr(str: str))
    }

    /// Get the start index of regex pattern
    ///
    /// - parameter pattern: Regex pattern to get index of
    /// - returns: start index of .None if not found
    public func indexOfRegex(pattern: String) -> Int? {
        if let range = Range(Regex(pattern).rangeOfFirstMatch(testStr: self)) {
            return range.lowerBound
        }
        return .none
    }

    /// Get an array from string split using the delimiter character
    ///
    /// - parameter delimiter: Character to delimit
    /// - returns: Array of strings after spliting
    public func split(delimiter: Character) -> [String] {
        return self.components(separatedBy: String(delimiter))
    }

    /// Remove leading whitespace characters
    ///
    /// - returns: String without leading whitespace
    public func lstrip() -> String {
        return self["[^\\s]+.*$"]!
    }

    /// Remove trailing whitespace characters
    ///
    /// - returns: String without trailing whitespace
    public func rstrip() -> String {
        return self["^.*[^\\s]+"]!
    }

    /// Remove leading and trailing whitespace characters
    ///
    /// - returns: String without leading or trailing whitespace
    public func strip() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    /// Split string into array of 'words'
    ///
    /// - returns: array of strings
    func words() -> [String] {
        let hasComplexWordRegex = try! NSRegularExpression(pattern: RegexHelper.hasComplexWord, options: [])
        let wordRange = NSMakeRange(0, self.count)
        let hasComplexWord = hasComplexWordRegex.rangeOfFirstMatch(in: self, options: [], range: wordRange)
        let wordPattern = hasComplexWord.length > 0 ? RegexHelper.complexWord : RegexHelper.basicWord
        let wordRegex = try! NSRegularExpression(pattern: wordPattern, options: [])
        let matches = wordRegex.matches(in: self, options: [], range: wordRange)
        let words = matches.map { (result: NSTextCheckingResult) -> String in
            if let range = self.range(from: result.range) {
                return self.substring(with: range)
            } else {
                return ""
            }
        }
        return words
    }

    /// Strip string of accents and diacritics
    ///
    /// - returns: New string
    func deburr() -> String {
	  let deburredString = self.folding(options: .diacriticInsensitive, locale: .current)
	  return deburredString
    }

    /// Converts an NSRange to a Swift friendly Range supporting Unicode
    ///
    /// - parameter nsRange: the NSRange to be converted
    /// - returns: A corresponding Range if possible
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return .none }
        return from..<to
    }
}

public extension Character {

    /// Get int representation of character
    ///
    /// - returns: UInt32 that represents the given character
    public var ord: UInt32 {
        get {
            let desc = self.description
            return desc.unicodeScalars[desc.unicodeScalars.startIndex].value
        }
    }

    /// Convert character to string
    ///
    /// - returns: String representation of character
    public var description: String {
        get {
            return String(self)
        }
    }
}

infix operator =~

/// Regex match the string on the left with the string pattern on the right
///
/// - parameter str: String to test
/// - parameter pattern: Pattern to match
/// - returns: true if string matches the pattern otherwise false
public func=~(str: String, pattern: String) -> Bool {
    return Regex(pattern).test(testStr: str)
}

/// Concat the string to itself n times
///
/// - parameter str: String to test
/// - parameter num: Number of times to concat string
/// - returns: concatenated string
public func*(str: String, num: Int) -> String {
    var stringBuilder = [String]()
    num.times {
        stringBuilder.append(str)
    }
    return stringBuilder.joined(separator: "")
}
