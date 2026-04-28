clear all;
close all;
clc;

% Parámetros (Valores de ejemplo)
m = 85;       % Masa total (kg)
B = 2.5;      % Fricción viscosa equivalente (N*s/m)
r = 0.33;     % Radio de la rueda (m)
R = 0.5;      % Resistencia del devanado (Ohm)
L = 0.01;     % Inductancia (H)
Kt = 1.2;     % Constante de torque (N*m/A)
Ke = 1.2;     % Constante de fuerza electromotriz (V*s/rad)

% Matrices de Espacio de Estados
% x = [v; i] -> Vector de estados
A = [-B/m,   Kt/(m*r);
     -Ke/(L*r), -R/L];

B_mat = [0; 
         1/L];

C = [1, 0;   % Salida 1: Velocidad
     0, 1];  % Salida 2: Corriente

D = [0; 0];

% Crear el modelo en MATLAB
sys_bicicleta = ss(A, B_mat, C, D)
sys_bicicleta.InputName = 'Tensión';
sys_bicicleta.OutputName = {'Velocidad', 'Corriente'};


%Funcion de transferencia
H=tf(sys_bicicleta)

% --- ANÁLISIS DE CONTROLABILIDAD ---
% Calculo de la matriz de controlabilidad (Co)
Co = ctrb(A, B_mat);
rango_controlabilidad = rank(Co);
n = size(A, 1); % Dimension del sistema

fprintf('--- Análisis de Controlabilidad ---\n');
fprintf('Rango de la matriz Co: %d\n', rango_controlabilidad);
if rango_controlabilidad == n
    disp('El sistema es completamente CONTROLABLE.');
else
    disp('El sistema NO es completamente controlable.');
end

% --- ANÁLISIS DE OBSERVABILIDAD ---
% Calculo la matriz de observabilidad (Ob)
Ob = obsv(A, C);
rango_observabilidad = rank(Ob);

fprintf('\n--- Análisis de Observabilidad ---\n');
fprintf('Rango de la matriz Ob: %d\n', rango_observabilidad);
if rango_observabilidad == n
    disp('El sistema es completamente OBSERVABLE.');
else
    disp('El sistema NO es completamente observable.');
end

% --- ANÁLISIS DE ESTABILIDAD ---
polos = eig(A);
fprintf('\n--- Análisis de Estabilidad ---\n');
disp('Autovalores del sistema (Polos):');
disp(polos);

if all(real(polos) < 0)
    disp('El sistema es asintóticamente estable.');
else
    disp('El sistema es inestable o marginalmente estable.');
end


