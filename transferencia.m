%Esta función realiza el cálculo de la función de transferencia del modelo
%de canal simplificado de un cable de pares de calibre AWG 26

function H=transferencia(d,f)
% d-> distancia (en metros)
% f-> frecuencia (en herzios)

k1=2.9826*10^-3;
k2=-1.060619*10^-8;
k3=3.0491*10^-5;

H=(abs(exp(-d'*(k1*sqrt(f)+k2*f)/1000).*exp(-j*(d'*k3*f)/1000)))';

