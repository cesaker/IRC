espectro=[0:255]*4312.5;                                  %Hz
espectro_UL=espectro(7:32);
espectro_DL=espectro(7:256);
espectro_DL_FDM=espectro(33:256);
Portadora_UL=espectro_UL(1:end)+4312.5/2;                 %Vector de portadoras
Portadora_DL=espectro_DL(1:end)+4312.5/2;
Portadora_FDM=espectro_DL_FDM(1:end)+4312.5/2;

%Densidad espectral de potencia de ruido

PSD_AWGN_UL=(ones(26,1)*(10.^(-140./10)))';               %en mW
PSD_AWGN_DL_Canc_Eco=(ones(250,1)*(10.^(-140./10)))';     %en mW
PSD_AWGN_FDM=(ones(224,1)*(10.^(-140./10)))';             %en mW

%Cálculo de las PSD

PSD_UL=((ones(26,1)*(10^(-38./10)))');             %en mW
PSD_DL_Canc_Eco=((ones(250,1)*(10^(-40./10)))');   %en mW
PSD_DL_FDM=((ones(224,1)*(10^(-40./10)))');        %en mW

d=[100:100:6000];

PSD_UL_NEXT=PSD_NEXT(PSD_UL,espectro_UL,49);
PSD_UL_FEXT=PSD_FEXT(PSD_UL,espectro_UL,d,49);
PSD_DL_Canc_NEXT=PSD_NEXT(PSD_DL_Canc_Eco,espectro_DL,49);
PSD_DL_Canc_FEXT=PSD_FEXT(PSD_DL_Canc_Eco,espectro_DL,d,49);
PSD_DL_FDM_NEXT=PSD_NEXT(PSD_DL_FDM,espectro_DL_FDM,49);
PSD_DL_FDM_FEXT=PSD_FEXT(PSD_DL_FDM,espectro_DL_FDM,d,49);



%Calculamos la SNR (con cancelacion de eco subida)
ftransferencia2=(transferencia(d,espectro_UL)).^2;

for i=1:length(ftransferencia2(1,:))
    numSNR(:,i)=PSD_UL'.*ftransferencia2(:,i);
end

auxdenomSNR=sqrt(PSD_AWGN_UL)+sqrt(PSD_UL_NEXT);

for i=1:length(numSNR(1,:))
    denomSNR(:,i)=auxdenomSNR';
end

denomSNR=denomSNR+sqrt(PSD_UL_FEXT);
denomSNR=denomSNR.^2;

SNR_UL_Canc=numSNR./denomSNR;
SNR_UL_Canc_dB=10*log10(SNR_UL_Canc);

%Calculamos la SNR (sin cancelacion de eco subida)

for i=1:length(ftransferencia2(1,:))
    numSNR5(:,i)=PSD_UL'.*ftransferencia2(:,i);
end

auxdenomSNR5=sqrt(PSD_AWGN_UL);

for i=1:length(numSNR5(1,:))
    denomSNR5(:,i)=auxdenomSNR';
end

denomSNR5=denomSNR5+sqrt(PSD_UL_FEXT);
denomSNR5=denomSNR5.^2;

SNR_UL=numSNR5./denomSNR5;
SNR_UL_dB=10*log10(SNR_UL);

%Calculamos la SNR (DL con Canc_Eco)

ftransferencia3=(transferencia(d,espectro_DL)).^2;

for i=1:length(ftransferencia3(1,:))
    numSNR1(:,i)=PSD_DL_Canc_Eco'.*ftransferencia3(:,i);
end

auxdenomSNR1=sqrt(PSD_AWGN_DL_Canc_Eco)+sqrt(PSD_DL_Canc_NEXT);

for i=1:length(numSNR1(1,:))
    denomSNR1(:,i)=auxdenomSNR1';
end

denomSNR1=denomSNR1+sqrt(PSD_DL_Canc_FEXT);
denomSNR1=denomSNR1.^2;

SNR_DL_Canc_Eco=numSNR1./denomSNR1;
SNR_DL_Canc_Eco_dB=10*log10(SNR_DL_Canc_Eco);

%Calculamos la SNR (DL sin eco)

ftransferencia4=(transferencia(d,espectro_DL_FDM)).^2;

for i=1:length(ftransferencia4(1,:))
    numSNR2(:,i)=PSD_DL_FDM'.*ftransferencia4(:,i);
end

auxdenomSNR2=sqrt(PSD_AWGN_FDM);

for i=1:length(numSNR2(1,:))
    denomSNR2(:,i)=auxdenomSNR2';
end

denomSNR2=denomSNR2+sqrt(PSD_DL_FDM_FEXT);
denomSNR2=denomSNR2.^2;

SNR_DL=numSNR2./denomSNR2;
SNR_DL_dB=10*log10(SNR_DL);

%Realizamos un gráfico en el que vengan representadas todas las SNR
subplot(2,2,1)
plot(SNR_UL_dB)
xlabel('Subcanales')
ylabel('Valores de SNR medidos (en dB)')
title ('SNR del canal de subida sin cancelación de eco')

subplot(2,2,2)
plot(SNR_UL_Canc_dB)
xlabel('Subcanales')
ylabel('Valores de SNR medidos (en dB)')
title ('SNR del canal de subida con cancelación de eco')

subplot(2,2,3)
plot(SNR_DL_dB)
xlabel('Subcanales')
ylabel('Valores de SNR medidos (en dB)')
title ('SNR del canal de bajada sin cancelación de eco')

subplot(2,2,4)
plot(SNR_DL_Canc_Eco_dB)
xlabel('Subcanales')
ylabel('Valores de SNR medidos (en dB)')
title ('SNR del canal de bajada con cancelación de eco')



%Capacidad

%Capacidad teórica

%UL sin eco
for i=1:length(SNR_UL(1,:))
    Cap_Shannon_UL(i)=sum(log2(1+(SNR_UL(:,i))))*4312.5;
end

%UL con eco
for i=1:length(SNR_UL_Canc(1,:))
    Cap_Shannon_UL_Canc(i)=sum(log2(1+(SNR_UL_Canc(:,i))))*4312.5;
end

%DL sin eco
for i=1:length(SNR_DL(1,:))
    Cap_Shannon_DL(i)=sum(log2(1+(SNR_DL(:,i))))*4312.5;
end

%DL con eco
for i=1:length(SNR_DL_Canc_Eco(1,:))
    Cap_Shannon_DL_Canc(i)=sum(log2(1+(SNR_DL_Canc_Eco(:,i))))*4312.5;
end



%Capacidad real

%Canal de subida sin cancelación de eco

SNRs=[-200 14.5 18.0 21.5 24.5 27.7 30.6 33.8 36.8 39.9 42.9 45.9 48.9 51.9 54.9];
bits_simb=[0 2 3 4 5 6 7 8 9 10 11 12 13 14 15];

for i=1:length(SNR_UL(1,:))
    for f1=1:length(Portadora_UL)
        bits_UL(f1,i)=find(SNRs<10*log10(SNR_UL(f1,i)),1,'last');
        bits_UL(f1,i)=bits_simb(bits_UL(f1,i));
    end
end

for i=1:length(bits_UL(1,:))
    C_real_UL(i)=sum(bits_UL(:,i))*4000;
end

%Canal de subida con cancelación de eco

for i=1:length(SNR_UL_Canc(1,:))
    for f1=1:length(Portadora_UL)
        bits_UL_Canc(f1,i)=find(SNRs<10*log10(SNR_UL_Canc(f1,i)),1,'last');
        bits_UL_Canc(f1,i)=bits_simb(bits_UL_Canc(f1,i));
    end
end

for i=1:length(bits_UL_Canc(1,:))
    C_real_UL_Canc(i)=sum(bits_UL_Canc(:,i))*4000;
end

%Canal de bajada sin cancelación de eco

for i=1:length(SNR_DL(1,:))
    for f1=1:length(Portadora_FDM)
        bits_DL(f1,i)=find(SNRs<10*log10(SNR_DL(f1,i)),1,'last');
        bits_DL(f1,i)=bits_simb(bits_DL(f1,i));
    end
end

for i=1:length(bits_DL(1,:))
    C_real_DL(i)=sum(bits_DL(:,i))*4000;
end

%Canal de bajada con cancelación de eco

for i=1:length(SNR_DL_Canc_Eco(1,:))
    for f1=1:length(Portadora_DL)
        bits_DL_Canc(f1,i)=find(SNRs<10*log10(SNR_DL_Canc_Eco(f1,i)),1,'last');
        bits_DL_Canc(f1,i)=bits_simb(bits_DL_Canc(f1,i));
    end
end

for i=1:length(bits_DL_Canc(1,:))
    C_real_DL_Canc(i)=sum(bits_DL_Canc(:,i))*4000;
end

%Dibujamos las gráficas que representan la capacidad

subplot(2,2,1)
hold on
plot(Cap_Shannon_UL)
plot(C_real_UL,'r')
legend('Valores teóricos','Valores reales')
xlabel('Distancia (en metros)')
ylabel('Capacidad del canal')
title('Capacidad del canal de subida sin cancelación de eco')
hold off

subplot(2,2,2)
hold on
plot(Cap_Shannon_UL_Canc)
plot(C_real_UL_Canc,'r')
legend('Valores teóricos','Valores reales')
xlabel('Distancia (en metros)')
ylabel('Capacidad del canal')
title('Capacidad del canal de subida con cancelación de eco')
hold off

subplot(2,2,3)
hold on
plot(Cap_Shannon_DL)
plot(C_real_DL,'r')
legend('Valores teóricos','Valores reales')
xlabel('Distancia (en metros)')
ylabel('Capacidad del canal')
title('Capacidad del canal de bajada sin cancelación de eco')
hold off

subplot(2,2,4)
hold on
plot(Cap_Shannon_DL_Canc)
plot(C_real_DL_Canc,'r')
legend('Valores teóricos','Valores reales')
xlabel('Distancia (en metros)')
ylabel('Capacidad del canal')
title('Capacidad del canal de bajada con cancelación de eco')
hold off
