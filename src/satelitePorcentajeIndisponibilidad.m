

% Autor: Luar Biurrun-Lorda
%
%   [ WARNING: sólo vale para calcular indisponibilidad en radioenlaces terrestres ]
%   log10porcent = porcentajeIndisponibilidad(A001, M, C0, C1, C2, C3, aux, aux_value) %
%       A001 (dB)
%       THETA (º ) = elevación
%       aux = 'beta' or 'porcent'
%       aux_value = valores de las anteriores opciones
%           Si se ha añadido el porcentage también hay que añadir la latitud
%
%       Si se ha adjuntado el valor de BETA, se devolverá entonces el valor del porcentaje estimado.
%       En cambio si se adjunta el valor de BETA, se calculará el margen de indisponibilidad debido a lluvias. 

function retval = satelitePorcentajeIndisponibilidad(A001, theta, aux, aux_value, varargin)
    porcent = 0;
    L = 0;
    switch (aux)
       case {'beta'}
            BETA = aux_value;
            
            %TODO: cambiar el cargar el paquete para que sea compatible con MATLAB o OCATVE
            pkg load symbolic
            syms p;
    
            func = A001*(p/0.01)^(-(0.655 + 0.33*ln(p) - 0.045*ln(A001) - BETA*(1 - p)*send(tetha)))== 0;

            retval = vpasolve(func, p);
       case {'porcent'}
            porcent = aux_value;
            if isnumeric(varargin{4})
                L = varargin{4};
            else
                error('Hay que añadir la Latitud');
            end
             if porcent != 0.01
                if porcent >= 1 && abs(L) >= 36
                  BETA = 0;
                elseif  porcent < 1 && abs(L) < 36 && theta >= 25
                  BETA = -0.005*(abs(L)-36);
                else
                  BETA = -0.005*(abs(L)-36)+1.8-4.25*sind(theta);
                end
                retval = A_001*(porcent/0.001)^(-(0.655 + 0.033*ln(porcent) - 0.045*ln(A_001) - BETA*(1 - porcent)*sin(theta)));
            else
                error('El valor A001 ya es para el 0.01% de indisponibilidad');
            end
    end
end
