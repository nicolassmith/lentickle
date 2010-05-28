% makes intensity noise coupling plots for various offsets

setupLentickle;

f_numpoints = 1000;
f_upperLimit = 7500;
f_lowerLimit = 10;

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints).';

inPower = 8;

offsets = [ 1 -15 -7 7 15 ]*1e-12;

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
            calASQ_DARMm = 1./((pickleTF(result(kk),'EX','AS_Q','cl')-pickleTF(result(kk),'EY','AS_Q','cl'))/2);
            TF{kk} = [f,calTF(pickleTF(result(kk),'AM','AS_Q','cl'),calASQ_DARMm)];
        case 'omc'
            calOMC_DARMm = 1./((pickleTF(result(kk),'EX','OMC_PD','cl')-pickleTF(result(kk),'EY','OMC_PD','cl'))/2);
            TF{kk} = [f,calTF(pickleTF(result(kk),'AM','OMC_PD','cl'),calOMC_DARMm)];
    end
end

figure(22)
SRSbode(TF{:})
legend('RF 1pm','DC -15pm','DC -7pm','DC 7pm','DC 15pm');%,'DC 10pm','DC 20pm')