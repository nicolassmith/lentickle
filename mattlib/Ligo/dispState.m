% display IFO state
%
%

function dispConf(sv)

strs = repmat(struct('name', [], 'on', 'on', 'off', 'off'), 16, 1);

strs(1).name = 'OPERATOR';
strs(1).on = 'GO';
strs(1).off = 'NO GO';

strs(2).name = 'CONLOG';
strs(2).on = 'Stable';
strs(2).off = 'Modification';

strs(3).name = 'PSL';
strs(3).on = 'OK';
strs(3).off = 'Not OK';

strs(4).name = 'Common Mode';
strs(4).on = 'CommonMode';
strs(4).off = 'Not CM';

strs(5).name = 'LSC ASC';
strs(5).on = 'OK';
strs(5).off = 'Not OK';

strs(6).name = 'LOCK';
strs(6).on = 'Locked!';
strs(6).off = 'Not Locked';

strs(7).name = 'EXCITATION';
strs(7).on = 'OK';
strs(7).off = 'Exitations!';

strs(8).name = 'MC';
strs(8).on = 'Locked';
strs(8).off = 'Not Locked';

strs(9).name = 'Activity';
strs(9).on = 'Science';
strs(9).off = 'Not Science';

strs(10).name = 'UP';
strs(10).on = 'UP';
strs(10).off = 'Not UP';

for n = 1:16
  if( isempty(strs(n).name) )
    strs(n).name = ['bit ' int2str(n - 1)];
  end
end

for n = 1:16
  if( bitget(sv, n) )
    fprintf(1, '%s - %s\n', strs(n).name, strs(n).on);
  else
    fprintf(1, '%s - %s\n', strs(n).name, strs(n).off);
  end
end
