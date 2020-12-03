function [ild_db, parameters] = mparametricild_20200224(freq_hz, azimuth_degs, verboseoption);
%
% #20200224 - first version
%
% #20200331 - with the 5kHz pertubation.
% from Excel 2020031b
%
% #20200402a__stdlimit0p03
% smallest std allowed = 0.03 -- from excel 20200402a | F
%
%
% > ild_db = mparametricild_20200402a__stdlimit0p03(500, 45, 1);
% > [ild_db, parameters] = mparametricild_20200402a__stdlimit0p03(500, 45, 1);
%
% MAA Feb 2020
%------------------------------

testdata_file = FunctionFile('data/mparametricilds'); 
testdata_file.save('freq_hz',  'azimuth_degs'); 

f_logkhz = log10(freq_hz/1000);
a_rads = azimuth_degs/360*2*pi;

if verboseoption >=1 
    fprintf('log(f, kHz)  = %6.3f\n',  f_logkhz);
    fprintf('azimth(rads) = %6.3f\n',  a_rads);
end;

% parameters pasted from excel 20200402a | F
mainparameters = [...
13.0621	11.6956	-4.0224	0.6882	0.2223	2.8651	0.2034	0.3508	-1.7716	0.3034	0.1137	0.6188	0.7882	0.0489; ...
-0.5782	0.5041	-0.9590	-0.6493	0.3741	-0.1439	0.0345	0.1678	-0.0443	0.2955	0.0678	0.0389	0.6539	0.0640; ...
0.6466	1.1185	-9.0378	1.3305	0.2196	-7.5159	0.0522	0.3522	1.2418	0.2660	0.1070	-0.1280	0.5030	0.0300; ...
-0.2238	1.6047	-6.0000	1.3402	0.0300	2.8675	-1.0099	0.1350	-0.0405	0.8272	0.0300	-0.0282	0.4746	0.0539; ...
-0.0629	0.3258	-0.1153	0.7487	0.1261	-0.0551	0.2448	0.0919	0.0398	-0.3022	0.1494	0.1600	0.6487	0.5839; 
];

fivekhzpertubationparameters = [-0.2664	0.7067	0.0763	2.7500	0.2000];

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
for n=1:4
    normalcontribution(n) = primarymagnitude_normal(n).mag * normpdf(f_logkhz, primarymagnitude_normal(n).mu, primarymagnitude_normal(n).std);
end

primarymagnitude = linearcontribution + sum(normalcontribution(1:4));
if verboseoption >=1 
    fprintf('primary =      %6.3f = %6.3f + %6.3f + %6.3f + %6.3f + %6.3f\n',  primarymagnitude, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;
    
linearcontribution = asymmetry_line.slope * f_logkhz        + asymmetry_line.constant;
for n=1:4; normalcontribution(n) = asymmetry_normal(n).mag * normpdf(f_logkhz, asymmetry_normal(n).mu, asymmetry_normal(n).std);end;
asymmetryparameter = linearcontribution + sum(normalcontribution(1:4));
if verboseoption >=1 
    fprintf('asymmetry =    %6.3f = %6.3f + %6.3f + %6.3f + %6.3f + %6.3f\n',  asymmetryparameter, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = dipmagnitude_line.slope * f_logkhz     + dipmagnitude_line.constant;
for n=1:4; normalcontribution(n) = dipmagnitude_normal(n).mag * normpdf(f_logkhz, dipmagnitude_normal(n).mu, dipmagnitude_normal(n).std);end;
dipmagnitude = linearcontribution + sum(normalcontribution(1:4));
if verboseoption >=1 
    fprintf('dip mag =      %6.3f = %6.3f + %6.3f + %6.3f + %6.3f + %6.3f\n',  dipmagnitude, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = dipmu_line.slope * f_logkhz            + dipmu_line.constant;
for n=1:4; normalcontribution(n) = dipmu_normal(n).mag * normpdf(f_logkhz, dipmu_normal(n).mu, dipmu_normal(n).std); end;
dipmu = linearcontribution + sum(normalcontribution(1:4));
if verboseoption >=1 
    fprintf('dip mu =       %6.3f = %6.3f + %6.3f + %6.3f + %6.3f + %6.3f\n',  dipmu, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = dipstd_line.slope * f_logkhz           + dipstd_line.constant;
for n=1:4; normalcontribution(n) = dipstd_normal(n).mag * normpdf(f_logkhz, dipstd_normal(n).mu, dipstd_normal(n).std); end;
dipstd = linearcontribution + sum(normalcontribution(1:4));
if verboseoption >=1 
    fprintf('dip std =      %6.3f = %6.3f + %6.3f + %6.3f + %6.3f + %6.3f\n',  dipstd, linearcontribution, normalcontribution(1), normalcontribution(2), normalcontribution(3), normalcontribution(4));
end;

linearcontribution = 0;
normalcontribution = fivekhzperturb_magnitude.mag * normpdf(f_logkhz, fivekhzperturb_magnitude.mu, fivekhzperturb_magnitude.std);
fivekhzmagnitude = linearcontribution + normalcontribution;
if verboseoption >=1 
    fprintf('fivekHz        %6.3f = %6.3f + %6.3f \n',  fivekhzmagnitude, linearcontribution, normalcontribution(1));
end;


% store for output
parameters.primarymagnitude = primarymagnitude;
parameters.asymmetry        = asymmetryparameter;
parameters.dipmagnitude     = dipmagnitude;
parameters.dipmu            = dipmu;
parameters.dipstd           = dipstd;
parameters.fivekhzmagnitude = fivekhzmagnitude;

% .. and then use them to get the ILD ...
primarysinusoid = primarymagnitude * sin(a_rads);
asymmetry       = asymmetryparameter * sin(2*a_rads) + 1;
dip             = dipmagnitude * normpdf(a_rads, dipmu, dipstd);
fivekhz         = fivekhzmagnitude * normpdf(a_rads, fivekhzperturb_mu, fivekhzperturb_std);

ild_db = primarysinusoid * asymmetry + dip + fivekhz;

if verboseoption >=1 
    fprintf('ILD =          %6.3f * %6.3f + %6.3f + %6.3f\n', primarysinusoid, asymmetry, dip, fivekhz);
    fprintf('ILD =         %5.2f dB\n', ild_db);
    fprintf('\n');
end;

testdata_file.save('ild_db'); 
