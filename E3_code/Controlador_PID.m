%%%Variales%%%
K = 2500;
p = 64;
%Kp variable
Kp_array = [0.1 1 100];
Kp_td_fija = 0.5;
Kp_ti_fija = 0.8;
Kp_limite_inferior = 0;
Kp_limite_superior = 3;
%td variable
td_array = [-0.01 1 10];
td_Kp_fija = 0.9;
td_ti_fija = 0.8;
td_limite_inferior = 0;
td_limite_superior = 0.3;
%ti variable
ti_array = [0.0001 1 1000];
ti_Kp_fija = 1;
ti_td_fija = 100;
ti_limite_inferior = 0;
ti_limite_superior = 50;
%Duracion de la funcion: tarda más en ejecutar contra más aumentes
duracion = (0:0.001:300)';
%Señal de referencia: escalon = 1, rampa = dur(i), parábola = dur(i)^2
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = duracion(i)^2;  
end
    

%%%Constantes%%%
Length_Kp = length(Kp_array);
Length_td = length(td_array);
Length_ti = length(ti_array);
legend_Kp = cell(1,Length_Kp+1);
legend_td = cell(1,Length_td+1);
legend_ti = cell(1,Length_ti+1);

%Bucle Kp variable
for i = 1:Length_Kp
    Kp = Kp_array(i); 
    td = Kp_td_fija;
    ti = Kp_ti_fija;
    num = [K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*td K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(1);
    plot(t,y);
    xlim([Kp_limite_inferior Kp_limite_superior]);
    tmpa = 'ti=';
    tmpb = num2str(ti);
    tmp = ' td=';
    tmp2 = num2str(td);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp4, tmp5);
    legend_Kp{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_Kp{Length_Kp+1} = 'Referencia';
title('Controlador PI-D');
xlabel('tiempo (s)');
lgd = legend(legend_Kp, 'location', 'Best');

lgd.FontSize = 14;
hold off;

%Bucle td variable¡
for i = 1:Length_td
    Kp = td_Kp_fija; 
    td = td_array(i);
    ti = td_ti_fija;
    num = [K*Kp*td K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*td K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(2);
    plot(t,y);
    xlim([td_limite_inferior td_limite_superior]);
    tmpa = 'ti=';
    tmpb = num2str(ti);
    tmp = ' td=';
    tmp2 = num2str(td);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp4, tmp5);
    legend_td{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_td{Length_td+1} = 'Referencia';
title('Controlador PID');
xlabel('tiempo (s)');
lgd = legend(legend_td, 'location', 'Best');
lgd.FontSize = 14;
hold off;

%Bucle ti variable¡
for i = 1:Length_ti
    Kp = ti_Kp_fija; 
    td = ti_td_fija;
    ti = ti_array(i);
    num = [K*Kp*td K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*td K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(3);
    plot(t,y);
    xlim([ti_limite_inferior ti_limite_superior]);
    tmpa = 'ti=';
    tmpb = num2str(ti);
    tmp = ' td=';
    tmp2 = num2str(td);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp4, tmp5);
    legend_ti{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_ti{Length_ti+1} = 'Referencia';
title('Controlador PID');
xlabel('tiempo (s)');
lgd = legend(legend_ti, 'location', 'Best');
lgd.FontSize = 14;
hold off;
