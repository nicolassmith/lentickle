% view contents of a filter bank
%  if a return value is specified, filter editing is allowed
%
% Example:
% viewFilter(pLog, pFilt, 'SUS-ETMX_SUSPOS');		% no editing
% pLog = viewFilter(pLog, pFilt, 'LSC-DARM');		% with editing
%
% Function Form:
% pLog = viewFilter(pLog, pFilt, name);
% pLog = viewFilter(pLog, pFilt, name, f);

function pLog = viewFilter(pLog, pFilt, name, varargin)

  % get filter data
  [pl, lstr] = findField(pLog, name);
  [pf, fstr] = findField(pFilt, name);

  %eval(['pl = pLog' lstr ';']);
  %eval(['pf = pFilt' fstr ';']);

  % determine frequency vector
  if( isempty(varargin) )
    f = logspace(-1, log10(pf(1).fs / 2.1), 600);
  else
    f = varargin{1};
  end

  % make button structs
  btn = struct('name', [], 'x', [], 'y', [], 'bit', []);
  btn1 = repmat(btn, 7, 1);
  btn2 = repmat(btn, 5, 1);

  [btn1.x] = deal(0, 1, 2, 3, 4, 5, 1);
  [btn1.y] = deal(0.5, 1, 1, 1, 1, 1, 0);
  [btn1.bit] = deal(3, 6, 8, 10, 12, 14, 16);
  btn1(1).name = 'ON/OFF';
  for n = 2:7
    btn1(n).name = pf(n - 1).name;
  end

  [btn2.x] = deal(2, 3, 4, 5, 7);
  [btn2.y] = deal(0, 0, 0, 0, 0.5);
  [btn2.bit] = deal(2, 4, 6, 8, 10);
  btn2(5).name = 'ON/OFF';
  for n = 1:4
    btn2(n).name = pf(n + 6).name;
  end

  % plot and take input
  if( nargout == 0 )
    drawFB(f, pl, pf, btn1, btn2, name);
  else
    fprintf(1, 'Press enter in figure window when done...')

    gtxt = drawFB(f, pl, pf, btn1, btn2, name);
    [pl, c] = processInput(pl, pf, btn1, btn2, gtxt);
    while( c )
      gtxt = drawFB(f, pl, pf, btn1, btn2, name);
      [pl, c] = processInput(pl, pf, btn1, btn2, gtxt);
    end

    % replace log data
    eval(['pLog' lstr ' = pl;']);
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pl, c] = processInput(pl, pf, btn1, btn2, gtxt)

  % get input
  [x, y] = ginput(1);
  if( isempty(x) )
    c = 0;
    return;
  end
  c = 1;

  % look for button hit
  for n = 1:7
    val = ~bitget(pl.SW1R, btn1(n).bit);
    if( x > btn1(n).x & x < btn1(n).x + 1 & ...
        y > btn1(n).y & y < btn1(n).y + 0.5 )
      pl.SW1R = bitset(pl.SW1R, btn1(n).bit, val);
    end
  end
  for n = 1:5
    val = ~bitget(pl.SW2R, btn2(n).bit);
    if( x > btn2(n).x & x < btn2(n).x + 1 & ...
        y > btn2(n).y & y < btn2(n).y + 0.5 )
      pl.SW2R = bitset(pl.SW2R, btn2(n).bit, val);
    end
  end

  % look for gain hit
  if( x > 6 & x < 7 & y > 0.3 & y < 0.8 )
    gstr = inputdlg('New Gain:', 'Filter Gain Adjust',1,{num2str(pl.GAIN)});
    if( ~isempty(gstr) )
      g = str2double(gstr{1});
      if( isfinite(g) )
        pl.GAIN = g;
      end
    end
  end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gtxt = drawFB(f, pl, pf, btn1, btn2, name)

  clf

  % draw buttons
  subplot(3, 1, 1);
  axis([0 8 0 2])
  axis off
  title(escformat(name))

  for n = 1:7
    drawBtn(btn1(n), pl.SW1R);
  end
  for n = 1:5
    drawBtn(btn2(n), pl.SW2R);
  end

  % draw gain
  patch(6 + [0 0 1], 0.25 + [0.1 0.9 0.5], 0.5 * [1 1 1]);
  gtxt = stext(6.1, 0.9, 0.6, 0.4, num2str(pl.GAIN));

  % compute response
  h = getFilterTf(f, pl, pf);

  % plot magnitude
  subplot(3, 1, 2)
  loglog(f, abs(h))
  ylabel('magnitude')
  grid on
  if( nargout == 1 )
    title('Click on a filter module, or press enter when done...');
  end

  % plot phase
  subplot(3, 1, 3)
  semilogx(f, 180 * angle(h) / pi)
  ylabel('phase (degrees)')
  grid on
  title(sprintf('Gain of %f at %f Hz', abs(h(1)), f(1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawBtn(btn, bits)

  txtarg = {'Interpreter', 'none'};
  stext(btn.x + 0.05, 0.95, btn.y + 0.5, .5, btn.name, txtarg{:});

  if( bitget(bits, btn.bit) )
    patch(btn.x + [0 1 1 0], btn.y + [0 0 0.5 0.5], 'g');
  else
    patch(btn.x + [0 1 1 0], btn.y + [0 0 0.5 0.5], 'r');
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = stext(x, dx, y, dy, str, varargin)

  txtarg = {'FontUnits', 'normalized', ...
            'VerticalAlignment', 'bottom'};
  h = text(x, y, str, txtarg{:}, varargin{:});

  % adjust fond size
  ex = get(h, 'Extent');
  fs = get(h, 'FontSize');
  sc = max(ex(3:4) / [dx, dy]);
  while( any(ex(3:4) > [dx, dy]) & fs > 0 )
    fs = fs / sc;
    sc = 1.2;
    set(h, 'FontSize', fs);
    ex = get(h, 'Extent');
  end


  % adjust position
  x = 2 * x - ex(1);
  y = 2 * y - ex(2);
  set(h, 'Position', [x, y, 0]);
