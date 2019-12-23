%%%Variales%%%
K = 2500;
p = 64;
%Kp variable
Kp_array = [1 10 100 1000];
Kp_td_fija = 1;
Kp_td2_fija = 1;
Kp_ti_fija = 1;
Kp_limite_inferior = 0;
Kp_limite_superior = 10;
%td variable
td_array = [0.001 0.01 0.1 10 100];
td_Kp_fija = 1;
td_td2_fija = 1;
td_ti_fija = 1;
td_limite_inferior = 0;
td_limite_superior = 10;
%td2 variable
td2_array = [1 2.5 5 10];
td2_Kp_fija = 1;
td2_td_fija = 1;
td2_ti_fija = 1;
td2_limite_inferior = 0;
td2_limite_superior = 20;
%ti variable
ti_array = [0.1 1 10 50];
ti_Kp_fija = 1;
ti_td_fija = 1;
ti_td2_fija = 1;
ti_limite_inferior = 0;
ti_limite_superior = 20;
%Duracion de la funcion: tarda más en ejecutar contra más aumentes
duracion = (0:0.0001:100)';
%Señal de referencia: escalon = 1, rampa = dur(i), parábola = dur(i)^2
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = duracion(i)^2;  
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
    num = [K*Kp*(td+td2) K*Kp (K*Kp)/ti];
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
    tmp3 = ' td2=';
    tmp33 = num2str(td2);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp3, tmp33, tmp4, tmp5);
    legend_Kp{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_Kp{Length_Kp+1} = 'Referencia';
title('Controlador D|PID');
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
    num = [K*Kp*(td+td2) K*Kp (K*Kp)/ti];
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
    tmp3 = ' td2=';
    tmp33 = num2str(td2);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp3, tmp33, tmp4, tmp5);
    legend_td{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_td{Length_td+1} = 'Referencia';
title('Controlador D|PID');
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
    num = [K*Kp*(td+td2) K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*td K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(3);
    plot(t,y);
    xlim([td2_limite_inferior td2_limite_superior]);
    tmpa = 'ti=';
    tmpb = num2str(ti);
    tmp = ' td=';
    tmp2 = num2str(td);
    tmp3 = ' td2=';
    tmp33 = num2str(td2);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp3, tmp33, tmp4, tmp5);
    legend_td2{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_td2{Length_td2+1} = 'Referencia';
title('Controlador D|PID');
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
    num = [K*Kp*(td+td2) K*Kp (K*Kp)/ti];
    den = [1 p+K*Kp*td K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(4);
    plot(t,y);
    xlim([ti_limite_inferior ti_limite_superior]);
    tmpa = 'ti=';
    tmpb = num2str(ti);
    tmp = ' td=';
    tmp2 = num2str(td);
    tmp3 = ' td2=';
    tmp33 = num2str(td2);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmpa, tmpb, tmp, tmp2, tmp3, tmp33, tmp4, tmp5);
    legend_ti{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_ti{Length_ti+1} = 'Referencia';
title('Controlador D|PID');
xlabel('tiempo (s)');
lgd = legend(legend_ti, 'location', 'Best');
lgd.FontSize = 14;
hold off;
