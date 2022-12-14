%   sigma = calculoElevacion (L, N, S)
%     L (º)
%     N (º)
%     S (º) en orbita GEO
%
%   [sigma dist] = calculoElevacion (L, N, S)
%     ... 
%     DIST (m) = distancia desde la estación al satelite GEO
function [sigma varargout] = calculoElevacion(L, N, S)
  Re = 6370*10^3;
  r = 42164.2*10^3;
  tmp = atand((cosd(N - S)*cosd(L) - Re/r)/sqrt(1 - (cosd(N - S)^2)*(cosd(L)^2)));
  sigma = tmp;
  if nargout > 1
    dist = r*sqrt(1+(Re/r)^2 - 2*(Re/r)*cosd(L)*cosd(N - S));
    varargout{1} = dist; 
  end
endfunction
