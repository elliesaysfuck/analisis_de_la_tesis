%% elegimos el archivo que queremos analizar

clear
clc

% con esta función elegimos el archivo
% que queramos analizar
[filename, path] = uigetfile('*.csv'); 
csvpath = fullfile(path,filename); 
take = readmatrix(csvpath);
% las 8 primeras filas no nos interesan así que las quitamos, si queremos
% quitar frames cambiaremos los valores
take = take(8:length(take), :); 

%% calculo de angulo segun tres marcadores

for i = 1:length(take)
    lasispos = [take(i,10), take(i,11), take(i,12)];  % sacamos los puntos que nos interesan
    rasispos = [take(i,13), take(i,14), take(i,15)];
    lcapos = [take(i,157), take(i,158), take(i,159)];
    rcapos = [take(i,205), take(i,206), take(i,207)];

    rasis_lasis = -(rasispos-lasispos); % pasamos los puntos a vectores
    lca_lasis = (lcapos-lasispos);
    rca_rasis = (rcapos-rasispos);

    CosThetal = max(min(dot(rasis_lasis,lca_lasis)/(norm(rasis_lasis)*norm(lca_lasis)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rasis_lasis,rca_rasis)/(norm(rasis_lasis)*norm(rca_rasis)),1),-1);
    angr(i) = real(acosd(CosThetar)); % calculamos el angulo
end

%% ploteamos el angulo

subplot(2,1,1)
plot(take(:,2), angl)
title("Abducción-adducción cadera izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Abducción-adducción cadera derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
hold off

%% cálculo de la desviación

meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para la cadera izquierda\n" + ...
    "y derecha respectivamente, con una desviación estándar de %f y %f grados", ...
    meanl, meanr, stdl, stdr)