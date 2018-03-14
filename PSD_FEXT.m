%Funci�n que calcula la PSD de la FEXT de una se�al dada su PSD y su
%frecuencia a una distancia dada

function y=PSD_FEXT(psds,f,d,N)

%psds -> PSD de la se�al (en mW)
%f -> frecuencia de la se�al
%d -> distancia
%N -> n� de fuentes de telediafonia

h2canal=(transferencia(d,f)).^2;
k=4.971*10^-20;
H2=h2canal.*(N/49)^0.6*k;

for i=1:length(H2(:,1))
    H2(i,:)=H2(i,:).*d;
end

for i=1:length(H2(1,:))
    H2(:,i)=H2(:,i).*f'.*f';
end

for i=1:length(H2(1,:))
    y(:,i)=psds'.*(H2(:,i));
end
