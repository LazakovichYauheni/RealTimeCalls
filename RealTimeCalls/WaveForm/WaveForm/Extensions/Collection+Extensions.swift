extension Collection {
    /// Один элемент в коллекции
    var isSingle: Bool { count == 1 }

    private func distance(from startIndex: Index) -> Int {
        distance(from: startIndex, to: endIndex)
    }

    private func distance(to endIndex: Index) -> Int {
        distance(from: startIndex, to: endIndex)
    }
    
    subscript(safe index: Index) -> Iterator.Element? {
        if
            distance(to: index) >= 0,
            distance(from: index) > 0 {
            return self[index]
        }
        return nil
    }

    subscript(safe bounds: Range<Index>) -> SubSequence? {
        if
            distance(to: bounds.lowerBound) >= 0,
            distance(from: bounds.upperBound) >= 0 {
            return self[bounds]
        }
        return nil
    }

    subscript(safe bounds: ClosedRange<Index>) -> SubSequence? {
        if
            distance(to: bounds.lowerBound) >= 0,
            distance(from: bounds.upperBound) > 0 {
            return self[bounds]
        }
        return nil
    }
}
