clear all

%Para ello generamos un vector con valores para 
%landa que van desde 0,1 hasta 2 con un paso de 
%0,05 y calculamos el rendimiento del servidor 
%para cada valor de este. Los valores obtenidos son 
%los siguientes. El código utilizado se adjunta al final 
%del documento.

%Como podemos observar en la gráfica, el rendimiento 
%del sistema aumenta linealmente conforme aumenta la 
%tasa de generación. Llega un punto en el que el rendimiento 
%se estabiliza. En este punto tanto la tasa de generación como 
%el rendimiento valen 1, es decir se igualan.
%A partir de este punto podremos decir que el modelo se encuentra 
%por encima del nivel de saturación, ya que el servidor trabaja a 
%máximo funcionamiento en todo momento.
%En el momento en que se encuentra en saturación el valor del 
%rendimiento del servidor será de 1 (es decir el 100%). Esto es 
%porque los eventos llegan más rápido de lo que el servidor 
%puede funcionar.

landa=[0.1:0.05:2];
mu=1;

TS=1/mu;

for i=1:length(landa)
    TG=1/landa(i);
    sim('P1_intro.slx',10000);
    UtilizacionServidor(i)=salida(end); %Primer apartado
    Rmedio(i)=mean(retardo)            %Apartado 2
    PaquetesCola(i)=mean(Pservidor(end)+cola(end));
    
    
    if (landa(i)<=mu)
    Rteorico(i)=1./(mu-landa(i));
    CargaSistema(i)=landa(i)/mu;
    PaquetesColaT(i)=Rteorico(i).*landa(i);
    end
end

figure(1)
plot(landa,UtilizacionServidor);
title('Rendimiento del servidor');
xlabel('Valor de landa');
ylabel('Rendimiento');

figure(2)
plot(UtilizacionServidor, Rmedio);
hold on
plot(CargaSistema, Rteorico,'r');
hold off
legend('Simulacion', 'Teorico')

figure(3)
plot(UtilizacionServidor, PaquetesCola);
hold on
plot(CargaSistema, PaquetesColaT, 'r');
hold off
legend('Simulacion', 'Teorico');


