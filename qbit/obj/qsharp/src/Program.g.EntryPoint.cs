//------------------------------------------------------------------------------
// <auto-generated>                                                             
//     This code was generated by a tool.                                       
//     Changes to this file may cause incorrect behavior and will be lost if    
//     the code is regenerated.                                                 
// </auto-generated>                                                            
//------------------------------------------------------------------------------
using System;
using Microsoft.Quantum.Core;
using Microsoft.Quantum.Intrinsic;
using Microsoft.Quantum.Simulation.Core;

namespace qbit
{
    internal class __QsEntryPoint__GenerateRandomBit : Microsoft.Quantum.EntryPointDriver.IEntryPoint
    {
        public string Name => "qbit.GenerateRandomBit";
        public string Summary => "";
        public System.Collections.Generic.IEnumerable<System.CommandLine.Option> Options => new System.CommandLine.Option[] { };
        public QVoid CreateArgument(System.CommandLine.Parsing.ParseResult parseResult) => QVoid.Instance;
        public System.Threading.Tasks.Task<int> Submit(System.CommandLine.Parsing.ParseResult parseResult, Microsoft.Quantum.EntryPointDriver.AzureSettings settings) => Microsoft.Quantum.EntryPointDriver.Azure.Submit(global::qbit.GenerateRandomBit.Info, this.CreateArgument(parseResult), settings);
        public System.Threading.Tasks.Task<int> Simulate(System.CommandLine.Parsing.ParseResult parseResult, Microsoft.Quantum.EntryPointDriver.DriverSettings settings, string simulator) => Microsoft.Quantum.EntryPointDriver.Simulation<global::qbit.GenerateRandomBit, QVoid, Result>.Simulate(this, this.CreateArgument(parseResult), settings, simulator);
    }
}