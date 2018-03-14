%Función que calcula la PSD de la NEXT de la PSD de una señal dada con una frecuencia f para un cable de
%N pares

function y=PSD_NEXT(psd,f,N)
%psd=PSD de la señal

X49=1/(1.13*10^13);
H2=X49*(N/49)^0.6.*(f.^(3/2));
y=psd.*H2;