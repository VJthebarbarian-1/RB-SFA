(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage["RBSFA`"];


dipole::usage="dipole[p,\[Kappa]] returns the dipole transition matrix element for a 1s hydrogenic state of ionization potential \!\(\*SubscriptBox[\(I\), \(p\)]\)=\!\(\*FractionBox[\(1\), \(2\)]\)\!\(\*SuperscriptBox[\(\[Kappa]\), \(2\)]\).";
Begin["`Private`"];
dipole[p_,\[Kappa]_]:=(8I)/\[Pi] (Sqrt[2\[Kappa]^5]p)/(Norm[p]^2+\[Kappa]^2)^3
End[];


flatTopEnvelope::usage="flatTopEnvelope[\[Omega],num,nRamp] returns a Function object representing a flat-top envelope at carrier frequency \[Omega] lasting a total of num cycles and with linear ramps nRamp cycles long.";
Begin["`Private`"];
flatTopEnvelope[\[Omega]_,num_,nRamp_]:=Function[t,Piecewise[{{0,t<0},{Sin[(\[Omega] t)/(4nRamp)]^2,0<=t<(2 \[Pi])/\[Omega] nRamp},{1,(2 \[Pi])/\[Omega] nRamp<=t<(2 \[Pi])/\[Omega] (num-nRamp)},{Sin[(\[Omega] ((2 \[Pi])/\[Omega] num-t))/(4nRamp)]^2,(2 \[Pi])/\[Omega] (num-nRamp)<=t<(2 \[Pi])/\[Omega] num},{0,(2 \[Pi])/\[Omega] num<=t}}]]
End[];


cosPowerFlatTop::usage="cosPowerFlatTop[\[Omega],num,power] returns a Function object representing a smooth flat-top envelope of the form 1-Cos(\[Omega] t/2 num\!\(\*SuperscriptBox[\()\), \(power\)]\)";
Begin["`Private`"];
cosPowerFlatTop[\[Omega]_,num_,power_]:=Function[t,1-Cos[(\[Omega] t)/(2num)]^power]
End[];


PointsPerCycle::usage="PointsPerCycle is a sampling option which specifies the number of sampling points per cycle to be used in integrations.";
TotalCycles::usage="TotalCycles is a sampling option which specifies the total number of periods to be integrated over.";
CarrierFrequency::usage="CarrierFrequency is a sampling option which specifies the carrier frequency to be used.";
Protect[PointsPerCycle,TotalCycles,CarrierFrequency];


standardOptions={PointsPerCycle->90,TotalCycles->1,CarrierFrequency->0.057};


harmonicOrderAxis::usage="harmonicOrderAxis[opt\[Rule]value] returns a list of frequencies which can be used as a frequency axis for Fourier transforms, scaled in units of harmonic order, for the provided field duration and sampling options.";
TargetLength::usage="TargetLength is an option for harmonicOrderAxis which specifies the total length required of the resulting list.";
LengthCorrection::usage="LengthCorrection is an option for harmonicOrderAxis which allows for manual correction of the length of the resulting list.";
Protect[LengthCorrection,TargetLength];
Begin["`Private`"];
Options[harmonicOrderAxis]=standardOptions~Join~{TargetLength->Automatic,LengthCorrection->1};
harmonicOrderAxis::target="Invalid TargetLength option `1`. This must be a positive integer or Automatic.";
harmonicOrderAxis[OptionsPattern[]]:=Module[{num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle]},
Piecewise[{
{1/num Range[0.,Round[(npp num+1)/2.]-1+OptionValue[LengthCorrection]],OptionValue[TargetLength]===Automatic},
{Round[(npp num+1)/2.]/num Range[0,OptionValue[TargetLength]-1]/OptionValue[TargetLength],IntegerQ[OptionValue[TargetLength]]&&OptionValue[TargetLength]>=0}
},
Message[harmonicOrderAxis::target,OptionValue["TargetLength"]];Abort[]
]
]
End[];


