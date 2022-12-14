%   [A_001, M, C0, C1, C2, C3] = perdidasLluvia(freq, porcent, theta, pola, R_001, d) dB
%     M = Margen de seguridad
%     FREQ (Hz)
%     PORCENT (%) = Tiempo de enlace activo de 0 a 1
%     THETHA (º ) = Ángulo de elevación
%     POLA = Polarización: 'circular', 'vertical' o 'horizontal'
%     R_001 (mm/h) 
%     DIST (m) = Distancia del vano
%     ...
%   [A_001, M, C0, C1, C2, C3] = perdidasLluvia(freq, porcent, theta, pola, R_001, d, kh, kv, ah, av) dB
%     Kh, Kv, ah y av = parámetros del vano. Nos los tienen que dar

function [A_001, varargout] = perdidasLluvia(freq, porcent, theta, pola, R_001, d, varargin)
%        freq kh        ah    kv        av
  coef = [1   0.0000259 0.9691  0.0000308 0.8592,
          6   0.0007056 1.59    0.0004878 1.5728,
          8   0.004115  1.3905  0.00345   1.3797,
          10  0.01217   1.2571  0.01129   1.2156,
          15  0.04481   1.1233  0.05008   1.044,
          20  0.09164   1.0568  0.09611   0.9847,
          30  0.2403    0.9485  0.2291    0.9129,
          40  0.4431    0.8673  0.4274    0.8421,
          60  0.8606    0.7656  0.8515    0.7486,
          80  1.1704    0.7115  1.1668    0.7021,
          100 1.3671    0.6815  1.368     0.6765,
  ];
  if nargin < 6
    for i = 1:size(coef,1)
      if i < size(coef,1) && freq < coef(size(coef,1),1)
        if freq >= coef(i,1) && freq < coef(i+1,1)
          if (freq - coef(i,1)) <= (coef(i+1,1) - freq)
            kh = coef(i,2);
            ah = coef(i,3);
            kv = coef(i,4);
            av = coef(i,5);
            break;
          else
            kh = coef(i+1,2);
            ah = coef(i+1,3);
            kv = coef(i+1,4);
            av = coef(i+1,5);
            break;
          end
        else
          kh = coef(i+1,2);
          ah = coef(i+1,3);
          kv = coef(i+1,4);
          av = coef(i+1,5);
        end
      else
        kh = coef(1,2);
        ah = coef(1,3);
        kv = coef(1,4);
        av = coef(1,5);
        break;
      end
    end
  else
    kh = varargin{1};
    kv = varargin{2};
    ah = varargin{3};
    av = varargin{4};
  end
  
  
  switch (pola)
    case {'vertical'}
      k = kv
      a = av
      tau = 90
    case {'horizontal'}
      a = ah
      k = kh
      tau = 0
    otherwise
      tau = 45
      k = (kh + kv + (kh - kv)*(cosd(theta)^2)*cosd(2*tau))/2
      a = (kh*ah + kv*av + (kh*ah - kv*av)*(cosd(theta)^2)*cosd(2*tau))/(2*k)
  end

  d = d*10^(-3); % Escala de metros a kilometros la distancia de entrada
  freq = freq/(10^9); % Escala a GHz la frecuencia de entrada en Hz

  r001 = 1/(0.477*(d^0.633)*(R_001^(0.073*a))*(freq^0.123) - 10.579*(1 - exp(-0.024*d)))
  Lefec = d*r001 % km
  
  if 10 <= freq 
    C0 = 0.12 + 0.32*log10(freq/10);
  else
    C0 = 0.12;
  end
  C1 = (0.07^C0)*0.12^(1 - C0);
  C2 = 0.855*C0 + 0.546*(1 - C0);
  C3 = 0.139*C0 + 0.043*(1 - C0);

  Yr = k*R_001^a
  A_001 = Yr*Lefec;
  if nargout > 1
    M = A_001*C1*(porcent^(-(C2 + C3*log(porcent))));
  %  Av = 300*Ah/(335 + Ah);
  %  Ah = 335*Av/(300 + Av);
    varargout{1} = M;
    varargout{2} = C0;
    varargout{3} = C1;
    varargout{4} = C2;
    varargout{5} = C3;
  end
end
