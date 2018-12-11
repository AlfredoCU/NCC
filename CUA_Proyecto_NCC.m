%% Proyecto: NCC.
% Programador: Alfredo Carréon Urbano.
% Fecha: 23 de noviembre de 2018.
% Programa: Correlación Cruzada Normalizada con Evolución Diferencial con 
% Penalización.

clear all;
close all;
clc;

%% Imagenes del code main.
img = imread('Image_1.bmp');  % Imagen 1 completa.
temp = imread('Template.bmp'); % Imagen temporal a buscar.

img_g = rgb2gray(img);
temp_g = rgb2gray(temp);

[img_H,img_W] = size(img_g);
[temp_H,temp_W] = size(temp_g);

% Función NCC.
fun = @(x,y) NCC(img_g,temp_g,x,y);

% Limites.
xl = [1; 1];
xu = [img_W-temp_W; img_H-temp_H];

% Valores entre más se acerque a 1, más coincide la imagen que buscas.
val_max = -1;
xp = 0;
yp = 0;

%% Algoritmo ED.
% Inicializar los valores.
F = 0.8;
CR = 0.5; 
G = 100;
N = 70;
D = 2;

x = zeros(D,N); 
v = zeros(D,N); 
u = zeros(D,N); 
fitness = zeros(1,N);

for i=1:N
    x(:,i) = fix(xl + (xu-xl).*rand(D,1));
end

% Evolución Diferencial.
for gen=1:G   
    for i=1:N 
        fitness(i) = fun(x(1,i),x(2,i));
     
        r1 = randi([1,N]);
        r2 = randi([1,N]);
        r3 = randi([1,N]);
        
        while(r1 == r2 || r2 == r3 || r1 == i || r2 == i || r3 == i)
            r1 = randi([1,N]);
            r2 = randi([1,N]);
            r3 = randi([1,N]);
        end
        
        v(:,i) = fix(x(:,r1) + F *((x(:,r2)) - (x(:,r3))));        
        ra = rand;
        
        for j=1:D      
            if(ra <= CR)
                u(j,i) = v(j,i);
            else
                u(j,i) = x(j,i);
            end
        end
        
        % Cálculo de Penalización.
        for j=1:D      
            if(xl(j) <= u(j,i) && xu(j) >= u(j,i))
                u(j,i) = u(j,i);
            else
                u(j,i) = fix(xl(j)+(xu(j)-xl(j))*rand);
            end
        end
                    
        if(fun(u(1,i),u(2,i)) > fun(x(1,i),x(2,i))) % Comparación incluyendo penalización.
            x(:,i) = u(:,i);
        end
        
        if(fun(x(1,i),x(2,i)) > val_max)
            val_max = fun(x(1,i),x(2,i));
            xp = x(1,i);
            yp = x(2,i);
        end
        
        % if val_max>0.95
        %     break
        % end        
    end
    
%% Mostrar la imagen.
    imshow(img);   
    line([xp xp+temp_W], [yp yp],'Color','g','LineWidth',3);
    line([xp xp], [yp yp+temp_H],'Color','g','LineWidth',3);
    line([xp+temp_W xp+temp_W], [yp yp+temp_H],'Color','g','LineWidth',3);
    line([xp xp+temp_W], [yp+temp_H yp+temp_H],'Color','g','LineWidth',3);
end