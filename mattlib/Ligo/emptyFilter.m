% return an empty filter bank

function fb = emptyFilter

  fb = struct('name', '<empty>', 'soscoef', [1 0 0 1 0 0], ...
              'fs', 16384, 'design', '<none>');
  fb = repmat(fb, 10, 1);
