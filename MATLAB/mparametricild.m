function [ild_db, parameters] = mparametricild(freq_hz, azimuth_degs, verbosealue);
%
% Implements the parametric ILDs reported in 
% "A set of equations for numerically calculating the interaural level
% difference in the horizontal plane."
% Michael A Akeroyd, Jennifer Firth, Simone Graetzer and Samuel Smith
% 
% example commandlinecall:
%
% (ild_db, parameters) = mparametricild(2000, 45, 1);
%
% CC-BY license
% MAA, February 2021
%------------------------------

testdata_file = FunctionFile('../tests/data/mparametricild'); 
testdata_file.save('freq_hz',  'azimuth_degs'); 

f_logkhz = log10(freq_hz/1000);
a_rads = azimuth_degs/360*2*pi;

if verbosealue >=1 
    fprintf('f (kHz)  = %6.0f\n',  freq_hz);
    fprintf('log(f, kHz)  = %7.4f\n',  f_logkhz);
    fprintf('azimth(rads) = %7.4f\n',  a_rads);
    fprintf('\n');
end;

mainparameters = [...
13.062	11.696	2.865	0.203	0.351	-1.772	0.303	0.114	-4.022	0.688	0.222	0.619	0.788	0.049	;...
-0.578	0.504	-0.959	-0.649	0.374	-0.144	0.035	0.168	-0.044	0.295	0.068	0.039	0.654	0.064	;...
0.647	1.118	-7.516	0.052	0.352	1.242	0.266	0.107	-0.128	0.503	0.030	-9.038	1.330	0.220	;...
-0.224	1.605	2.868	-1.010	0.135	-0.028	0.475	0.054	-0.041	0.827	0.030	-6.000	1.340	0.030	;...
-0.063	0.326	0.040	-0.302	0.149	-0.055	0.245	0.092	0.160	0.649	0.584	-0.115	0.749	0.126	;...
];
fivekhzpertubationparameters = [-0.266	0.707	0.076	2.750	0.200];

%--------------------------------------------

% extract
row = 1;
primarymagnitude_line.slope      = mainparameters(row,1); 
primarymagnitude_line.constant   = mainparameters(row,2); 
for n=1:4
  primarymagnitude_normal(n).mag = mainparameters(row,n*3+0); 
  primarymagnitude_normal(n).mu  = mainparameters(row,n*3+1); 
  primarymagnitude_normal(n).std = mainparameters(row,n*3+2); 
end;

row = 2;
asymmetry_line.slope      = mainparameters(row,1); 
asymmetry_line.constant   = mainparameters(row,2); 
for n=1:4
  asymmetry_normal(n).mag = mainparameters(row,n*3+0); 
  asymmetry_normal(n).mu  = mainparameters(row,n*3+1); 
  asymmetry_normal(n).std = mainparameters(row,n*3+2); 
end;

row = 3;
dipmagnitude_line.slope      = mainparameters(row,1); 
dipmagnitude_line.constant   = mainparameters(row,2); 
for n=1:4
  dipmagnitude_normal(n).mag = mainparameters(row,n*3+0); 
  dipmagnitude_normal(n).mu  = mainparameters(row,n*3+1); 
  dipmagnitude_normal(n).std = mainparameters(row,n*3+2); 
end;

row = 4;
dipmu_line.slope      = mainparameters(row,1); 
dipmu_line.constant   = mainparameters(row,2); 
for n=1:4
  dipmu_normal(n).mag = mainparameters(row,n*3+0); 
  dipmu_normal(n).mu  = mainparameters(row,n*3+1); 
  dipmu_normal(n).std = mainparameters(row,n*3+2); 
end;

row = 5;
dipstd_line.slope      = mainparameters(row,1); 
dipstd_line.constant   = mainparameters(row,2); 
for n=1:4
  dipstd_normal(n).mag = mainparameters(row,n*3+0); 
  dipstd_normal(n).mu  = mainparameters(row,n*3+1); 
  dipstd_normal(n).std = mainparameters(row,n*3+2); 
end;

fivekhzperturb_magnitude.mag = fivekhzpertubationparameters(1);
fivekhzperturb_magnitude.mu  = fivekhzpertubationparameters(2);
fivekhzperturb_magnitude.std = fivekhzpertubationparameters(3);
fivekhzperturb_mu            = fivekhzpertubationparameters(4);
fivekhzperturb_std           =  fivekhzpertubationparameters(5);



% get the parameters for this frequency

