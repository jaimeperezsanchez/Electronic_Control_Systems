%%%Variales%%%
K = 2652.28; %cambiar
p = 64.986;
%beta y chi variable para Mp
mp_chi_array = [0.4 0.5 0.6 0.7 0.8 0.9];
mp_beta2_fija = 3;
mp_beta_length = 50;
escalon = pi;
%beta2 variable para ts
limite_x1 = 0.1;
limite_x2 =  5;
salto_x = 0.005;
ts_beta2_array = (limite_x1:salto_x:limite_x2)';
ts_beta2_length = length(ts_beta2_array);
%Duracion de la funcion: tarda más en ejecutar contra más aumentes
duracion = (0:0.0001:20)';
%Señal de referencia: escalon = 1, rampa = dur(i), parábola = dur(i)^2
estimulo = size(length(duracion));
for i = 1:length(duracion)
    estimulo(i) = escalon;  
end

limite_superior = size(mp_beta_length+1);
for i = 1:mp_beta_length+1
    limite_superior(i) = escalon*1.12;  
end
limite_inferior = size(mp_beta_length+1);
for i = 1:mp_beta_length+1
    limite_inferior(i) = escalon*1.05;  
end

duracion_beta = (0:1:mp_beta_length)';

ts_requerida = zeros(ts_beta2_length,1);
for i = 1:size(ts_requerida)
    ts_requerida(i) = 0.3;  
end

%%%Constantes%%%
mp_mp_y = zeros(mp_beta_length,1);
mp_beta_x = zeros(mp_beta_length,1);
Length_mp = length(mp_chi_array);
legend_mp = cell(1,Length_mp);

ts_ts_y = zeros(ts_beta2_length,1);
Length_ts = length(mp_chi_array);
legend_ts = cell(1,Length_ts);

primero = 0;
beta_minimo = size(Length_mp);
beta_maximo = size(Length_mp);


%Bucle Mp variable
for j = 1:Length_mp
    for i = 0:mp_beta_length
        beta = i;
        beta2 = mp_beta2_fija;
        chi = mp_chi_array(j);
        wn = p/(beta2*chi);
        q = (beta^2) - (2*beta) + (1/(chi^2));
        r1_num = chi*wn*(beta*((1/(chi^2))-4)+(2/(chi^2)));
        r1 = r1_num / q;
        r2_num = (wn^2)*((1/(chi^2))-(2*beta));
        r2 = r2_num / q;
        r3_num = (beta^3)*chi*wn;
        r3 = r3_num / q;
        num_1 = [r1 r2];
        den_1 = [1 2*chi*wn wn^2];
        G_1 = tf(num_1,den_1);
        num_2 = r3;
        den_2 = [1 beta*chi*wn];
        G_2 = tf(num_2,den_2);
        G = G_1 + G_2;
        [y,t] = lsim(G,estimulo,duracion);
        mp_mp_y(i+1) = max(y);
        mp_beta_x(i+1) = i;
        if (max(y) < escalon*1.12) && (max(y) > escalon*1.05) && (primero == 0)
            beta_minimo(j) = i;
            primero = 1;
        elseif (max(y) < escalon*1.12) && (max(y) > escalon*1.05) && (primero == 1)
            beta_maximo(j) = i;
        end
    end
    primero = 0;
    figure(1);
    plot(mp_beta_x,mp_mp_y);
    legend_mp{j} = strcat('\xi=', num2str(mp_chi_array(j)), ' \beta=[', num2str(beta_minimo(j)), ',', num2str(beta_maximo(j)), ']');
    hold on;
end
plot(duracion_beta,limite_superior);
hold on
plot(duracion_beta,limite_inferior);
title('Controlador D|PID');
xlabel('\beta');
ylabel('M_{p}');
lgd = legend(legend_mp, 'location', 'Best');
lgd.FontSize = 14;
hold off;
 
