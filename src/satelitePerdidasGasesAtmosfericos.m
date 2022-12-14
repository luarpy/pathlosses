%   Agas = satelitePerdidasGasesAtmosfericos (freq, temp, humedad, tetha, hs, d) dB
%     FREQ (Hz)
%     TEMP (ºC) 
%     HUMEDAD (%) escalado de 0 a 1
%     TETHA (º ) = ángulo de elevación
%     hs (m) = altura de estación terrena
%     DISTANCIA (m)
%  Agas = satelitePerdidasGasesAtmosfericos (freq, temp, humedad, tetha, hs, d, gamma_O, gamma_H2O) dB
%     GAMMA_O     si nos los dan, para meterlos directamente 
%     GAMMA_H2O   lo mismo que el anterior

function perdidas = satelitePerdidasGasesAtmosfericos (freq, temp, humedad, tetha, hs, d, varargin)
  hs = hs/1000;
  d = d/1000; % Cambia el valor de la distancia de m a km
  freq = freq/(10^9); % Se transforma a GHz
  pw_sat = 5.02 + 0.323*temp + 8.18*(10^(-3))*temp^2 + 3.12*(10^(-4))*temp^3;  % Desidad de vapor de agua (saturacion) (g/m3)
  pw = humedad*pw_sat; % Densidad de vapor de agua (g/m3)
  if freq <= 57*10^9
    gamma_O =  ((7.19*10^(-3) + 6.09/(freq^2 + 0.227) + 4.81/((freq - 57)^2 + 1.5))*freq^2)*10^(-3);
  elseif  57*10^9 < freq && freq < 63*10^9
    gamma_O = -0.024*(freq^3 - 160.82*freq^2 + 8482*freq - 146598);
  else 
    gamma_O = (((3.79*10^(-7))*freq + 0.265/((f - 63)^2 + 1.59) + 0.028/((freq - 118)^2 + 1.47))*(freq + 198)^2)*10^(-3);
  end
  gamma_H2O = (((0.05) + (0.0021*pw) + (3.6/(((freq - 22.235)^2) + 8.5)) + (10.6/(((freq - 183.31)^2) + 9)) + (8.9/(((freq - 325.4)^2) + 26.3)))*pw*(freq^2))*(10^(-4));

   if nargin == 8
    gamma_O = varargin{1};
    gamma_H2O = varargin{2};
  end
  gamma_O
  gamma_H2O
   if freq < 55 || (freq >= 65 && freq < 116) || (freq >= 122 && freq < 350) 
    h_O = 6; % km
  elseif  55 <= freq && freq < 65
    h_O = 10.7; % km
  elseif 166 <= freq && freq < 122
    h_O = 27.35; % km 
  end
  h_O
  h_H2O = 1.66*(1 + 1.37/((freq-22.235)^2 + 2.53) + 3.33/((freq-183.31)^2 + 4.64) + 1.56/((freq - 325.1)^2 + 2.86))
  Agas = (gamma_O*h_O*exp(-hs/h_O) + gamma_H2O*h_H2O*exp(-hs/h_H2O))/sind(tetha);
  perdidas = Agas;
endfunction
