clear
clc

Z = -3 + 5i;
Re = real(Z) %[output:0fefd534]
Im = imag(Z) %[output:05533dca]

Mag1 = abs(Z) %[output:8104dd5f]
Mag2 = sqrt(Re .^ 2 + Im .^ 2) %[output:6539370e]

Phase1 = angle(Z) %[output:6514a4a2]
Phase2 = atan(Im/Re) %[output:4b2eb815]
Phase3 = atan2(Im, Re) %[output:20acabae]

Z_conj = conj(Z);
Val1 = (Z + Z_conj)/2 %[output:0ce35a11]
Val2 = (Z - Z_conj)/2 %[output:16920142]

Q = [Z Z Z];
Q1 = Q'
Q2 = Q.'


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40}
%---
%[output:0fefd534]
%   data: {"dataType":"textualVariable","outputData":{"name":"Re","value":"-3"}}
%---
%[output:05533dca]
%   data: {"dataType":"textualVariable","outputData":{"name":"Im","value":"5"}}
%---
%[output:8104dd5f]
%   data: {"dataType":"textualVariable","outputData":{"name":"Mag1","value":"5.8310"}}
%---
%[output:6539370e]
%   data: {"dataType":"textualVariable","outputData":{"name":"Mag2","value":"5.8310"}}
%---
%[output:6514a4a2]
%   data: {"dataType":"textualVariable","outputData":{"name":"Phase1","value":"2.1112"}}
%---
%[output:4b2eb815]
%   data: {"dataType":"textualVariable","outputData":{"name":"Phase2","value":"-1.0304"}}
%---
%[output:20acabae]
%   data: {"dataType":"textualVariable","outputData":{"name":"Phase3","value":"2.1112"}}
%---
%[output:0ce35a11]
%   data: {"dataType":"textualVariable","outputData":{"name":"Val1","value":"-3"}}
%---
%[output:16920142]
%   data: {"dataType":"textualVariable","outputData":{"name":"Val2","value":"0.0000 + 5.0000i"}}
%---
