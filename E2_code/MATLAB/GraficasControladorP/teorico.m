%% Datos motor simplificado
K = 1.84E+04;
p = 38.1267;
%% Señales de referencia

t=0:0.001:1;
u=heaviside(t);     % Escalón unidad
u3=(1/2)*t.^2;      % Parábola
u2=t;               % Rampa

%% parametros de diseño 
v = 0.02;
chi = input(sprintf('Introduzca un valor de amortiguamiento: '));
LeyendaP = strcat('\chi = ',num2str(chi));

%Calculo de los parametros para cada valor de zeta
%Frecuencia natural
wn = p/(2*chi);
%Sobreelongacion maxima
Mp = exp(-(chi/sqrt(1-chi^2))*pi); 
%Tiempo de establecimiento
ts = (log(1/(v*sqrt(1-chi^2))))/(chi*wn);
%Ganancia proporcional
Kp = p^2/(4*chi^2*K);

%Salida en formato tabla de los valores calculados
Valores_Calculados = table(chi,wn,Mp,ts,Kp);
    
%FUNCION DE TRANSFERENCIA H(s)
Num_H = [K*Kp];
Den_H = [1 p K*Kp];
Hc = tf(Num_H,Den_H);

%Funcion error He(s)
Num_He = [1 p 0];
Den_He = [1 p K*Kp];
He = tf(Num_He,Den_He);

%Respuesta a escalon unidad

figure;
[y1,x]=lsim(Num_H,Den_H,u,t);
[e1,x]=lsim(Num_He,Den_He,u,t);
plot(t,y1, 'b', 'Linewidth', 1.5);
hold on;
plot(t,e1, 'r', 'Linewidth', 1.5);
hold on;
plot(t,u,'g', 'Linewidth', 1);
grid;
title('Respuesta al escalón unidad');
xlabel('Tiempo (segundos)');
ylabel('Amplitud');
legend(LeyendaP,'error','Referencia');
hold off;

%Respuesta a la rampa
figure;
[y2,x]=lsim(Num_H,Den_H,u2,t); 
[e2,x]=lsim(Num_He,Den_He,u2,t);
plot(t,y2,'Linewidth',1.5);
hold on;
plot(t,e2, 'r', 'Linewidth', 1.5);
hold on;
plot(t,u2, 'g','Linewidth',1);
grid;
title('Respuesta a la rampa');
xlabel('Tiempo (segundos)');
ylabel('Amplitud');
legend(LeyendaP,'error','Referencia');
hold off;

%Respuesta a la parábola
figure;
[y3,x]=lsim(Num_H,Den_H,u3,t); 
[e3,x]=lsim(Num_He,Den_He,u3,t);
plot(t,y3,'Linewidth',1.5);
hold on;
plot(t,e3, 'r', 'Linewidth', 1.5);
hold on;
plot(t,u3, 'g','Linewidth',1);
grid;
title('Respuesta a la parábola');
xlabel('Tiempo (segundos)');
ylabel('Amplitud');
legend(LeyendaP,'error','Referencia');
hold off;



