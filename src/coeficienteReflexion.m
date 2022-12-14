% coef = coeficienteReflexion (freq, phi, permittivity, conductivity, pola)
%   FREQ (Hz)
%   PHI (º ) = angulo de incidencia en superfcie
%   PERMITTIVITY = permehabilidad de superficie
%   CODUCTIVITY = conductividad de superficie
%   POLA = polarizacion. Opciones: 'horizontal', 'vertical', 'eliptica' o 'circular'
%   ...
% coef = coeficienteReflexion (freq, phi, permittivity, conductivity, pola, 'Tv')
%   Devuelve el coeficiente de TRANSMISIÓN
function coef = coeficienteReflexion (freq, phi, permittivity, conductivity, pola, varargin)
  epsilon0 = 8.85419*10^(-12);
  n2 = sqrt(permittivity - i*conductivity/(2*pi*freq*epsilon0));
  if pola == 'horizontal'
    rv = (sind(phi) - sqrt(n2^2 - cosd(phi)^2))/(sind(phi) + sqrt(n2^2 - cosd(phi)^2));
  elseif pola == 'vertical' || pola == 'circular' || pola == 'eliptica'
    rv = (n2^2*sind(phi) - sqrt(n2^2 - cosd(phi)^2))/(n2^2*sind(phi) + sqrt(n2^2 - cosd(phi)^2));
  else
    error("Polarizacion desconocida. Opciones: 'horizontal', 'vertical', 'eliptica' o 'circular'");
  end  
  if varargin{1} == 'Tv'
    tv = 1 + rv;
    coef = tv;
  else
    coef = rv;
  end
endfunction
