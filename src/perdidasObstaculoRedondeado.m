%   AUTOR: Luar Biurrun-Lorda
%   Perdidas_obstaculo_redondeado:
%     Perdidas = Perdidas_obstaculo_redondeado(freq, d1, d2, oclusion, R_obstaculo) dB
%     FREQ (Hz) = frecuencia
%     D1 (m) = distancia hasta el punto de oclusion
%     D2 (m) = distancia hasta el punto de oclusion
%     OCLUSION (m) = altura de oclusión23
%     R_OBSTACULO (m) = radio del objeto
%
%     Perdidas = Perdidas_obstaculo_redondeado(freq, d1, d2, R_tierra, velPropa) dB
%     ZONA FRESNEL = por defecto será 4/3
%     LIMITE PERDIDAS DIFRACCION = por defecto -0.78
%     RADIO TIERRA (m) = por defecto 6371 km 
%     VELOCIDAD PROPAGACIÓN (m/s) = por defecto 3*10^8 m/s


function perdidas = Perdidas_obstaculo_redondeado (freq, d1, d2, oclusion,R_obstaculo, varargin)
  primera_zona_fresnel = 0.7;
  limite_perdidas_difraccion = -0.78;
  velPropa = 3*10^8;
  R_tierra = 6371*10^3;
  zona_Fresnel = primera_zona_fresnel;
  if nargin > 0
    for i = 1:length(varargin)
      switch (varargin{i})  
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
          zona_Fresnel = varargin{i};    
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
          limite_perdidas_difraccion = varargin{i};  
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
          R_tierra = varargin{i};     
        case {isa(varargin{i}, 'double') isa(varargin{i}, 'integer') isa(varargin{i}, 'float')}
          velPropa = varargin{i};
        otherwise
          warning('Valor inválido para argumento:');
          warning(varargin);
          return
      end
    end
  end
  % Calculo
  lambda = velPropa/freq;
  R_normalizado = sqrt(lambda*d1*d2/(d1 + d2));
  hipo1 = sqrt(oclusion^2 + d1^2);
  hipo2 = sqrt(oclusion^2 + d2^2);
  aux = pi*R_obstaculo/lambda;
  m = R_obstaculo*((hipo1+hipo2)/(hipo1*hipo2))/(aux^(1/3));
  n = oclusion*aux^(2/3)/R_obstaculo;
  tmp = m*n;
  if tmp > 4
    T = -6 - 20*log10(tmp) + 7.2*sqrt(2) - (2 - 17*n)*m + 3.6*m^(3/2) - 0.8*m^2;
  else
    T = 7.2*sqrt(m) - (2 - 12.5*n)*m + 3.6*m^(3/2) - 0.8*m^2;
  end
  Ld = Perdidas_obstaculo_agudo(freq, d1, d2, oclusion, limite_perdidas_difraccion, R_tierra, velPropa) + T;
  perdidas = Ld;
end
