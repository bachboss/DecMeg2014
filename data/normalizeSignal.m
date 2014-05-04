function [signal] = normalizeSignal(signal)
% Transofmration: Smooth
signal = smooth(signal);
% Transformation: De-trend (linear trend)
signal = detrend(signal);            
% Transformation: Amptitude Scaling (+ offet)
signal = (signal - mean(signal)) ./ std(signal);

end