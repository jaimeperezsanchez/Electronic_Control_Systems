%%%Variales%%%
K = 2500;
p = 64;
%Kp variable
Kp_array = [0.18 0.41 0.9 4.5];
ti_fija = 0.8;
Kp_limite_inferior = 0;
Kp_limite_superior = 2;
%td variable
ti_array = [-5 0.1 0.8 5];
Kp_fija = 0.9;
ti_limite_inferior = 0;
ti_limite_superior = 10;
%Duracion de la funcion
duracion = (0:0.001:100)';
%Señal de referencia: escalon = 1, rampa = dur(i), parábola = dur(i)^2
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = duracion(i)^2;  
end
    

%%%Constantes%%%
Length_Kp = length(Kp_array);
Length_ti = length(ti_array);
legend_Kp = cell(1,Length_Kp+1);
legend_ti = cell(1,Length_ti+1);

%Bucle Kp variable y td fijo
for i = 1:Length_Kp
    Kp = Kp_array(i); 
    ti = ti_fija;
    num = [K*Kp (K*Kp)/ti];
    den = [1 p K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(1);
    plot(t,y);
    xlim([Kp_limite_inferior Kp_limite_superior]);
    tmp = 'ti=';
    tmp2 = num2str(ti);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmp, tmp2, tmp4, tmp5);
    legend_Kp{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_Kp{Length_Kp+1} = 'Referencia';
title('Controlador PI');
xlabel('tiempo (s)');
lgd = legend(legend_Kp, 'location', 'Best');
lgd.FontSize = 14;
hold off;

%Bucle Kp fijo y td variable
for i = 1:Length_ti
    Kp = Kp_fija; 
    ti = ti_array(i);
    num = [K*Kp (K*Kp)/ti];
    den = [1 p K*Kp (K*Kp)/ti];
    G = tf(num,den);
    [y,t] = lsim(G,estimulo,duracion);
    figure(2);
    plot(t,y);
    xlim([ti_limite_inferior ti_limite_superior]);
    tmp = 'ti=';
    tmp2 = num2str(ti);
    tmp4 = ' Kp=';
    tmp5 = num2str(Kp);
    string = strcat(tmp, tmp2, tmp4, tmp5);
    legend_ti{i} = string;
    hold on;
end
plot(duracion,estimulo);
legend_ti{Length_ti+1} = 'Referencia';
title('Controlador PI');
xlabel('tiempo (s)');
lgd = legend(legend_ti, 'location', 'Best');
lgd.FontSize = 14;
hold off;
