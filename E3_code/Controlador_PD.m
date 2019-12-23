%%%Variales%%%
K = 2500;
p = 64;
%Kp variable
Kp_array = [0.001 0.01 0.05 1];
td_fija = 0.5;
Kp_limite_inferior = 0;
Kp_limite_superior = 50;
%td variable
td_array = [0.5 1.5 3 6];
Kp_fija = 0.9;
td_limite_inferior = 0;
td_limite_superior = 50;
%Duracion de la funcion
duracion = (0:0.001:100)';
%Señal de referencia: escalon = 1, rampa = dur(i), parábola = dur(i)^2
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = 1;  
end
    

%%%Constantes%%%
Length_Kp = length(Kp_array);
Length_td = length(td_array);
legend_Kp = cell(1,Length_Kp+1);
legend_td = cell(1,Length_td+1);

%Bucle Kp variable y td fijo
for i = 1:Length_Kp
    Kp = Kp_array(i); 
    td = td_fija;
    num = [K*Kp*td K*Kp];
    den = [1 p+K*Kp*td K*Kp];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(1);
    plot(t,y);
    xlim([Kp_limite_inferior Kp_limite_superior]);
    tmp = 'td=';
    tmp2 = num2str(td);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmp, tmp2, tmp4, tmp5);
    legend_Kp{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_Kp{Length_Kp+1} = 'Referencia';
title('Controlador PD');
xlabel('tiempo (s)');
lgd = legend(legend_Kp, 'location', 'Best');
lgd.FontSize = 14;
hold off;

%Bucle Kp fijo y td variable
for i = 1:Length_td
    Kp = Kp_fija; 
    td = td_array(i);
    num = K*Kp;
    den = [1 p+K*Kp*td K*Kp];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(2);
    plot(t,y);
    xlim([td_limite_inferior td_limite_superior]);
    tmp = 'td=';
    tmp2 = num2str(td);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmp, tmp2, tmp4, tmp5);
    legend_td{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_td{Length_td+1} = 'Referencia';
title('Controlador PD');
xlabel('tiempo (s)');
lgd = legend(legend_td, 'location', 'Best');
lgd.FontSize = 14;
hold off;
