clear all
landa=10;
tgen=1/landa;
mu=1;
tserv=1/mu; 
N=5;
A=landa/mu;


%Establecemos los parámetros que se dan en el enunciado, y 
%pasamos a obtener la probabilidad de bloqueo del modelo 
%teórica y experimentalmente, con el código que se facilita 
%al final del archivo. Obtenemos los siguientes valores:

den=0;
for i=0:N
    den=den+A.^i./factorial(i);
end

num=A.^N./factorial(N);
probTeo=num/den

sim('P2.slx',100);
probBloq=paquetesBloqueados(end)/paquetesGenerados(end)


%Una vez obtenido el valor anterior, pasamos ahora a buscar 
%una probabilidad de bloqueo del 15%. Para ello, lo que hacemos 
%es variar el número de servidores y calcular la probabilidad
%el bloqueo, hasta que encontremos un valor que esté por debajo 
%del 15 %.

for N=1:20
    den=0;
    for i=0:N
        den=den+A.^i./factorial(i);
    end
    
    num=A.^N./factorial(N);
    probTeo2(N)=num./den;
end


for N=1:20    
   sim('P2.slx',100);
   probBloq2(N)=paquetesBloqueados(end)./paquetesGenerados(end);
  
end


figure(1)
plot(probTeo2*100,'b')
title('Probabilidad de bloqueo en funcion de numero de servidores')
hold on
plot(probBloq2*100,'r')
hold off
legend('Teorico','Simulado')
xlabel('Número de servidores')
ylabel('Probabilidad de bloqueo (%)')

%En este apartado fijaremos el número de servidores (a 5) y 
%variaremos el valor de landa, para calcular la probabilidad 
%de bloqueo en función de la intensidad de tráfico, ya que como 
%se dice en el enunciado A=?/?.

N=5;
landa=0.05:0.05:15;

for i=1:length(landa)
    tgen=1/landa(i);
    sim('P2.slx',100);
    probBloq3(i)=paquetesBloqueados(end)./paquetesGenerados(end);
end


for i=1:length(landa);
    A=landa(i)/mu;
    
    den=0;
    for k=0:N
        den=den+A.^k./factorial(k);
    end
    
    num=A.^N./factorial(N);
    probTeo3(i)=num./den;
end

figure(2)
plot(probTeo3*100,'b')
title('Probabilidad de bloqueo en funcion de numero de Tgen')
hold on
plot(probBloq3*100,'r')
hold off
legend('Teorico','Simulado')
xlabel('Intensidad de tráfico')
ylabel('Probabilidad de bloqueo (%)')


