clear;
%Características de la función del motor
K = 22233201.58;
reductora = 23.04;
p1 = 8382.70;
p2 = 64.986;
num = K/reductora;
den = [1 p1+p2 p1*p2 0];
%Función de lazo abierto del motor
Habierto = tf(num,den);
%Función de lazo cerrado del motor
Hcerrado = Habierto/(1+Habierto);
%Gráficas toleranica 2%
tolerancia = 0.025;
duracion = (0:0.1:100)';
limitesuperior = size(length(duracion));
limiteinferior = size(length(duracion));
for i = 1:length(duracion)
    limitesuperior(i) = 1 + tolerancia;  
    limiteinferior(i) = 1 - tolerancia;
end
%Grafica de Bode del sistema en lazo abierto
figure(1)
bode(Habierto)

%Gráfica de Nyquist del sistema de lazo abierto
figure(2)
nyquist(Habierto, 'r');
axis([-1.5 1.5 -1.5 1.5])
hold on;
t=0:0.001:2*pi; 
x1=cos(t);
x2=sin(t); 
plot(x1,x2, 'b');
[Gm,Pm,Wgm,Wpm] = margin(Habierto);
legend_name = strcat('MG=', num2str(Gm), ' MF=', num2str(Pm));
lgd = legend(legend_name, 'location', 'Best');
lgd.FontSize = 14;
hold off;
%Gráfica de la respuesta al escalón en lazo cerrado
figure(3)
hold on;
step(Hcerrado);
axis([0 5 0 1.2])
hold on;
plot(duracion, limitesuperior);
hold on
plot(duracion, limiteinferior);
title('Respuesta al escalón en lazo cerrado');
hold off;
%Controlador P para variar el MG que produce saturación
MGnuevo = 20;
kp = Gm/MGnuevo;
Hnuevo = tf(kp*num, den);
figure(4)
nyquist(Hnuevo, 'r');
axis([-1.5 1.5 -1.5 1.5])
hold on;
t=0:0.001:2*pi; 
x1=cos(t);
x2=sin(t); 
plot(x1,x2, 'b');
[Gm2,Pm2,Wgm2,Wpm2] = margin(Hnuevo);
legend_name = strcat('MG=', num2str(Gm2), ' MF=', num2str(Pm2));
lgd = legend(legend_name, 'location', 'Best');
lgd.FontSize = 14;
hold off;
%Gráfica de la respuesta al escalón en lazo cerrado
HcerradoP=Hnuevo/(1+Hnuevo);
figure(5)
hold on;
step(HcerradoP);
axis([0 1 0 2])
hold on;
plot(duracion, limitesuperior);
hold on
plot(duracion, limiteinferior);
title('Respuesta al escalón en lazo cerrado');
hold off;

%Controlador PID para variar el MF que produce oscilaciones
porcentaje_ti = 0.25;
radio_deseado = 1;
MF_deseado = 60;
fase_corregida = MF_deseado - Pm2;

ti = (1/(2*Wpm2*porcentaje_ti))*(tand(fase_corregida)+sqrt((4*porcentaje_ti)+(tand(fase_corregida))^2));
td = porcentaje_ti * ti;
Kpid = kp * radio_deseado * cosd(fase_corregida);

num_pid = [Kpid*ti*td Kpid*ti Kpid];
den_pid = [ti 0];
Hpid = tf(num_pid, den_pid);

Hnuevo2 = Habierto*Hpid;

figure(6)
nyquist(Hnuevo2, 'r');
axis([-1.5 1.5 -1.5 1.5])
hold on;
t=0:0.001:2*pi; 
x1=cos(t);
x2=sin(t); 
plot(x1,x2, 'b');
[Gm3,Pm3,Wcp3,Wcg3] = margin(Hnuevo2);
legend_name = strcat('MG=', num2str(Gm3), ' MF=', num2str(Pm3));
lgd = legend(legend_name, 'location', 'Best');
lgd.FontSize = 14;
hold off;
%Gráfica de la respuesta al escalón en lazo cerrado
HcerradoPID=Hnuevo2/(1+Hnuevo2);
figure(7)
hold on;
step(HcerradoPID);
axis([0 0.25 0 1.5])
hold on;
plot(duracion, limitesuperior);
hold on
plot(duracion, limiteinferior);
title('Respuesta al escalón en lazo cerrado');
hold off;

hold off;

z_K_real = Kpid;
z_ti_real = Kpid * (0.002/ti);
z_td_real = (Kpid*td) / 0.002;