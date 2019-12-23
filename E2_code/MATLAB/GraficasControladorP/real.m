%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% ref = 2PI %%%%%%%%%%%%%%
critic = textread('ControlP_K29.341.dat');
sobre = textread('ControlP_K14.66.dat');
sub = textread('ControlP_K162.957.dat');
figure(1);
hold on
xlabel("Tiempo (ms)");
ylabel("Posición Angular (rad)");
grid;
x = critic(:,1);
y1 = critic(:,2);
y2 = sobre(:,2);
y3 = sub(:,2);
referencia = (x./x)*(2*pi);
plot(x,referencia)
plot(x,y1)
plot(x,y2)
plot(x,y3)
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% ref = PI %%%%%%%%%%%%%%
critic_pi = textread('ControlP_K29.341_pi.dat');
sobre_pi = textread('ControlP_K14.66_pi.dat');
sub_pi = textread('ControlP_K162.957_pi.dat');
figure(2);
hold on
xlabel("Tiempo (ms)");
ylabel("Posición Angular (rad)");
grid;
x_pi = critic_pi(:,1);
y1_pi = critic_pi(:,2);
y2_pi = sobre_pi(:,2);
y3_pi = sub_pi(:,2);
referencia_pi = (x_pi./x_pi)*(pi);
plot(x_pi,referencia_pi)
plot(x_pi,y1_pi)
plot(x_pi,y2_pi)
plot(x_pi,y3_pi)
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% ref = -PI %%%%%%%%%%%%%%
critic_mpi = textread('ControlP_K29.341_-pi.dat');
sobre_mpi = textread('ControlP_K14.66_-pi.dat');
sub_mpi = textread('ControlP_K162.957_-pi.dat');
figure(3);
hold on
xlabel("Tiempo (ms)");
ylabel("Posición Angular (rad)");
grid;
x_mpi = critic_mpi(:,1);
y1_mpi = critic_mpi(:,2);
y2_mpi = sobre_mpi(:,2);
y3_mpi = sub_mpi(:,2);
referencia_mpi = (x_mpi./x_mpi)*(-pi);
plot(x_mpi,referencia_mpi)
plot(x_mpi,y1_mpi)
plot(x_mpi,y2_mpi)
plot(x_mpi,y3_mpi)
hold off
