% Optickle Configuration files for eLIGO
% paramEligo    : parameters of eLIGO 
% paramEligo_01 : ASC - definition of demodulation phases and gouy phases (for tickle01)
% paramEligo_00 : LSC - definition of demodulation phases (for tickle)
% optEligo      : optical model, it has the parameters in paramEligo as argument
% probesEligo_01: probes (for tickle 01)
% probesEligo_00: probes (for tickle)

% cfg for LSC

par = paramH1;

par = setPower(par,8);

par = paramEligo_00(par);
opt = optEligo(par);
opt = probesEligo_00(opt, par);


% cfg for ASC 

% par = paramEligo;
% par = paramEligo_01(par);
% opt = optEligo(par);
% opt = probesEligo_01(opt, par);
