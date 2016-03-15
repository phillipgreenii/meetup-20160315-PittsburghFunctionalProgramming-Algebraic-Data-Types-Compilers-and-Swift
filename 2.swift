//https://swiftlang.ng.bluemix.net/#/repl/77414d60fd0059ebdb39c3d88c9eef5e103c843897a16644e033498c0a84996e

// Algebraic Data Types, Compilers and Swift
// Programming Exercise Two:
// Products and Pattern Matching


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

enum Product: Evaluable {
    indirect case Multiplication(Product, Atom)
    indirect case Division(Product, Atom)
    case AtomShortcut(Atom)

    func eval() -> Int {
        switch self {
        // TODO: Handle Multiplication case
        // TODO: Handle Division case
        // TODO: Handle Division where rhs == 0 special case
        // TODO: Handle AtomShortcut case
        default:
            return 42
        }
    }
}

enum Sum: Evaluable {
    indirect case Add(Sum, Product)
    indirect case Minus(Sum, Product)
    case ProductShortcut(Product)
    case AtomShortcut(Atom)

    func eval() -> Int {
        switch self {
        case .Add(let lhs, let rhs):
            return lhs.eval() + rhs.eval()

        case .Minus(let lhs, let rhs):
            return lhs.eval() - rhs.eval()

        case .ProductShortcut(let product):
            return product.eval()

        case .AtomShortcut(let atom):
            return atom.eval()
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

let ast = Product.Multiplication(.AtomShortcut(.Number(20)), .Number(5))

testRunnerAST("Multiplication", input:ast, expected:100)

let ast2 = Product.Division(.AtomShortcut(.Number(0)), .Number(5))

testRunnerAST("Division", input:ast2, expected:0)

let ast3 = Product.Division(.AtomShortcut(.Number(7)), .Number(0))

testRunnerAST("Division By Zero", input:ast3, expected:-1)

let ast4 = Product.Multiplication(ast3, .Number(6))

testRunnerAST("Product Nesting", input:ast4, expected:-6)
