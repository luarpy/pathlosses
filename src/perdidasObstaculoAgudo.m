%   AUTOR: Luar Biurrun-Lorda
%   perdidasObstaculoAgudo:
%     Perdidas = perdidasObstaculoAgudo(freq, d1, d2, oclusion) dB
%     FREQ (Hz) = frecuencia
%     D1 (m) = distancia hasta el punto de incidencia
%     D2 (m) = distancia hasta el punto de incidencia
%     OCLUSION (m) = altura de oclusión23
%
%     Perdidas = perdidasObstaculoAgudo(freq, d1, d2, zona_Fresnel, limite_perdidas_difraccion, R_tierra, velPropa) dB
%     ZONA FRESNEL = por defecto será 4/3
%     LIMITE PERDIDAS DIFRACCION = por defecto -0.78
%     RADIO TIERRA (m) = por defecto 6371 km 
%     VELOCIDAD PROPAGACIÓN (m/s) = por defecto 3*10^8 m/s

function perdidas = perdidasObstaculoAgudo (freq, d1, d2, oclusion, varargin)
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
      end
    end
  end
  
  lambda = velPropa/freq;
  R_normalizado = sqrt(lambda*d1*d2/(d1 + d2));
  % Cálculo
  tmp = oclusion/R_normalizado;
  if  tmp > limite_perdidas_difraccion
    v = sqrt(2)*tmp
  else
  v = oclusion*sqrt((2/lambda)*d1^(-1) + d2^(-1))
  end
  
  Ld = 6.9 + 20*log10(sqrt((v-0.1)^2 + 1) + v - 0.1);
  perdidas = Ld;
end