linearcontribution = primarymagnitude_line.slope * f_logkhz + primarymagnitude_line.constant;
normalcontribution(1:4) = 0;
for n=1:4; normalcontribution(n) = primarymagnitude_normal(n).mag * normpdf(f_logkhz, primarymagnitude_normal(n).mu, primarymagnitude_normal(n).std);end;
primarymagnitude = linearcontribution + sum(normalcontribution(1:4));
if verbosealue >=1 
    fprintf('primary =             %7.4f = %7.4f + %7.4f + %7.4f + %7.4f + %7.4f\n',  primarymagnitude, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;
    
linearcontribution = asymmetry_line.slope * f_logkhz        + asymmetry_line.constant;
normalcontribution(1:4) = 0;
for n=1:4; normalcontribution(n) = asymmetry_normal(n).mag * normpdf(f_logkhz, asymmetry_normal(n).mu, asymmetry_normal(n).std);end;
asymmetryparameter = linearcontribution + sum(normalcontribution(1:4));
if verbosealue >=1 
    fprintf('asymmetryparameter =  %7.4f = %7.4f + %7.4f + %7.4f + %7.4f + %7.4f\n',  asymmetryparameter, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = dipmagnitude_line.slope * f_logkhz     + dipmagnitude_line.constant;
normalcontribution(1:4) = 0;
for n=1:4; normalcontribution(n) = dipmagnitude_normal(n).mag * normpdf(f_logkhz, dipmagnitude_normal(n).mu, dipmagnitude_normal(n).std);end;
dipmagnitude = linearcontribution + sum(normalcontribution(1:4));
if verbosealue >=1 
    fprintf('dip mag =             %7.4f = %7.4f + %7.4f + %7.4f + %7.4f + %7.4f\n',  dipmagnitude, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = dipmu_line.slope * f_logkhz            + dipmu_line.constant;
normalcontribution(1:4) = 0;
for n=1:4 normalcontribution(n) = dipmu_normal(n).mag * normpdf(f_logkhz, dipmu_normal(n).mu, dipmu_normal(n).std); end;
dipmu = linearcontribution + sum(normalcontribution(1:4));
if verbosealue >=1 
    fprintf('dip normal-mu =       %7.4f = %7.4f + %7.4f + %7.4f + %7.4f + %7.4f\n',  dipmu, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = dipstd_line.slope * f_logkhz           + dipstd_line.constant;
normalcontribution(1:4) = 0;
for n=1:4; normalcontribution(n) = dipstd_normal(n).mag * normpdf(f_logkhz, dipstd_normal(n).mu, dipstd_normal(n).std); end;
dipstd = linearcontribution + sum(normalcontribution(1:4));
if verbosealue >=1 
    fprintf('dip normal-std =      %7.4f = %7.4f + %7.4f + %7.4f + %7.4f + %7.4f\n',  dipstd, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = 0;
%normalcontribution = 0;
normalcontribution = fivekhzperturb_magnitude.mag * normpdf(f_logkhz, fivekhzperturb_magnitude.mu, fivekhzperturb_magnitude.std);
fivekhzmagnitude = linearcontribution + normalcontribution;
if verbosealue >=1 
    fprintf('fivekHzparameter=     %7.4f = %7.4f + %7.4f \n',  fivekhzmagnitude, linearcontribution, normalcontribution(1));
end;


% .. and then use them to get the ILD ...
primarysinusoid = primarymagnitude * sin(a_rads);
asymmetry       = asymmetryparameter * sin(2*a_rads) + 1;
dip             = dipmagnitude * normpdf(a_rads, dipmu, dipstd);
fivekhz         = fivekhzmagnitude * normpdf(a_rads, fivekhzperturb_mu, fivekhzperturb_std);
if verbosealue >=1 
    fprintf('\n');
    fprintf('primary contribution =  %5.2f dB\n',  primarysinusoid);
    fprintf('asymmetry            = x%5.2f\n',  asymmetry);
    fprintf('dip contribution     =  %5.2f dB\n',  dip);
    fprintf('fivekhz contribution =  %5.2f dB\n',  fivekhz);
end;

    
ild_db = 0;
ild_db = ild_db + primarysinusoid * asymmetry; 
ild_db = ild_db + dip; 
ild_db = ild_db + fivekhz; 

if verbosealue >=1 
    fprintf('ILD                  =  %5.2f dB\n', ild_db);
    fprintf('\n');
end;


% store for output
parameters.primarymagnitude = primarymagnitude;
parameters.asymmetry        = asymmetryparameter;
parameters.dipmagnitude     = dipmagnitude;
parameters.dipmu            = dipmu;
parameters.dipstd           = dipstd;
parameters.fivekhzmagnitude = fivekhzmagnitude;

testdata_file.save('ild_db'); 
testdata_file.close();

% the end
%-----------------
