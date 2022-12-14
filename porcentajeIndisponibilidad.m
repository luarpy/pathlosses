
% Autor: Luar Biurrun-Lorda
%
%   [ WARNING: sólo vale para calcular indisponibilidad en radioenlaces terrestres ]
%   log10porcent = porcentajeIndisponibilidad(A001, M, C0, C1, C2, C3) %
%       A001 (dB)
%       M (dB)
%       C0 (dB)
%       C1 (dB)
%       C2 (dB)
%       C3 (dB)

function porcent = porcentajeIndisponibilidad(A001, M, C0, C1, C2, C3)
    c = log10(M/(A001*C1))
    x1 = (-C2 + sqrt(C2^2 - 4*C3*c))/(2*C3)
    x2 = (-C2 - sqrt(C2^2 - 4*C3*c))/(2*C3)

    if -3 <= x1 < 2
        log10porcent = x1;
    elseif -3 <= x2 < 2
        log10porcent = x2;
    else
        error("No se ha podido calcular el porcentaje de indisponibilidad");
    end
    log10porcent
    porcent = 10^log10porcent;
    
    dias = porcent*3.65;
    horas = (dias - fix(dias))*24;
    minutos = (horas - fix(horas))*60;
    segundos = (minutos - fix(minutos))*60;
    disp([num2str(fix(dias)) "dias " num2str(fix(horas)) "h " num2str(fix(minutos)) "mins " num2str(fix(segundos)) "s"]);
end
