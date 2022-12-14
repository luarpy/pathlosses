%MarioJimenez
function Agas = Perdidas_gasesatmosfericos(f,t,humedad,d)

 %Fijamos frecuencia a 40GHZ para el peor de los casos
%t(º) = Temperatura 
%d(km) = distancia del vano

%Comprobar si las variables son correctas


if isnumeric(t) else error('t erronea, introduce una temperatura en grados'); end

if isnumeric(humedad) else error('humedad erronea, introduce el porcentaje de humedad '); end 

if isnumeric(d) else error('d erronea, introduce una distancia en KM'); end


%Cálculos
humporcentaje = (humedad * 100);
densat = 5.02+0.323*t+8.18*(10^-3)*t^2+3.12*(10^-4)*t^3;                   % Desidad de vapor de agua (saturacion) (g/m3)
den = humporcentaje*densat/100;                                            % Densidad de vapor de agua (g/m3)

if (f < 57)
    
    gammaoxigeno = (((7.19*10^-3+(6.09)/(f^2+0.227)+(4.81)/((f-57)^2+1.5))*f^2)*10^-3);

elseif (f > 57 && f < 63)
    
    gammaoxigeno = (-0.024*(f^3-160.82*f^2+8482*f-146598));
    
elseif (f > 63)
    
    gammaoxigeno = (((3.79*10^-7)*f+0.265/((f-63)^2+1.59)+0.028/((f-118)^2+1.47)*((f+198)^2))*10^-3);
    
    
end

gammavaporagua =((0.05+0.0021*den+3.6/((f-22.235)^2+8.5)+10.6/((f-183.31)^2+9)+8.9/((f-325.4)^2+26.3))*den*f^2)*10^(-4);  %Valor de atenuacion por vapor de agua
Agas =(gammaoxigeno+gammavaporagua)*d;                                     %Perdidas por gases atmosfericos  


end