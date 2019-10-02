function [TF, IC] = sysID(patient)
% Use this template to design an open-loop system identification routine given
% the step time response of the patient. 

%% input response
% The input response is loaded here and used to simulate the patient to produce 
% the step response. Feel free to alter this section as needed to try different
% types of inputs that may help with the identification process
clos
% Simulate the open loop response of the generated patient
Sugar = openLoopSim(patient,Food,InsulinRate);

% Get Sugar values at time_vec time. This is basic linear interpolation and
% is nessesary because Simulink does not guarantee Sugar.Time will equal time_vec
sugar_vec = interp1(Sugar.Time,Sugar.Data,time_vec,'linear');

%% system identification

% Here are some potentially useful functions:
% - findpeak
% - min/max

%Find the peaks in the data, this is when the slope changes sign
[PKS,LOCS] = findpeaks(sugar_vec,time_vec);

%Fine the min and max 
min_val = min(sugar_vec);
max_val = max(sugar_vec);

SS_63 = sugar_vec(1) + (sugar_vec(end) - sugar_vec(1)) * 0.63;

for i = 1:length(sugar_vec)
   if(sugar_vec(i) < SS_63)
       Tau = i;
       break;
   end
end

a = 1/Tau;

%In the example we ignore the peaks, min and max and just output a first order 
%response shifted by 160 
%Produce first order transfer function as output
s = tf('s');

TF = -(max_val-min_val)*(a)/(s+a)*(exp(-20*s));
%Produce initial condition (offset from zero)
IC = max_val;

end