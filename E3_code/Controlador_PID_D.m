%%%Variales%%%
K = 2500;
p = 64;
%Kp variable
Kp_array = [0.05 0.1 1 10];
Kp_td_fija = 1;
Kp_td2_fija = 1;
Kp_ti_fija = 1;
Kp_limite_inferior = 0;
Kp_limite_superior = 20;
%td variable
td_array = [0.01 0.05 0.1 5];
td_Kp_fija = 1;
td_td2_fija = 1;
td_ti_fija = 1;
td_limite_inferior = 0;
td_limite_superior = 20;
%td2 variable
td2_array = [1 2.5 5 10];
td2_Kp_fija = 1;
td2_td_fija = 1;
td2_ti_fija = 1;
td2_limite_inferior = 0;
td2_limite_superior = 30;
%ti variable
ti_array = [0.1 1 10 20];
ti_Kp_fija = 1;
ti_td_fija = 1;
ti_td2_fija = 1;
ti_limite_inferior = 0;
ti_limite_superior = 40;
%Duracion de la funcion: tarda más en ejecutar contra más aumentes
duracion = (0:0.0001:100)';
%Señal de referencia: escalon = 1, rampa = dur(i), parábola = dur(i)^2
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = 1;  
end
    

%%%Constantes%%%
Length_Kp = length(Kp_array);
Length_td = length(td_array);
Length_td2 = length(td2_array);
Length_ti = length(ti_array);

legend_Kp = cell(1,Length_Kp+1);
legend_td = cell(1,Length_td+1);
legend_td2 = cell(1,Length_td2+1);
legend_ti = cell(1,Length_ti+1);

%Bucle Kp variable
for i = 1:Length_Kp
    Kp = Kp_array(i); 
    td = Kp_td_fija;
    td2 = Kp_td2_fija;
    ti = Kp_ti_fija;
    num = [K*Kp*td K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*(td+td2) K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(1);
    plot(t,y);
    xlim([Kp_limite_inferior Kp_limite_superior]);
    legend_Kp{i} = strcat('ti=', num2str(ti), ' td=', num2str(td), ' td2=', num2str(td2), ' Kp=', num2str(Kp));
    hold on;
end
plot(duracion,estimulo);
legend_Kp{Length_Kp+1} = 'Referencia';
title('Controlador PID-D');
xlabel('tiempo (s)');
lgd = legend(legend_Kp, 'location', 'Best');
lgd.FontSize = 14;
hold off;

%Bucle td variable¡
for i = 1:Length_td
    Kp = td_Kp_fija; 
    td = td_array(i);
    td2 = td_td2_fija;
    ti = td_ti_fija;
    num = [K*Kp*td K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*(td+td2) K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(2);
    plot(t,y);
    xlim([td_limite_inferior td_limite_superior]);
    legend_td{i} = strcat('ti=', num2str(ti), ' td=', num2str(td), ' td2=', num2str(td2), ' Kp=', num2str(Kp));
    hold on;
end
plot(duracion,estimulo);
legend_td{Length_td+1} = 'Referencia';
title('Controlador PID-D');
xlabel('tiempo (s)');
lgd = legend(legend_td, 'location', 'Best');
lgd.FontSize = 14;
hold off;

%Bucle td2 variable¡
for i = 1:Length_td2
    Kp = td2_Kp_fija; 
    td2 = td2_array(i);
    td = td2_td_fija;
    ti = td2_ti_fija;
    num = [K*Kp*td K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*(td+td2) K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(3);
    plot(t,y);
    xlim([td2_limite_inferior td2_limite_superior]);
    legend_td2{i} = strcat('ti=', num2str(ti), ' td=', num2str(td), ' td2=', num2str(td2), ' Kp=', num2str(Kp));
    hold on;
end
plot(duracion,estimulo);
legend_td2{Length_td2+1} = 'Referencia';
title('Controlador PID-D');
xlabel('tiempo (s)');
lgd = legend(legend_td2, 'location', 'Best');
lgd.FontSize = 14;
hold off;

%Bucle ti variable¡
for i = 1:Length_ti
    Kp = ti_Kp_fija; 
    td = ti_td_fija;
    td2 = ti_td2_fija;
    ti = ti_array(i);
    num = [K*Kp*td K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*(td+td2) K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(4);
    plot(t,y);
    xlim([ti_limite_inferior ti_limite_superior]);
    legend_ti{i} = strcat('ti=', num2str(ti), ' td=', num2str(td), ' td2=', num2str(td2), ' Kp=', num2str(Kp));
    hold on;
end
plot(duracion,estimulo);
legend_ti{Length_ti+1} = 'Referencia';
title('Controlador PID-D');
xlabel('tiempo (s)');
lgd = legend(legend_ti, 'location', 'Best');
lgd.FontSize = 14;
hold off;
