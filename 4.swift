//https://swiftlang.ng.bluemix.net/#/repl/5ad33a7037f5e3e17ce3dbbf40cd99c86773ff0af5c6521cf19e262cfb267c6f

// Algebraic Data Types, Compilers and Swift
// Programming Exercise Four:
// Statement


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

    func findIdentifier(env:Env, identifier:String) throws -> Int {
        if let val = env[identifier] {
            return val
        } else {
            throw CompilerError.UndefinedVariable(identifier)
        }
    }

    func eval(env:Env) throws -> Int {
        switch self {
        case .Number(let number):
            return number

        case .Variable(let variable):
            return try findIdentifier(env, identifier:variable)
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

enum Statement {
    indirect case Chain(Statement, Statement)
    indirect case Assign(String, Statement)
    case SumShortcut(Sum)
    case AtomShortcut(Atom)

    func eval(env:Env) throws -> Env {
        switch self {
        case .Chain(let statOne, let statTwo):
            // TODO: Fix Chain case
            return ["": 0]

        case .Assign(let identifier, let stat):
            // TODO: Fix Assign case
            return ["": 0]

        case .SumShortcut(let sum):
            return ["output": try sum.eval(env)]

        case .AtomShortcut(let atom):
            return ["output": try atom.eval(env)]
        }
    }
}


// Tests
// DO NOT EDIT BELOW THIS LINE
// However, feel free to look at the tests to help guide you

func testRunnerAST(name:String, input:Statement, env:Env, expected:String) {
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

let ast1 =
Statement.Assign(
    "y",
    .AtomShortcut(.Number(1))
)

testRunnerAST("Assign", input:ast1, env:Env(), expected:"[\"y\": 1]")

let ast2 =
Statement.Chain(
    .Assign(
        "y",
        .AtomShortcut(.Number(1))
    ),
    .SumShortcut(
        .Add(
            .AtomShortcut(.Variable("y")),
            .AtomShortcut(.Number(1))
        )
    )
)

testRunnerAST("Chain", input:ast2, env:Env(), expected:"[\"output\": 2]")
