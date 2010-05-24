function TFout = calTF(TFin,TFnumerator,TFdenominator)
    % calibtrates a transfer function
    %
    %   TFout = calTF(TFin,TFnumerator,TFdenominator)
    %
    %   Each element in TFout is multiplied by the corresponding element
    %   in TFnumerator and divided by the corresponding element in
    %   TF denominator. Can be used with only 2 arguments and TFdenominator
    %   is considered to be unity.
    
    if nargin<3
        TFdenominator = 1;
    end
    
    TFout = TFin .* TFnumerator ./ TFdenominator;    
end