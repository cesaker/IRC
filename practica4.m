clear all

funcionamiento=[0.1 0.3 0.5 0.7 1];

for i=1:length(funcionamiento)
    tg=8/2048;
    tmux=tg/4;
    tmux=tmux*funcionamiento(i); 
    fun=funcionamiento(i);
    
    
    sim('p4.slx',10);   
    
    vel(i)=eventosservidos(end)/10;
    retardo1(i)=tmedio1(end);
    retardo2(i)=tmedio2(end);
    retardo3(i)=tmedio3(end);
    retardo4(i)=tmedio4(end);
end

figure(1)
plot(funcionamiento*100, retardo1,'b')
hold on
plot(funcionamiento*100, retardo2,'r')
plot(funcionamiento*100, retardo3,'g')
plot(funcionamiento*100, retardo4,'m')
legend('retardo1', 'retardo2', 'retardo3', 'retardo4')
xlabel('porcentaje (%)')
ylabel('Retardo (s)')
hold off

figure(2)
plot(funcionamiento*100, vel)
title('velocidad (bytes/s)')
xlabel('Porcentaje (%)');

%Con tolerancias

tmux=tg/4;

sim('P4_tolerancia.slx',10)
%intensidad=(eventosgenerados1+eventosgenerados2+eventosgenerados3+eventosgenerados4)./eventosservidos;
%figure(3)
%plot(intensidad)

figure(4)

plot(tmedio)
title('Retardo del primer afluente con tolerancia 10 %')


cola=[cola1(1:5121,:) cola2 cola3 cola4]
figure(5)

plot(cola)
title('Colas')


