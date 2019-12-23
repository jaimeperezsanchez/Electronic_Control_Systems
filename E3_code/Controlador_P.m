%Variales
K = 2500;
p = 64;
Kp_array = [1 10 100 500];
limite_inferior = 0;
limite_superior = 0.25;
%Duracion de la función
duracion = (0:0.001:1000)';
%Señal de referencia: escalon, rampa, parábola
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = duracion(i)^2;  
end
    

%Constantes
Length_Kp = length(Kp_array);
legend_names = cell(1,Length_Kp+1);

%Bucle para Kp variable
for i = 1:Length_Kp
    Kp = Kp_array(i);
    num = [0 0 K*Kp];
    den = [1 p K*Kp];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    plot(t,y);
    xlim([limite_inferior limite_superior]);
    tmp = 'Kp=';
    tmp2 = num2str(Kp);
    string = strcat(tmp, tmp2);
    legend_names{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_names{Length_Kp+1} = 'Referencia';
title('Controlador P');
xlabel('tiempo (s)');
lgd = legend(legend_names, 'location', 'Best');
lgd.FontSize = 14;
hold off;
