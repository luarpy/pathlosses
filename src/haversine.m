% distancia = haversine (lat1, lon1, lat2, lon2)   m
% 
function distancia = haversine (lat1, lon1, lat2, lon2) 
  Re = 6371*10^3;
  dLat = abs((lat2 - lat1)*pi/180);
  dLon = abs((lon2 - lon1)*pi/180);
  lat1 = lat1*pi/180;
  lat2 = lat2*pi/180;
  a = sin(dLat/2)^2 + cos(lat1)*cos(lat2)*sin(dLon/2)^2; 
  c = 2*asin(sqrt(a));
  distancia = Re*c;
endfunction
