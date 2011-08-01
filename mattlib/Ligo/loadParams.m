% load LinLIGO parameters from a conlog file
%
% [p, nameList, sval] = loadParams(fileName, ifoName, tGPS)

function [p, nameList, sval] = loadParams(fileName, ifoName, tGPS)

% generic filter bank channels
fbChans = {'GAIN'; 'LIMIT'; 'SW1R'; 'SW2R'};

% ######## Generic Photodiode Channels
% digital
dpdChans = [strcat('I_', fbChans); strcat('Q_', fbChans); {'Phase'}];

% analog
aphChans = {'WhiteGainIn'; 'AABypass'};
apdChans = [strcat('I_', aphChans); strcat('Q_', aphChans)];

% analog, but with screwy WhiteGainIn name
bphChans = {'WhiteGainIn.'; 'AABypass'};
bpdChans = [strcat('I_', bphChans); strcat('Q_', bphChans)];

% ######## Specific Photodiodes
% channels for AS PDs
as1Chans = [strcat('AS1_', dpdChans); strcat('ASPD1', apdChans)];
as2Chans = [strcat('AS2_', dpdChans); strcat('ASPD2', apdChans)];
as3Chans = [strcat('AS3_', dpdChans); strcat('ASPD3', bpdChans)];
as4Chans = [strcat('AS4_', dpdChans); strcat('ASPD4', bpdChans)];
as5Chans = [strcat('AS5_', dpdChans); strcat('ASPD5', apdChans)];
asChans = [as1Chans; as2Chans; as3Chans; as4Chans; as5Chans
           matrixChans('AS_INMATRIX_I', 1:5, [])
           matrixChans('AS_INMATRIX_Q', 1:5, [])];

% channels for POB PDs
pob1Chans = [strcat('POB1_', dpdChans); strcat('POBPD1', apdChans)];
pob2Chans = [strcat('POB2_', dpdChans); strcat('POBPD2', apdChans)];
pobChans = [pob1Chans; pob2Chans
            matrixChans('POB_INMATRIX_I', 1:2, [])
            matrixChans('POB_INMATRIX_Q', 1:2, [])];

% channels for REFL PDs
refl1Chans = [strcat('REFL1_', dpdChans); strcat('REFLPD1', apdChans)];
refl2Chans = [strcat('REFL2_', dpdChans); strcat('REFLPD2', apdChans)];
reflChans = [refl1Chans; refl2Chans
             matrixChans('REFL_INMATRIX_I', 1:2, [])
             matrixChans('REFL_INMATRIX_Q', 1:2, [])];

% ######## LSC Control Filters and Matrices
lscFiltChans = [strcat('DARM_', fbChans); strcat('MICH_', fbChans)
                strcat('PRC_', fbChans); strcat('CARM_', fbChans)
                {'FE_SERVO_ENABLER'; 'FE_MODE'}
                matrixChans('ITMTRX_', 0:3, 0:5)
                matrixChans('BTMTRX_', 0:5, 0:5)];

% ######## ASC Control Filters and Matrices
% WFS quadrant sensors neglected here
ascFiltChans = [strcat('WFS1_PIT_', fbChans); strcat('WFS1_YAW_', fbChans)
                strcat('WFS2A_PIT_', fbChans); strcat('WFS2A_YAW_', fbChans)
                strcat('WFS2B_PIT_', fbChans); strcat('WFS2B_YAW_', fbChans)
                strcat('WFS3_PIT_', fbChans); strcat('WFS3_YAW_', fbChans)
                strcat('WFS4_PIT_', fbChans); strcat('WFS4_YAW_', fbChans)
                strcat('QPDX_PIT_', fbChans); strcat('QPDX_YAW_', fbChans)
                strcat('QPDY_PIT_', fbChans); strcat('QPDY_YAW_', fbChans)
                {'WFS_Gain_Slider'; 'QPD_Gain_Slider'}
                matrixChans('WFS_MP', 1:12, 1:8)
                matrixChans('WFS_MY', 1:12, 1:8)];

gainChans = {'PK'; 'YK'};
ascGainChans = [strcat('ETMX_', gainChans); strcat('ETMY_', gainChans)
                strcat('ITMX_', gainChans); strcat('ITMY_', gainChans)
                strcat('RM_', gainChans); strcat('BS_', gainChans)];

% ######## Generic Suspension Channels
susInChans = [strcat('LSC_', fbChans); strcat('SUSPOS_', fbChans)
              strcat('ASCPIT_', fbChans); strcat('SUSPIT_', fbChans)
              strcat('ASCYAW_', fbChans); strcat('SUSYAW_', fbChans)];
hardChans = {'MODE_SW1R'; 'DEWHITE_SW1R'};
opLevChans = [strcat('OL1_', fbChans); strcat('OL2_', fbChans)
              strcat('OL3_', fbChans); strcat('OL4_', fbChans)
              strcat('OLPIT_', fbChans); strcat('OLYAW_', fbChans)];
coilChans = [strcat('POS_', fbChans); strcat('PIT_', fbChans)
             strcat('YAW_', fbChans); strcat('COIL_', fbChans)
             strcat('SEN_', fbChans)];
susChans = [susInChans; opLevChans; hardChans; strcat('SDSEN_', fbChans)
            strcat('UL', coilChans); strcat('UR', coilChans)
            strcat('LL', coilChans); strcat('LR', coilChans)
            matrixChans('INMATRIX_', 0:2, 0:3)];

