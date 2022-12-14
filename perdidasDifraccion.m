%   AUTOR: Luar Biurrun-Lorda
%
%   Perdidas_difraccion:
%     Perdidas = Perdidas_difraccion(freq, dist, altura_TX, altura_RX) dB
%     FREQ (Hz) = frecuencia, DIST (m) = distancia
%     ALTURA TX (m) = altura del emisor
%     ALTURA RX altura del receptor
%
%     Perdidas = Perdidas_difraccion(freq, dist, altura_TX, pola, tipo_enlace, fresnel, R_tierra, velPropa, k) dB
%     POLARIZACIÓN = 'vertical', 'horizontal'
%     TIPO ENLACE = 'tierra', 'mar'
%     ZONA FRESNEL = por defecto será 4/3
%     RADIO TIERRA (m) = sin entrada será 6371 km 
%     VELOCIDAD PROPAGACIÓN (m/s) = por defecto será 3*10^8 m/s
%     Epsilonr 
%     Sigma

function perdidas = Perdidas_difraccion (freq, dist, altura_TX, altura_RX, varargin)
  velPropa = 3*10^8;
  R_tierra = 6371*10^3;
  primera_zona_fresnel = 0.7;
  zona_fresnel = primera_zona_fresnel;
  k_value = false;
  pola = ' ';
  tipo_enlace = ' ';
  % Comprueba los argumentos que no son por defecto
  if nargin > 0
    for i = 1:length(varargin) % Hago el for porque sino saldrían errores de exceder un array
      switch (varargin{i})
        case { ischar(varargin{i} && i == 1)}
          pola = varargin{i};
          if !strcmp(pola,'vertical') && !strcmp(pola,'horizontal') && !strcmp(pola,'circular')
            error('Polarización desconocida!');
          end
        case { ischar(varargin{i} && i == 2)}
          tipo_enlace = varargin{i};
          if !strcmp(tipo_enlace,'tierra') && !strcmp(tipo_enlace,'mar')
            warning('Enlace desconocido!');
          end
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
            zona_Fresnel = varargin{i};       
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
          R_tierra = varargin{i};     
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
          velPropa = varargin{i};  
      case {(isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')) && (isa(varargin{i+1}, 'double') isa(varargin{i+1}, 'integer') isa(varargin{i+1}, 'float'))}        
          Req = zona_fresnel*R_tierra;
          kh = 0.36*(Req*freq)^(-1/3)*((epsilonr - 1)^2 + (18000*sigma/freq)^2)^(-1/4);
          kv = kh*(epsilonr^2 + (18000*sigma/freq)^2)^0.5;
          k_value = true;
      end
    end
  end
  % Cálculo
  lambda = velPropa/freq;
  Req = zona_fresnel*R_tierra;
  switch (pola)
    case {'vertical'}
      k = kv;
      tau = 90;
    case {'horizontal'}
      k = kh;
      tau = 0;
    otherwise
      tau = 45;
      k = (kh + kv + (kh - kv)*(cosd(theta)^2)*cosd(2*tau))/2;
  end
  
  if strcmp(pola,'vertical')
    if (freq > 20*10^6 & strcmp(tipo_enlace, 'tierra')) || (freq > 300*10^6 && strcmp(tipo_enlace, 'mar'))
      Beta = 1;
    end
  elseif strcmp(pola, 'horizontal')
    Beta = 1;
  else
    Beta = (1+1.6*k^2+0.67*k^4)/(1+4.5*k^2+1.53*k^4);
  end
  X = Beta*dist*(pi/(lambda*Req^2))^(1/3);
  aux = 2*Beta*(pi^2/(lambda^2*Req))^(1/3);
  YTx = altura_TX*aux;
  YRx = altura_RX*aux;
  if X >= 1.6
    Fx = 11 + 10*log10(X) - 17.6*X;
  else 
    Fx = -20*log10(X) - 5.6488*X^1.425;
  end
  BRx = Beta*YRx;
  BTx = Beta*YTx;
  if BRx > 2 || BTx > 2
    GyRx = 17.6*(BRx-1.1)^(1/2) - 5*log10(BRx - 1.1) - 8;
    GyTx = 17.6*(BTx-1.1)^(1/2) - 5*log10(BTx - 1.1) - 8;
  else
    GyRx = 10*log10(BRx + 0.1*BRx^3);
    GyTx = 10*log10(BTx + 0.1*BTx^3);
  end
  if k_value
    tmp = 2 + 20*log10(k);
    if Gy < tmp
      GyTx = tmp;
      GyRx = tmp;
    end
  end
  Ld = -Fx - GyRx - GyTx;
  perdidas = Ld;
  
end