tmp = 1;
primero = 0;
%Bucle ts variable
for j = 1:Length_mp
    for i = limite_x1:salto_x:limite_x2
        beta = beta_maximo(j)-5;
        beta2 = ts_beta2_array(tmp);
        chi = mp_chi_array(j);
        wn = p/(beta2*chi);
        q = (beta^2) - (2*beta) + (1/(chi^2));
        r1_num = chi*wn*(beta*((1/(chi^2))-4)+(2/(chi^2)));
        r1 = r1_num / q;
        r2_num = (wn^2)*((1/(chi^2))-(2*beta));
        r2 = r2_num / q;
        r3_num = (beta^3)*chi*wn;
        r3 = r3_num / q;
        num_1 = [r1 r2];
        den_1 = [1 2*chi*wn wn^2];
        G_1 = tf(num_1,den_1);
        num_2 = r3;
        den_2 = [1 beta*chi*wn];
        G_2 = tf(num_2,den_2);
        G = G_1 + G_2;
        [y,t] = lsim(G,estimulo,duracion);
        for k = 1:length(y)
            if (y(k) >= escalon) && (primero == 0)
                ts_ts_y(tmp) = t(k);
                primero = 1;
            end
        end
        tmp = tmp+1;
        primero = 0;
    end
    tmp = 1;
    figure(2);
    plot(ts_beta2_array,ts_ts_y);
    xlim([limite_x1 limite_x2]);
    legend_ts{j} = strcat('\xi=', num2str(mp_chi_array(j)), ' \beta=', num2str(beta));
    hold on;
end
title('Controlador D|PID');
xlabel('\beta_{2}');
ylabel('t_{r}');
lgd = legend(legend_ts, 'location', 'Best');
lgd.FontSize = 14;
hold off;
%%%%%%%Temporales
beta2_array = 1;

Lenght_t = length(mp_chi_array);
legend_t = cell(1,Lenght_t);

for i = 1:Lenght_t
    beta = beta_maximo(i)-5;
    beta2 = beta2_array;
    chi = mp_chi_array(i);
    wn = p/(beta2*chi);
    q = (beta^2) - (2*beta) + (1/(chi^2));
    r1_num = chi*wn*(beta*((1/(chi^2))-4)+(2/(chi^2)));
    r1 = r1_num / q;
    r2_num = (wn^2)*((1/(chi^2))-(2*beta));
    r2 = r2_num / q;
    r3_num = (beta^3)*chi*wn;
    r3 = r3_num / q;
    num_1 = [r1 r2];
    den_1 = [1 2*chi*wn wn^2];
    G_1 = tf(num_1,den_1);
    num_2 = r3;
    den_2 = [1 beta*chi*wn];
    G_2 = tf(num_2,den_2);
    G = G_1 + G_2;
    [y,t] = lsim(G,estimulo,duracion);
    figure(3);
    plot(t,y);
    xlim([0 0.2]);
    legend_t{i} = strcat('\xi=', num2str(chi), ' \beta=', num2str(beta), ' \beta_{2}=', num2str(beta2));
    hold on;
end

title('Controlador D|PID');
lgd = legend(legend_t, 'location', 'Best');
lgd.FontSize = 14;
hold off;
hold off;

%Calculos de telelabo
Kp = size(length(mp_chi_array));
ti = size(length(mp_chi_array));
td = size(length(mp_chi_array));
td2 = size(length(mp_chi_array));
z_K_real = size(length(mp_chi_array));
z_ti_real = size(length(mp_chi_array));
z_td_real = size(length(mp_chi_array));
z_td2_real = size(length(mp_chi_array));
for i = 1:length(mp_chi_array)
    beta_array = beta_maximo(i)-5;
    Kp(i) = ((p^2)*((2*beta_array) + (1/mp_chi_array(i)^2)))/((beta2_array^2)*K);
    td(i) = (beta2_array*(beta_array - beta2_array + 2))/(p*((2*beta_array) + (1/mp_chi_array(i)^2)));
    ti(i) = (beta2_array*(mp_chi_array(i)^2)*((2*beta_array) + (1/mp_chi_array(i)^2)))/(beta_array*p);
    td2(i) = p / (K*Kp(i));
    z_K_real(i) = Kp(i);
    z_ti_real(i) = Kp(i) * (0.002/ti(i));
    z_td_real(i) = (Kp(i)*td(i)) / 0.002;
    z_td2_real(i) = (Kp(i)*td2(i)) / 0.002;
end