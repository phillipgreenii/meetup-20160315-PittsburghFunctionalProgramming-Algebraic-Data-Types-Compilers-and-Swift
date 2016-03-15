//https://swiftlang.ng.bluemix.net/#/repl/47793293ac40e090d0c043dd223d5a299c20a435bde7c402aab899ade65d2967

// Algebraic Data Types, Compilers and Swift
// Programming Exercise One:
// Sum ADT


protocol Evaluable {
    func eval() -> Int
}

enum Atom: Evaluable {
    case Number(Int)

    func eval() -> Int {
        switch self {
        case .Number(let number):
            return number
        }
    }
}

enum Sum: Evaluable {
    indirect case Add(Sum, Atom)
    indirect case Minus(Sum, Atom)
    case AtomShortcut(Atom)

    func eval() -> Int {
        switch self {
            // TODO: Handle Add case
            // TODO: Handle Minus case

        case .AtomShortcut(let atom):
            return atom.eval()

        default:
            return 42
        }
    }
}


// Tests
// DO NOT EDIT BELOW THIS LINE
// However, feel free to look at the tests to help guide you

func testRunnerAST(name:String, input:Evaluable, expected:Int) {
    let result = input.eval()

    testRunnerResultsPrinter(name, result:result, expected:expected)
}

func testRunnerResultsPrinter(name:String, result:Int, expected:Int) {
    if result == expected {
        print("✓ \(name) test passed")
    } else {
        print("✗ \(name) test failed")
        print("Expected: \(expected)")
        print("Got: \(result)")
    }

    // End with an empty line
    print("")
}

let ast = Sum.Add(.AtomShortcut(.Number(20)), .Number(5))

testRunnerAST("Add", input:ast, expected:25)

let ast2 = Sum.Minus(.AtomShortcut(.Number(0)), .Number(5))

testRunnerAST("Minus", input:ast2, expected:-5)

let ast3 = Sum.Add(ast2, .Number(4))

testRunnerAST("Nesting", input:ast3, expected:-1)
