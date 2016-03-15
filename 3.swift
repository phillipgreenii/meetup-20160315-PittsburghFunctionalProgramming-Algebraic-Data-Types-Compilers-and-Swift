//https://swiftlang.ng.bluemix.net/#/repl/78a67a19fa832392df809e7adbaec05deefbbb5988260df9ae445da38832fe72

// Algebraic Data Types, Compilers and Swift
// Programming Exercise Three Solution:
// Errors and Enviroments


typealias Env = [String: Int]

enum CompilerError: ErrorType {
    case DivisionByZero
    case UndefinedVariable(String)
}

protocol Evaluable {
    func eval(env:Env) throws -> Int
}

enum Atom: Evaluable {
    case Number(Int)
    case Variable(String)

    func eval(env:Env) throws -> Int {
        switch self {
        case .Number(let number):
            return number
        case Variable(let name):
            if let val = env[name] {
                return val
            } else {
                throw CompilerError.UndefinedVariable(name)
            }
        default:
            return 42
        }
    }
}

enum Product: Evaluable {
    indirect case Multiplication(Product, Atom)
    indirect case Division(Product, Atom)
    case AtomShortcut(Atom)

    func eval(env:Env) throws -> Int {
        switch self {
        case .Multiplication(let lhs, let rhs):
            return try lhs.eval(env) * rhs.eval(env)

        case .Division(let lhs, let rhs):
            switch rhs {
            case .Number(let number) where number == 0:
                throw CompilerError.DivisionByZero
            default:
                return try lhs.eval(env) / rhs.eval(env)
            }

        case .AtomShortcut(let atom):
            return try atom.eval(env)
        }
    }
}

enum Sum: Evaluable {
    indirect case Add(Sum, Product)
    indirect case Minus(Sum, Product)
    case ProductShortcut(Product)
    case AtomShortcut(Atom)

    func eval(env:Env) throws -> Int {
        switch self {
        case .Add(let lhs, let rhs):
            return try lhs.eval(env) + rhs.eval(env)

        case .Minus(let lhs, let rhs):
            return try lhs.eval(env) - rhs.eval(env)

        case .ProductShortcut(let product):
            return try product.eval(env)

        case .AtomShortcut(let atom):
            return try atom.eval(env)
        }
    }
}


// Tests
// DO NOT EDIT BELOW THIS LINE
// However, feel free to look at the tests to help guide you

func testRunnerAST(name:String, input:Evaluable, env:Env, expected:String) {
    let result:String

    do {
        result = "\(try input.eval(env))"
    } catch CompilerError.DivisionByZero {
        result = "Compiler Error - Division By Zero"
    } catch CompilerError.UndefinedVariable(let identifier) {
        result = "Compiler Error - Undefined Variable: \(identifier)"
    } catch {
        result = "Compiler Error - Unknown Error"
    }

    testRunnerResultsPrinter(name, result:result, expected:expected)
}

func testRunnerResultsPrinter(name:String, result:String, expected:String) {
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

let ast1 = Product.Division(.AtomShortcut(.Number(7)), .Number(0))

testRunnerAST("Division By Zero", input:ast1, env:Env(), expected:"Compiler Error - Division By Zero")

let ast2 = Product.Division(.AtomShortcut(.Variable("z")), .Number(1))

testRunnerAST("Undefined Variable z", input:ast2, env:Env(), expected:"Compiler Error - Undefined Variable: z")

let ast3 = Product.Division(.AtomShortcut(.Variable("z")), .Number(1))

testRunnerAST("Variable z", input:ast3, env:["z":5], expected:"5")