frequencyAxis::usage="frequencyAxis[opt\[Rule]value] returns a list of frequencies which can be used as a frequency axis for Fourier transforms, in atomic units of frequency, for the provided field duration and sampling options.";
Begin["`Private`"];
Options[frequencyAxis]=Options[harmonicOrderAxis];
frequencyAxis[options:OptionsPattern[]]:=OptionValue[CarrierFrequency]harmonicOrderAxis[options]
End[];


timeAxis::usage="timeAxis[opt\[Rule]value] returns a list of times which can be used as a time axis ";
TimeScale::usage="TimeScale is an option for timeAxis which specifies the units the list should use: AtomicUnits by default, or LaserPeriods if required.";
AtomicUnits::usage="AtomicUnits is a value for the option TimeScale of timeAxis which specifies that the times should be in atomic units of time.";
LaserPeriods::usage="LaserPeriods is a value for the option TimeScale of timeAxis which specifies that the times should be in multiples of the carrier laser period.";
Protect[TimeScale,AtomicUnits,LaserPeriods];
Begin["`Private`"];
Options[timeAxis]=standardOptions~Join~{TimeScale->AtomicUnits};
timeAxis::scale="Invalid TimeScale option `1`. Available values are AtomicUnits and LaserPeriods";
timeAxis[OptionsPattern[]]:=Block[{T=2\[Pi]/\[Omega],\[Omega]=OptionValue[CarrierFrequency],num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle]},
Piecewise[{
{1,OptionValue[TimeScale]==AtomicUnits},
{1/T,OptionValue[TimeScale]==LaserPeriods}
},
Message[timeAxis::scale,OptionValue[TimeScale]];Abort[]
]*Table[t
,{t,0,num (2\[Pi])/\[Omega],num/(num*npp+1) (2\[Pi])/\[Omega]}
]
]
End[];


getSpectrum::usage="getSpectrum[DipoleList] returns the power spectrum of DipoleList.";
Polarization::usage="Polarization is an option for getSpectrum which specifies a polarization vector along which to polarize the dipole list. The default, Polarization\[Rule]False, specifies an unpolarized spectrum.";
ComplexPart::usage="part is an option for getSpectrum which specifies a function (like Re, Im, or by default #&) which should be applied to the dipole list before the spectrum is taken.";
\[Omega]Power::usage="\[Omega]Power is an option for getSpectrum which specifies a power of frequency which should multiply the spectrum.";
DifferentiationOrder::usage="DifferentiationOrder is an option for getSpectrum which specifies the order to which the dipole list should be differentiated before the spectrum is taken.";
Protect[Polarization,part,\[Omega]Power,DifferentiationOrder];

