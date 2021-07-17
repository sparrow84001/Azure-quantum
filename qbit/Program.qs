namespace qbit {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    @EntryPoint()
    operation GenerateRandomBit() : Result {
       // Allocate a qubit.
        use q = Qubit();
        // Put the qubit to superposition.
        H(q);
        // It now has a 50% chance of being measured 0 or 1.
        // Measure the qubit value.
        return M(q);
    }
}
