## Author: Mitzasi <mitzasi@plumberry>
## Created: 2020-12-10
#   distancia = sateliteDistanciaLluvia (hr, hs, tetha) km
#     hr (m) = altura hasta zona de lluvia. hr (km) = hiso_0 + 0.36 (km)
#     hs (m) = altura de antena
#     tetha = ángulo de elevación

function distancia = sateliteDistanciaLluvia (hr, hs, tetha)
  hr = hr/1000;
  hs = hs/1000;
  if tetha < 5
    Ls = 2*(hr - hs)/((sind(tetha)^2 + 2*(hr - hs)/8500)^0.5 + sind(tetha));
  else
    Ls = (hr - hs)/sind(tetha);
  end
  distancia = Ls; #km
endfunction
