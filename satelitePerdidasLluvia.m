%   A_001 = satelitePerdidasLluvia (freq, kh, kv, ah, av, theta, pola, R_001, hs, hr, d) dB
%     FREQ (Hz)
%     Kh, Kv, ah y av = parámetros del vano. Nos los tienen que dar
%     THETHA (º ) = Ángulo de elevación
%     POLA = Polarización: 'circular', 'vertical' o 'horizontal'
%     R_001 (mm/h) 
%     hs (m) 
%     hr (m)
%     DIST (m) = Distancia del vano
%
%   [A_001, Ap, C0, C1, C2, C3] = satelitePerdidasLluvia(freq, porcent, kh, kv, ah, av, theta, pola, R_001, hs, hr, d, porcent, L) dB
%     ...
%     PORCENT (%) = Tiempo de enlace indisponible por lluvia. Entre 0 y 1
%     L (º ) = Latitud
%     Ap = Pérdidas para porcentage que no sea el 0.01%
function [A_001, varargout] = satelitePerdidasLluvia (freq, kh, kv, ah, av, theta, pola, R_001, hs, hr, d, varargin)
  porcent = 0;
  L = 0;
  switch(nargin)
    case{12}
      porcent = varargin{1};
    case {13}
      porcent = varargin{1};
      L = varargin{2};
  end
  switch (pola)
    case {'vertical'}
      k = kv;
      a = av;
      tau = 90;
    case {'horizontal'}
      a = ah;
      k = kh;
      tau = 0;
    otherwise
      tau = 45;
      k = (kh + kv + (kh - kv)*(cosd(theta)^2)*cosd(2*tau))/2;
      a = (kh*ah + kv*av + (kh*ah - kv*av)*(cosd(theta)^2)*cosd(2*tau))/(2*k);
  end
  d = d/1000; % Escala de metros a kilometros la distancia de entrada
  freq = freq/(10^9); % Escala a GHz la frecuencia de entrada en Hz
  Ls = sateliteDistanciaLluvia(hr, hs, theta);
  r001 = 1/(1 + Ls/(35*exp(-0.015*R_001))*cosd(theta));
  Lefec = Ls*r001 % km
  gamma_r = k*R_001^a;
  A_001 = gamma_r*Lefec;
  if porcent != 0.01
    if porcent >= 1 && abs(L) >= 36
      BETA = 0;
    elseif  porcent < 1 && abs(L) < 36 && theta >= 25
      BETA = -0.005*(abs(L)-36);
    else
      BETA = -0.005*(abs(L)-36)+1.8-4.25*sind(theta);
    end
    Ap = A_001*(porcent/0.001)^(-(0.655 + 0.033*ln(porcent) - 0.045*ln(A_001) - BETA*(1 - porcent)*sind(theta)));
  end
  r001
  gamma_r
  BETA
  if nargout > 1
    if 10 <= freq 
      C0 = 0.12 + 0.32*log10(freq/10);
    else
      C0 = 0.12;
    end
    C1 = (0.07^C0)*0.12^(1 - C0);
    C2 = 0.855*C0 + 0.546*(1 - C0);
    C3 = 0.139*C0 + 0.043*(1 - C0);
%    Av = 300*Ah/(335 + Ah);
%    Ah = 335*Av/(300 + Av);
    varargout{1} = Ap;
    varargout{2} = C0;
    varargout{3} = C1;
    varargout{4} = C2;
    varargout{5} = C3;
  end  
endfunction
