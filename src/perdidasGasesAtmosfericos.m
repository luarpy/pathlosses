% Autor: Luar Biurrun-Lorda
% Perdidas_gasesatmosfericos
%   Agas = perdidasGasesAtmosfericos(FREQ,TEMP,HUMEDAD,DISTANCIA)
%   [Agas, gamma_O, gamma_H2O] = perdidasGasesAtmosfericos(FREQ,TEMP,HUMEDAD,DISTANCIA)
%     FREQ (Hz)
%     TEMP (ºC) 
%     HUMEDAD (%) escalado de 0 a 1
%     DISTANCIA (m)

function [Agas, varargout] = perdidasGasesAtmosfericos(freq, temp, humedad,d)
  d = d/1000; % Cambia el valor de la distancia de m a km
  freq = freq/(10^9); % Se transforma a GHz

  if isnumeric(temp) else error('TEMP erronea, introduce una temperatura en grados centrigrados'); end
  if isnumeric(humedad) else error('HUMEDAD erronea, introduce el porcentaje de humedad '); end 
  if isnumeric(d) else error('DIST erronea, introduce una distancia en metros'); end

  %Cálculos
  pw_sat = 5.02 + 0.323*temp + 8.18*(10^(-3))*temp^2 + 3.12*(10^(-4))*temp^3 % Desidad de vapor de agua (saturacion) (g/m3)
  pw = humedad*pw_sat % Densidad de vapor de agua (g/m3)
  if freq <= 57*10^9
    gamma_O =  ((7.19*10^(-3) + 6.09/(freq^2 + 0.227) + 4.81/((freq - 57)^2 + 1.5))*freq^2)*10^(-3);
  elseif  57*10^9 < freq && freq < 63*10^9
    gamma_O = -0.024*(freq^3 - 160.82*freq^2 + 8482*freq - 146598);
  else 
    gamma_O = (((3.79*10^(-7))*freq + 0.265/((f - 63)^2 + 1.59) + 0.028/((freq - 118)^2 + 1.47))*(freq + 198)^2)*10^(-3);
  end
  gamma_O;
  gamma_H2O = ((0.05 + 0.0021*pw + (3.6/((freq - 22.235)^2 + 8.5)) + (10.6/((freq - 183.31)^2 + 9)) + (8.9/((freq - 325.4)^2 + 26.3)))*pw*(freq^2))*10^(-4);

  if nargout > 1
    varargout{1} = gamma_O;
    varargout{2} = gamma_H2O;
  end
  gamma_O
  gamma_H2O
  Agas = (gamma_O + gamma_H2O)*d;  %Perdidas por gases atmosfericos  
end
