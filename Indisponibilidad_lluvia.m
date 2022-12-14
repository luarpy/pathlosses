function horasindisp = Indisponibilidad_lluvia( f,M,ATTlluvia )

% Coeficientes

C0=0.12+0.4*log10((f/10)^0.8);  
C1=(0.07^C0)*0.12^(1-C0);       
C2=0.855*C0+0.546*(1-C0);      
C3=0.139*C0+0.043*(1-C0);      

D1=log10(M/(ATTlluvia*C1));

x1=(-C2+sqrt(C2^2-4*C3*D1))/(2*C3);     %Calculos necesarios para calcular el tiempo de indisponibilidad
x2=(-C2-sqrt(C2^2-4*C3*D1))/(2*C3);

Htotales = 365.25*24;



if ((x1 >= -3) && (x1 <= 2))
    
    porcentajeindisp = (10^x1*0.01);
    horasindisp = (porcentajeindisp*Htotales);
    
end


if ((x2 >= -3) && (x2 <=2))
    
    logx2 = (10^x2)*0.01;
    horasindisp = (porcentajeindisp*Htotales);
    
end


end