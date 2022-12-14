%   Autor: Luar Biurrun-Lorda
%   perdidas = perdidasPropagacion(FREQ, DIST) dB
%     FREQ (Hz)
%     DIST (m)
function perdidas = perdidasPropagacion(freq, d)
  d = d/1000; % Escala a km
  freq = freq/(10^6); % Escala a MHz
  L = 32.5 + 20*log10(freq) + 20*log10(d);
  perdidas = L;
end
