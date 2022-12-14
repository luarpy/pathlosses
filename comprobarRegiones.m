% Autor: Miguel Angel Sanchez
%   comprobarRegiones:
%     [checkRegion,Fresnel,Fraunhofer, margen] = comprobarRegiones(freq, Aeff, alpha, d)
%     FREQ (Hz)
%     Aeff (m²) 
%     DIST (m) 

function [checkRegion, varargout] = comprobarRegiones(freq, Aeff, d)
    lambda=(3*10^8)/freq;
    alpha = 44*2;
    K = d*lambda/Aeff
    if K > 4
        checkRegion = 'Campo Lejano';
    else
        checkRegion = 'Campo Cercano';  
    end
      
    if nargout > 0
      switch(nargout)
          case {1}
%            varargout{1} = RegionFresnel;
          case {2}
%            varargout{1} = RegionFraunhofer;
          case{3}
%            varargout{2} = margen;
          otherwise
            error('Hay más argumentos de salida de los posibles');
      end
    end
end
