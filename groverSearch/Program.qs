namespace groverSearch {

    //normal grover search

    // open Microsoft.Quantum.Canon;
    // open Microsoft.Quantum.Intrinsic;
    // open Microsoft.Quantum.Arrays;
    // open Microsoft.Quantum.Convert;
    
    // @EntryPoint()
    // operation SolveGraphColoringProblem() : Unit {
    //     // Graph description: hardcoded from the example
    //     let nVertices = 5;
    //     let edges = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (3, 4)];

    //     // Graph coloring: hardcoded from the example
    //     let coloring = [false, false, true, false, false, true, true, true, true, false];
    //     let colors = ["red", "green", "blue", "yellow"];

    //     // Interpret the coloring: split the bit string into 2-bit fragments and convert them to colors.
    //     let colorBits = Chunks(2, coloring);
    //     for i in 0 .. nVertices - 1 {
    //         let colorIndex = BoolArrayAsInt(colorBits[i]);
    //         Message($"Vertex {i} - color #{colorIndex} ({colors[colorIndex]})");
    //     }
    // }


    //modified grover search

    // open Microsoft.Quantum.Measurement;
    // open Microsoft.Quantum.Math;
    // open Microsoft.Quantum.Arrays;
    // open Microsoft.Quantum.Canon;
    // open Microsoft.Quantum.Convert;
    // open Microsoft.Quantum.Diagnostics;
    // open Microsoft.Quantum.Intrinsic;


    // operation MarkColorEquality(c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl {
    //     within {
    //         for (q0, q1) in Zipped(c0, c1) {
    //             CNOT(q0, q1);
    //         }
    //     } apply {
    //         (ControlledOnInt(0, X))(c1, target);
    //     }
    // }


    // operation MarkValidVertexColoring(
    //     edges : (Int, Int)[], 
    //     colorsRegister : Qubit[], 
    //     target : Qubit
    // ) : Unit is Adj+Ctl {
    //     let nEdges = Length(edges);
    //     let colors = Chunks(2, colorsRegister);
    //     use conflictQubits = Qubit[nEdges];
    //     within {
    //         for ((start, end), conflictQubit) in Zipped(edges, conflictQubits) {
    //             MarkColorEquality(colors[start], colors[end], conflictQubit);
    //         }
    //     } apply {
    //         (ControlledOnInt(0, X))(conflictQubits, target);
    //     }
    // }


    // operation ApplyMarkingOracleAsPhaseOracle(
    //     markingOracle : ((Qubit[], Qubit) => Unit is Adj), 
    //     register : Qubit[]
    // ) : Unit is Adj {
    //     use target = Qubit();
    //     within {
    //         X(target);
    //         H(target);
    //     } apply {
    //         markingOracle(register, target);
    //     }
    // }


    // operation RunGroversSearch(register : Qubit[], phaseOracle : ((Qubit[]) => Unit is Adj), iterations : Int) : Unit {
    //     ApplyToEach(H, register);
        
    //     for _ in 1 .. iterations {
    //         phaseOracle(register);
    //         within {
    //             ApplyToEachA(H, register);
    //             ApplyToEachA(X, register);
    //         } apply {
    //             Controlled Z(Most(register), Tail(register));
    //         }
    //     }
    // }


    // @EntryPoint()
    // operation SolveGraphColoringProblem() : Unit {
    //     // Graph description: hardcoded from the example.
    //     let nVertices = 5;
    //     let edges = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (3, 4)];

    //     // Define the oracle that implements this graph coloring.
    //     let markingOracle = MarkValidVertexColoring(edges, _, _);
    //     let phaseOracle = ApplyMarkingOracleAsPhaseOracle(markingOracle, _);

    //     // Define the parameters of the search.
        
    //     // Each color is described using 2 bits (or qubits).
    //     let nQubits = 2 * nVertices;

    //     // The search space is all bit strings of length nQubits.
    //     let searchSpaceSize = 2 ^ (nQubits);

    //     // The number of solutions is the number of permutations of 4 colors (over the first four vertices) = 4!
    //     // multiplied by 3 colors that vertex 4 can take in each case.
    //     let nSolutions = 72;

    //     // The number of iterations can be computed using a formula.
    //     let nIterations = Round(PI() / 4.0 * Sqrt(IntAsDouble(searchSpaceSize) / IntAsDouble(nSolutions)));

    //     mutable answer = new Bool[nQubits];
    //     use (register, output) = (Qubit[nQubits], Qubit());
    //     mutable isCorrect = false;
    //     repeat {
    //         RunGroversSearch(register, phaseOracle, nIterations);
    //         let res = MultiM(register);
    //         // Check whether the result is correct.
    //         markingOracle(register, output);
    //         if (MResetZ(output) == One) {
    //             set isCorrect = true;
    //             set answer = ResultArrayAsBoolArray(res);
    //         }
    //         ResetAll(register);
    //     } until (isCorrect);
    //     // Convert the answer to readable format (actual graph coloring).
    //     let colorBits = Chunks(2, answer);
    //     Message("The resulting graph coloring:");
    //     for i in 0 .. nVertices - 1 {
    //         Message($"Vertex {i} - color {BoolArrayAsInt(colorBits[i])}");
    //     }
    // }

    //ISBNGrover
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic; 
    open Microsoft.Quantum.Arrays; 
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Diagnostics;


    @EntryPoint()
    operation SearchForMissingDigit() : Unit {

        // define the incomplete ISBN, missing digit at -1
        let inputISBN = [0, 3, 0, 6, -1, 0, 6, 1, 5, 2];
        let constants = GetIsbnCheckConstants(inputISBN);
        let (a, b) = constants;

        Message($"ISBN with missing digit: {inputISBN}");
        Message($"Oracle validates: ({b} + {a}x) mod 11 = 0 \n");

        // get the number of Grover iterations required for 10 possible results and 1 solution
        let numIterations = NIterations(10);

        // Define the oracle
        let phaseOracle = IsbnOracle(constants, _);

        // Allocate 4-qubit register necessary to represent the possible values (digits 0-9)
        use digitReg = Qubit[4];
        mutable missingDigit = 0;
        mutable resultISBN = new Int[10];
        mutable attempts = 0;

        // Repeat the algorithm until the result forms a valid ISBN
        repeat{
            RunGroversSearch(digitReg, phaseOracle, numIterations);
            // print the resulting state of the system and then measure
            DumpMachine(); 
            set missingDigit = MeasureInteger(LittleEndian(digitReg));
            set resultISBN = MakeResultIsbn(missingDigit, inputISBN);
            // keep track of the number of attempts
            set attempts = attempts  + 1;
        } 
        until IsIsbnValid(resultISBN);

        // print the results
        Message($"Missing digit: {missingDigit}");
        Message($"Full ISBN: {resultISBN}");
        if attempts == 1 {
            Message($"The missing digit was found in {attempts} attempt.");
        }
        else {
            Message( $"The missing digit was found in {attempts} attempts.");
        }
    }


    operation ComputeIsbnCheck(constants : (Int, Int), digitReg : Qubit[], targetReg : Qubit[]) : Unit is Adj + Ctl {
        let (a, b) = constants;
        ApplyXorInPlace(b, LittleEndian(targetReg));
        MultiplyAndAddByModularInteger(a, 11, LittleEndian(digitReg), LittleEndian(targetReg));
    }


    operation IsbnOracle(constants : (Int, Int), digitReg : Qubit[]) : Unit is Adj + Ctl {
        use (targetReg, flagQubit) = (Qubit[Length(digitReg)], Qubit());
        within {
            X(flagQubit);
            H(flagQubit);
            ComputeIsbnCheck(constants, digitReg, targetReg);
        } apply {
            ApplyControlledOnInt(0, X, targetReg, flagQubit);
        }
    }


    function GetIsbnCheckConstants(digits : Int[]) : (Int, Int) {
        EqualityFactI(Length(digits), 10, "Expected a 10-digit number.");
        mutable a = 0;
        mutable b = 0;
        for (idx, digit) in Enumerated(digits) {
            if digit < 0 {
                set a = 10 - idx;
            }
            else {
                set b += (10 - idx) * digit;
            } 
        }
        return (a, b % 11);
    }


    function NIterations(nItems : Int) : Int {
        let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));
        let nIterations = Round(0.25 * PI() / angle - 0.5);
        return nIterations;
    }


    operation PrepareUniformSuperpositionOverDigits(digitReg : Qubit[]) : Unit is Adj + Ctl {
        PrepareArbitraryStateCP(ConstantArray(10, ComplexPolar(1.0, 0.0)), LittleEndian(digitReg));
    }


    operation ReflectAboutUniform(digitReg : Qubit[]) : Unit {
        within {
            Adjoint PrepareUniformSuperpositionOverDigits(digitReg);
            ApplyToEachCA(X, digitReg);
        } apply {
            Controlled Z(Most(digitReg), Tail(digitReg));
        }
    }


    function IsIsbnValid(digits : Int[]) : Bool {
        EqualityFactI(Length(digits), 10, "Expected a 10-digit number.");
        mutable acc = 0;
        for (idx, digit) in Enumerated(digits) {
            set acc += (10 - idx) * digit;
        }
        return acc % 11 == 0;
    }


    function MakeResultIsbn(missingDigit : Int, inputISBN : Int[]) : Int[] {
        mutable resultISBN = new Int[Length(inputISBN)];
        for i in 0..Length(inputISBN) - 1 {
            if inputISBN[i] < 0 {
                set resultISBN w/= i <- missingDigit;
            }
            else {
                set resultISBN w/= i <- inputISBN[i];
            }
        }
        return resultISBN;
    }


    operation RunGroversSearch(register : Qubit[], phaseOracle : ((Qubit[]) => Unit is Adj), iterations : Int) : Unit {
        PrepareUniformSuperpositionOverDigits(register);
        for _ in 1 .. iterations {
            phaseOracle(register);
            ReflectAboutUniform(register);
        }
    }
}
