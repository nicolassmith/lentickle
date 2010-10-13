% makes intensity noise coupling plots for various offsets

setupLentickle;

f_numpoints = 200;
f_upperLimit = 5000;
f_lowerLimit = 20;

olcl = 'cl'; %closed loop or open loop

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints).';

inPower = 8;

offsets = [.1 5 10 15 20];%[ 1 -20 -10 -7 7 10 20 ];
offsets = offsets*1e-12;

Nplot = length(offsets);

clear sensors
sensors{Nplot} = [];

for kk = 1:Nplot
    switch kk
        case 1
            sensors{kk} = 'asq';
        otherwise
            sensors{kk} = 'omc';
    end
end

clear result TF
TF{Nplot} = [];

for kk = 1:Nplot
    result(kk) = getEligoResults(f,inPower,offsets(kk),sensors{kk});
    switch sensors{kk}
        case 'asq'
            calASQ_DARMm = 1./((pickleTF(result(kk),'EX','AS_Q',olcl)-pickleTF(result(kk),'EY','AS_Q',olcl)));
            TF{kk} = [f,calTF(pickleTF(result(kk),'Mod1.amp','AS_Q',olcl),calASQ_DARMm)];
        case 'omc'
            calOMC_DARMm = 1./((pickleTF(result(kk),'EX','OMC_PD',olcl)-pickleTF(result(kk),'EY','OMC_PD',olcl)));
            TF{kk} = [f,calTF(pickleTF(result(kk),'Mod1.amp','OMC_PD',olcl),calOMC_DARMm)];
    end
end

figure(23)
SRSbode(TF{:})

% build legend

clear TFleg
TFleg{Nplot} = [];
for kk = 1:Nplot
    switch sensors{kk}
        case 'asq'
            TFleg{kk} = 'RF';
        case 'omc'
            TFleg{kk} = 'DC';
    end
    
    TFleg{kk} = [TFleg{kk} ' ' num2str(offsets(kk)*1e12) 'pm'];
end

legend(TFleg{:})
title('Oscillator Amplitude Noise Coupling')
ylabel('Magnitude (m/RIN)')