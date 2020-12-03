% Generate ILD look up table

freq_hz = [150,  188.98815748,  238.1101578,  300, 377.97631497,  476.22031559,  600,  755.95262994, ...
        952.44063118, 1200, 1511.90525987, 1904.88126236, 2400, 3023.81051975, 3809.76252472]

HRIRsids = [0:7.5:172.5 -180:7.5:-7.5];

output = zeros(length(HRIRsids),length(freq_hz));

for f = 1:length(freq_hz)
    for az = 1:length(HRIRsids)
        azimuth_degs = HRIRsids(az);
        freq = freq_hz(f);
        [ild_db, parameters] = mparametricild(freq, azimuth_degs, 0);
        output(az,f) = ild_db;
    end
end

[ild_db, parameters] = mparametricild(150, 0, 0);
if output(1,1) == ild_db == 0
    print('Error');
end

save('ILDs_mparametric_v0.mat','output');


