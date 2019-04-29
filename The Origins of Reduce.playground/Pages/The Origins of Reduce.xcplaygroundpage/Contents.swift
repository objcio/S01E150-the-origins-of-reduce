import Foundation

let numbers = Array(1...10)

numbers.reduce(Int.min, max)
numbers.reduce(0, +)

extension Sequence where Element: Equatable {
    func contains1(_ el: Element) -> Bool {
        return reduce(false) { result, x in
            return x == el || result
        }
    }
}

numbers.contains1(3)
numbers.contains1(13)

enum List<Element> {
    case empty
    indirect case cons(Element, List)
}

let list: List<Int> = .cons(1, .cons(2, .cons(3, .empty)))
//dump(list)

extension List {
    func fold<Result>(_ emptyCase: Result, _ consCase: (Element, Result) -> Result) -> Result {
        switch self {
        case .empty:
            return emptyCase
        case let .cons(x, xs):
            return consCase(x, xs.fold(emptyCase, consCase))
        }
    }
    
    func reduce<Result>(_ emptyCase: Result, _ consCase: (Element, Result) -> Result) -> Result {
        var result = emptyCase
        switch self {
        case .empty:
            return result
        case let .cons(x, xs):
            return xs.reduce(consCase(x, result), consCase)
        }
    }

    func reduce1<Result>(_ emptyCase: Result, _ consCase: (Element, Result) -> Result) -> Result {
        var result = emptyCase
        var copy = self
        while case let .cons(x, xs) = copy {
            result = consCase(x, result)
            copy = xs
        }
        return result
    }
}

list.fold(0, +)
let l = list.fold(0, { _, result in result + 1 })
l

dump(list.fold(List.empty, List.cons))
dump(list.reduce1(List.empty, List.cons))