Begin["`Private`"];
Options[getSpectrum]={Polarization->False,ComplexPart->(#&),\[Omega]Power->0,DifferentiationOrder->0}~Join~standardOptions;

getSpectrum::diffOrd="Invalid differentiation order `1`.";
getSpectrum::\[Omega]Pow="Invalid \[Omega] power `1`.";

getSpectrum[dipoleList_,OptionsPattern[]]:=Block[
{polarizationVector,differentiatedList,depth,dimensions,
num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle],\[Omega]=OptionValue[CarrierFrequency],\[Delta]t=(2\[Pi]/\[Omega])/npp
},
polarizationVector=OptionValue[Polarization]/Norm[OptionValue[Polarization]];

differentiatedList=OptionValue[ComplexPart][Piecewise[{
{dipoleList,OptionValue[DifferentiationOrder]==0},
{1/(2\[Delta]t) (Most[Most[dipoleList]]-Rest[Rest[dipoleList]]),OptionValue[DifferentiationOrder]==1},
{1/\[Delta]t^2 (Most[Most[dipoleList]]-2Most[Rest[dipoleList]]+Rest[Rest[dipoleList]]),OptionValue[DifferentiationOrder]==2}},
Message[getSpectrum::diffOrd,OptionValue[DifferentiationOrder]];Abort[]
]];

If[NumberQ[OptionValue[\[Omega]Power]],Null;,Message[getSpectrum::\[Omega]Pow,OptionValue[\[Omega]Power]];Abort[]  ];

num Table[
(\[Omega]/num k)^(2OptionValue[\[Omega]Power]),{k,1,Round[Length[differentiatedList]/2]}
]*If[
OptionValue[Polarization]===False,(*unpolarized spectrum*)
(*funky depth thing so this can take lists of numbers and lists of vectors, of arbitrary length. Makes for easier benchmarking.*)
depth=Length[Dimensions[dipoleList]];
dimensions=If[Length[#]>1,#[[2]],1(*#\[LeftDoubleBracket]1\[RightDoubleBracket]*)]&[Dimensions[dipoleList]];
Sum[Abs[
Fourier[
If[depth>1,Re[differentiatedList[[All,i]]],Re[differentiatedList[[All]]]]
,FourierParameters->{-1, 1}
][[1;;Round[Length[differentiatedList]/2]]]
]^2,{i,1,dimensions}]
,(*polarized spectrum*)
Abs[
Transpose[Table[
Fourier[
Re[differentiatedList[[All,i]]]
,FourierParameters->{-1, 1}
]
,{i,1,2}]][[1;;Round[Length[differentiatedList]/2]]].polarizationVector
]^2
]
]
End[];


spectrumPlotter::usage="spectrumPlotter[spectrum] plots the given spectrum with an appropriate axis in a \!\(\*SubscriptBox[\(log\), \(10\)]\) scale.";
FrequencyAxis::usage="FrequencyAxis is an option for spectrumPlotter which specifies the axis to use.";
Protect[FrequencyAxis];
Begin["`Private`"];
Options[spectrumPlotter]=Join[{FrequencyAxis->"HarmonicOrder"},Options[harmonicOrderAxis],Options[ListLinePlot]];
spectrumPlotter[spectrum_,options:OptionsPattern[]]:=ListPlot[
{Which[
OptionValue[FrequencyAxis]==="HarmonicOrder",
harmonicOrderAxis["TargetLength"->Length[spectrum],Sequence@@FilterRules[{options}~Join~Options[spectrumPlotter],Options[harmonicOrderAxis]]],
OptionValue[FrequencyAxis]==="Frequency",
frequencyAxis["TargetLength"->Length[spectrum],Sequence@@FilterRules[{options}~Join~Options[spectrumPlotter],Options[harmonicOrderAxis]]],
True,Range[Length[spectrum]]
],
Log[10,spectrum]
}\[Transpose]
,Sequence@@FilterRules[{options},Options[ListLinePlot]]
,Joined->True
,PlotRange->Full
,PlotStyle->Thick
,Frame->True
,Axes->False
,ImageSize->800
]
End[];


biColorSpectrum::usage="biColorSpectrum[DipoleList] produces a two-colour spectrum of DipoleList, separating the two circular polarizations.";
Begin["`Private`"];
Options[biColorSpectrum]=Join[{PlotRange->All},Options[Show],Options[spectrumPlotter],DeleteCases[Options[getSpectrum],Polarization->False]];
biColorSpectrum[dipoleList_,options:OptionsPattern[]]:=Show[{
spectrumPlotter[
getSpectrum[dipoleList,Polarization->{1,+I},Sequence@@FilterRules[{options},Options[getSpectrum]]],
PlotStyle->Red,Sequence@@FilterRules[{options},Options[spectrumPlotter]]],
spectrumPlotter[
getSpectrum[dipoleList,Polarization->{1,-I},Sequence@@FilterRules[{options},Options[getSpectrum]]],
PlotStyle->Blue,Sequence@@FilterRules[{options},Options[spectrumPlotter]]]
}
,PlotRange->OptionValue[PlotRange]
,Sequence@@FilterRules[{options},Options[Show]]
]
End[];


SineSquaredGate::usage="SineSquaredGate[nGateRamp] specifies an integration gate with a sine-squared ramp, such that SineSquaredGate[nGateRamp][\[Omega]t,nGate] has nGate flat periods and nGateRamp ramp periods.";
LinearRampGate::usage="LinearRampGate[nGateRamp] specifies an integration gate with a linear ramp, such that SineSquaredGate[nGateRamp][\[Omega]t,nGate] has nGate flat periods and nGateRamp ramp periods.";
Begin["`Private`"];
SineSquaredGate[nGateRamp_][\[Omega]\[Tau]_,nGate_]:=Piecewise[{{1,\[Omega]\[Tau]<=2\[Pi] (nGate-nGateRamp)},{Sin[(2\[Pi] nGate-\[Omega]\[Tau])/(4nGateRamp)]^2,2\[Pi] (nGate-nGateRamp)<\[Omega]\[Tau]<=2\[Pi] nGate},{0,nGate<\[Omega]\[Tau]}}]
LinearRampGate[nGateRamp_][\[Omega]\[Tau]_,nGate_]:=Piecewise[{{1,\[Omega]\[Tau]<=2\[Pi] (nGate-nGateRamp)},{-((\[Omega]\[Tau]-2\[Pi] (nGate+nGateRamp))/(2\[Pi] nGateRamp)),2\[Pi] (nGate-nGateRamp)<\[Omega]\[Tau]<=2\[Pi] nGate},{0,nGate<\[Omega]\[Tau]}}]
End[];


makeDipoleList::usage="makeDipoleList[VectorPotential\[Rule]A] calculates the dipole response to the vector potential A.";

VectorPotential::usage="VectorPotential is an option for makeDipole list which specifies the field's vector potential. Usage should be VectorPotential\[Rule]A, where A[t]//.pars must yield a list of numbers for numeric t and parameters indicated by FieldParameters\[Rule]pars.";
VectorPotentialGradient::usage="VectorPotentialGradient is an option for makeDipole list which specifies the gradient of the field's vector potential. Usage should be VectorPotentialGradient\[Rule]GA, where GA[t]//.pars must yield a square matrix of the same dimension as the vector potential for numeric t and parameters indicated by FieldParameters\[Rule]pars. The indices must be such that GA[t]\[LeftDoubleBracket]i,j\[RightDoubleBracket] returns \!\(\*SubscriptBox[\(\[PartialD]\), \(i\)]\)\!\(\*SubscriptBox[\(A\), \(j\)]\)[t].";
FieldParameters::usage="FieldParameters is an option for makeDipole list which ";
Preintegrals::usage="Preintegrals is an option for makeDipole list which specifies whether the preintegrals of the vector potential should be \"Analytic\" or \"Numeric\".";
ReportingFunction::usage="ReportingFunction is an option for makeDipole list which specifies a function used to report the results, either internally (by the default, Identity) or to an external file.";
Gate::usage="Gate is an option for makeDipole list which specifies the integration gate to use. Usage as Gate\[Rule]g, nGate\[Rule]n will gate the integral at time \[Omega]t/\[Omega] by g[\[Omega]t,n]. The default is Gate\[Rule]SineSquaredGate[1/2].";
nGate::usage="nGate is an option for makeDipole list which specifies the total number of cycles in the integration gate.";
IonizationPotential::usage="IonizationPotential is an option for makeDipole list which specifies the ionization potential \!\(\*SubscriptBox[\(I\), \(p\)]\) of the target.";
\[Epsilon]Correction::usage="\[Epsilon]Correction is an option for makeDipole list which specifies the regularization correction \[Epsilon], i.e. as used in the factor \!\(\*FractionBox[\(1\), SuperscriptBox[\((t - tt + \[ImaginaryI]\\\ \[Epsilon])\), \(3/2\)]]\).";
PointNumberCorrection::usage="PointNumberCorrection is an option for makeDipole list which specifies an extra number of points to be integrated over, which is useful to prevent Indeterminate errors when a Piecewise envelope is being differentiated at the boundaries.";


Protect[VectorPotential,VectorPotentialGradient,FieldParameters,Preintegrals,ReportingFunction,Gate,IonizationPotential,nGate,nGateRamp,\[Epsilon]Correction];


Begin["`Private`"];
Options[makeDipoleList]=standardOptions~Join~{
VectorPotential->Automatic,FieldParameters->{},VectorPotentialGradient->None,
Preintegrals->"Analytic",ReportingFunction->Identity,
Gate->SineSquaredGate[1/2],nGate->3/2,
\[Epsilon]Correction->0.1,IonizationPotential->0.5,
PointNumberCorrection->0,Verbose->0
};
makeDipoleList::gate="The integration gate g provided as Gate\[Rule]`1` is incorrect. Its usage as g[`2`,`3`] returns `4` and should return a number.";
makeDipoleList::pot="The vector potential A provided as VectorPotential\[Rule]`1` is incorrect or is missing FieldParameters. Its usage as A[`2`] returns `3` and should return a list of numbers.";
makeDipoleList::gradpot="The vector potential GA provided as VectorPotentialGradient\[Rule]`1` is incorrect or is missing FieldParameters. Its usage as GA[`2`] returns `3` and should return a square matrix of numbers. Alternatively, use VectorPotentialGradient\[Rule]None.";
makeDipoleList::preint="Wrong Preintegrals option `1`. Valid options are \"Analytic\" and \"Numeric\".";



makeDipoleList[OptionsPattern[]]:=Block[
{
num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle],\[Omega]=OptionValue[CarrierFrequency],\[Kappa]=Sqrt[2OptionValue[IonizationPotential]],
A,F,GA,pi,ps,S,
gate,tGate,setPreintegral,
tol,gridPointQ,tInit,tFinal,\[Delta]t,\[Epsilon]=OptionValue[\[Epsilon]Correction],
AInt,A2Int,GAInt,GAdotAInt,AdotGAInt,GAIntInt,bigPScorrectionInt,AdotGAdotAInt,
AIntList,A2IntList,GAIntList,GAdotAIntList,AdotGAIntList,GAIntIntList,bigPScorrectionIntList,AdotGAdotAIntList,
dipoleList
},

A[t_]=OptionValue[VectorPotential][t]//.OptionValue[FieldParameters];
F[t_]=-D[A[t],t];
GA[t_]=If[
TrueQ[OptionValue[VectorPotentialGradient]==None],        Table[0,{Length[A[tInit]]},{Length[A[tInit]]}],
OptionValue[VectorPotentialGradient][t]//.OptionValue[FieldParameters]
];

tInit=0;
tFinal=(2\[Pi])/\[Omega] num;
\[Delta]t=(tFinal-tInit)/(num*npp+OptionValue[PointNumberCorrection]);(*integration and looping timestep*)
tGate=OptionValue[nGate] (2\[Pi])/\[Omega];
(*Check potential and potential gradient for correctness.*)
With[{\[Omega]tRandom=RandomReal[{\[Omega] tInit,\[Omega] tFinal}]},
If[!And@@(NumberQ/@A[\[Omega]tRandom/\[Omega]]),Message[makeDipoleList::pot,OptionValue[VectorPotential],\[Omega]tRandom,A[\[Omega]tRandom]];Abort[]];
If[!And@@(NumberQ/@Flatten[GA[\[Omega]tRandom/\[Omega]]]),Message[makeDipoleList::gradpot,OptionValue[VectorPotentialGradient],\[Omega]tRandom,GA[\[Omega]tRandom]];Abort[]];
];

Which[
OptionValue[Preintegrals]=="Analytic",
gridPointQ[_]=True;
,OptionValue[Preintegrals]=="Numeric",
tol=10^-5;gridPointQ[t_]:=gridPointQ[t]=Abs[(t-tInit)/\[Delta]t-Round[(t-tInit)/\[Delta]t]]<tol&&tInit-tol<=t<=tFinal+tol;
(*Checks whether the given time is part of the time grid in use, up to tolerance tol.*)
,True,Message[makeDipoleList::preint,OptionValue[Preintegrals]];Abort[];
];

gate[\[Omega]\[Tau]_]:=OptionValue[Gate][\[Omega]\[Tau],OptionValue[nGate]];
With[{\[Omega]tRandom=RandomReal[{\[Omega] tInit,\[Omega] tFinal}]},
If[!TrueQ[NumberQ[gate[\[Omega]tRandom]]],
Message[makeDipoleList::gate,OptionValue[Gate],\[Omega]tRandom,OptionValue[nGate],gate[\[Omega]tRandom]];Abort[]]
];


setPreintegral[integralVariable_,listVariable_,preintegrand_,nullValue_:False]:=Which[
OptionValue[VectorPotentialGradient]=!=None||nullValue===False,(*Vector potential gradient specified, or integral variable does not depend on it, so integrate*)
Which[
OptionValue[Preintegrals]=="Analytic",
integralVariable[t_]=Integrate[preintegrand[t],t];
integralVariable[t_,tt_]=((#/.{\[Tau]->t})-(#/.{\[Tau]->tt}))&[Integrate[preintegrand[\[Tau]],\[Tau]]];
,OptionValue[Preintegrals]=="Numeric",
listVariable=\[Delta]t*Accumulate[Table[preintegrand[t],{t,tInit,tFinal,\[Delta]t}]];
integralVariable[t_?gridPointQ,tt_?gridPointQ]:=listVariable[[Round[t/\[Delta]t+1]]]-listVariable[[Round[tt/\[Delta]t+1]]];
integralVariable[t_?gridPointQ]:=integralVariable[t,tInit];
];
,OptionValue[VectorPotentialGradient]===None,(*No vector potential has been specified, return appropriate zero matrix*)
integralVariable[t_]=nullValue;
integralVariable[t_,tt_]=nullValue;
];
Apply[setPreintegral,({
 {AInt, AIntList, A[#]&, False},
 {A2Int, A2IntList, A[#].A[#]&, False},
 {GAInt, GAIntList, GA[#]&, Table[0,{Length[A[tInit]]},{Length[A[tInit]]}]},
 {GAdotAInt, GAdotAIntList, GA[#].A[#]&, Table[0,{Length[A[tInit]]}]},
 {AdotGAInt, AdotGAIntList, A[#].GA[#]&, Table[0,{Length[A[tInit]]}]},
 {GAIntInt, GAIntInt, GAInt[#]&, Table[0,{Length[A[tInit]]},{Length[A[tInit]]}]},
 {AdotGAdotAInt, AdotGAdotAIntList, A[#].GAdotAInt[#]&, 0},
 {bigPScorrectionInt, bigPScorrectionIntList, GAdotAInt[#]+A[#].GAInt[#]&, Table[0,{Length[A[tInit]]}]}
}),{1}];
(*{\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(A
\*SuperscriptBox[\((\[Tau])\), \(2\)]\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(\[Del]A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(\[Del]A\((\[Tau])\)\[CenterDot]A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(A\((\[Tau])\)\[CenterDot]\[Del]A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(t\)]\(
\*SuperscriptBox[\(\[Integral]\), \(\[Tau]\)]\[Del]A\((\[Tau]')\)\[DifferentialD]\[Tau]'\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(t\)]\(
\*SubscriptBox[\(A\), \(k\)]\((\[Tau])\)\[CenterDot]\(
\*SuperscriptBox[\(\[Integral]\), \(\[Tau]\)]
\*SubscriptBox[\(\[PartialD]\), \(k\)]
\*SubscriptBox[\(A\), \(j\)]\((\[Tau]')\)
\*SubscriptBox[\(A\), \(j\)]\((\[Tau]')\)\[DifferentialD]\[Tau]'\[DifferentialD]\[Tau]\)\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(t\)]\(
\*SuperscriptBox[\(\[Integral]\), \(\[Tau]\)]\((
\*SubscriptBox[\(A\), \(k\)]\((\[Tau]')\)
\*SubscriptBox[\(\[PartialD]\), \(j\)]
\*SubscriptBox[\(A\), \(k\)]\((\[Tau]')\) + 
\*SubscriptBox[\(A\), \(k\)]\((\[Tau])\)
\*SubscriptBox[\(\[PartialD]\), \(k\)]
\*SubscriptBox[\(A\), \(j\)]\((\[Tau]')\))\)\[DifferentialD]\[Tau]'\[DifferentialD]\[Tau]\)\)};*)

(*Displaced momentum*)
pi[p_,t_]:=p+A[t]-GAInt[t].p-GAdotAInt[t];

(*Stationary momentum and action*)
ps[t_?gridPointQ,tt_?gridPointQ]:=ps[t,tt]=-(1/(t-tt-I \[Epsilon]))Inverse[IdentityMatrix[Length[A[tInit]]]-1/(t-tt-I \[Epsilon]) (GAIntInt[t,tt]+GAIntInt[t,tt]\[Transpose])].(AInt[t,tt]-bigPScorrectionInt[t,tt]);

S[t_?gridPointQ,tt_?gridPointQ]:=1/2 (Norm[ps[t,tt]]^2+\[Kappa]^2)(t-tt)+ps[t,tt].AInt[t,tt]+1/2 A2Int[t,tt]-(
ps[t,tt].GAIntInt[t,tt].ps[t,tt]+ps[t,tt].bigPScorrectionInt[t,tt]+AdotGAdotAInt[t,tt]
);

(*Debugging constructs. Verbose\[Rule]1 prints information about the internal functions. Verbose\[Rule]2 returns all the relevant internal functions and stops.*)
Which[
OptionValue[Verbose]==1,Information/@{ps,pi,S,AInt,A2Int,GAInt,GAdotAInt,AdotGAInt,GAIntInt,bigPScorrectionInt,AdotGAdotAInt},
OptionValue[Verbose]==2,Return[With[{t=Global`t,tt=Global`tt,p=Global`t,\[Tau]=Global`\[Tau]},
{ps[t,tt],pi[p,t],S[t,tt],AInt[t],AInt[t,tt],A2Int[t],A2Int[t,tt],GAInt[t],GAInt[t,tt],GAdotAInt[t],GAdotAInt[t,tt],AdotGAInt[t],AdotGAInt[t,tt],GAIntInt[t],GAIntInt[t,tt],bigPScorrectionInt[t],bigPScorrectionInt[t,tt],AdotGAdotAInt[t],AdotGAdotAInt[t,tt],I ((2\[Pi])/(\[Epsilon]+I \[Tau]))^(3/2) dipole[pi[ps[t,t-\[Tau]],t],\[Kappa]]\[Conjugate]*dipole[pi[ps[t,t-\[Tau]],t-\[Tau]],\[Kappa]].F[t-\[Tau]]Exp[-I S[t,t-\[Tau]]]gate[\[Omega] \[Tau]]}]]
];

(*Numerical integration loop*)
(dipoleList=Table[
OptionValue[ReportingFunction][
\[Delta]t Sum[(
I ((2\[Pi])/(\[Epsilon]+I \[Tau]))^(3/2) dipole[pi[ps[t,t-\[Tau]],t],\[Kappa]]\[Conjugate]*dipole[pi[ps[t,t-\[Tau]],t-\[Tau]],\[Kappa]].F[t-\[Tau]]Exp[-I S[t,t-\[Tau]]]gate[\[Omega] \[Tau]] 
),{\[Tau],0,If[OptionValue[Preintegrals]=="Analytic",tGate,Min[t-tInit,tGate]],\[Delta]t}]
]
,{t,tInit,tFinal,\[Delta]t}]);
dipoleList

]
End[];


EndPackage[]