% ######## Final Channel List
% real channel names
lscChans = [asChans; pobChans; reflChans; lscFiltChans];
ascChans = [ascFiltChans; ascGainChans];
susChans = [strcat('ETMX_', susChans); strcat('ETMY_', susChans)
            strcat('ITMX_', susChans); strcat('ITMY_', susChans)
            strcat('RM_', susChans); strcat('BS_', susChans)];

chanList = [strcat([ifoName ':LSC-'], lscChans)
            strcat([ifoName ':ASC-'], ascChans)
            strcat([ifoName ':SUS-'], susChans)
            {[ifoName ':IFO-SV_STATE_VECTOR']}];

% field names for struct
lscChans = strrep(lscChans, '.', '');		% remove those pesky periods
lscChans = strrep(lscChans, 'MTRX_', 'MTRX_M');	% ITMTRX and BTMTRX
lscChans = strrep(lscChans, 'SERVO_ENABLER', 'ENABLER');
ascChans = strrep(ascChans, 'Gain_Slider', 'GAIN');

susChans = strrep(susChans, 'MATRIX_', 'MATRIX_M');	% INMATRIX

nameList = [strcat('LSC_', lscChans); strcat('ASC_', ascChans)
            strcat('SUS_', susChans); {'IFO_SV'}];
nameList = strrep(nameList, '_', '.');	% make names have depth

% ######## Read ConLog and Build Parameter Struct
sval = readConLog(fileName, chanList, tGPS);

p.fileName = fileName;
p.ifoName = ifoName;
p.tGPS = tGPS;

% parse and asign to struct
for n = 1:length(sval)
  if( isempty(sval{n}) )
    fprintf('No value for channel %s in %s.\n', chanList{n}, fileName);
  else
    [val, num, err, len] = sscanf(sval{n}, '%f');
    if( num == 1 & len == length(sval{n}) + 1 )
      sval{n} = val;					% numeric value
    elseif( num == 1 & len == length(sval{n}) - 1 & ...
            isequal(' dB', sval{n}(end-2:end)) )
      sval{n} = 10^(val / 20);				% value in dB
    else
      switch sval{n}
        case {'On', 'Enable', 'Filter'}			% general ON
          sval{n} = 1;
        case {'Off', 'Disable', 'Bypass'}		% general OFF
          sval{n} = 0;
      end
    end
  end 

  eval(['p.' nameList{n} ' = sval{n};'])
end

% ######## Reduce Matrices
p.LSC.ITMTRX = namedMatrix(p.LSC.ITMTRX, 'M', 0:3, 0:5);
p.LSC.BTMTRX = namedMatrix(p.LSC.BTMTRX, 'M', 0:5, 0:5);
p.LSC.ASI.INMATRIX = namedMatrix(p.LSC.AS.INMATRIX, 'I', 1:4, [])';
p.LSC.ASQ.INMATRIX = namedMatrix(p.LSC.AS.INMATRIX, 'Q', 1:4, [])';
p.LSC.POBI.INMATRIX = namedMatrix(p.LSC.POB.INMATRIX, 'I', 1:2, [])';
p.LSC.POBQ.INMATRIX = namedMatrix(p.LSC.POB.INMATRIX, 'Q', 1:2, [])';
p.LSC.REFLI.INMATRIX = namedMatrix(p.LSC.REFL.INMATRIX, 'I', 1:2, [])';
p.LSC.REFLQ.INMATRIX = namedMatrix(p.LSC.REFL.INMATRIX, 'Q', 1:2, [])';

p.ASC.WFS.MP = namedMatrix(p.ASC.WFS, 'MP', 1:12, 1:8);
p.ASC.WFS.MY = namedMatrix(p.ASC.WFS, 'MY', 1:12, 1:8);

p.SUS.ETMX.INMATRIX = namedMatrix(p.SUS.ETMX.INMATRIX, 'M', 0:2, 0:3);
p.SUS.ETMY.INMATRIX = namedMatrix(p.SUS.ETMY.INMATRIX, 'M', 0:2, 0:3);
p.SUS.ITMX.INMATRIX = namedMatrix(p.SUS.ITMX.INMATRIX, 'M', 0:2, 0:3);
p.SUS.ITMY.INMATRIX = namedMatrix(p.SUS.ITMY.INMATRIX, 'M', 0:2, 0:3);
p.SUS.RM.INMATRIX = namedMatrix(p.SUS.RM.INMATRIX, 'M', 0:2, 0:3);
p.SUS.BS.INMATRIX = namedMatrix(p.SUS.BS.INMATRIX, 'M', 0:2, 0:3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% matrixChans
function chanList = matrixChans(name, jn, jm)

  N = length(jn);
  M = length(jm);

  if( M == 0 )
    chanList = cell(N, 1);
    for n = 1:N
      chanList{n} = [name, j2str(jn(n))];
    end
  else
    chanList = cell(N * M, 1);
    for m = 1:M
      for n = 1:N
        chanList{(m - 1) * N + n} = [name, j2str(jn(n)), j2str(jm(m))];
      end
    end
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% namedMatrix
function val = namedMatrix(p, name, jn, jm)

  N = length(jn);
  M = length(jm);

  if( M == 0 )
    val = zeros(N, 1);
    for n = 1:N
      val(n) = p.([name, j2str(jn(n))]);
    end
  else
    val = zeros(N, M);
    for m = 1:M
      for n = 1:N
        val(n, m) = p.([name, j2str(jn(n)), j2str(jm(m))]);
      end
    end
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% j2str
function str = j2str(j)
  str = lower(dec2hex(j));

