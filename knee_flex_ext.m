%% elegimos el archivo que queremos analizar

clear
clc

% con esta función elegimos el archivo
% que queramos analizar
[filename, path] = uigetfile('*.csv');
csvpath = fullfile(path,filename);
take_uncut = readmatrix(csvpath);
% las 8 primeras filas no nos interesan así que las quitamos, si queremos
% quitar frames cambiaremos los valores
take = take_uncut(8:length(take_uncut), :); 

%% calculo de angulo segun tres marcadores

for i = 1:length(take)
    lgtpos = [take(i,22), take(i,23), take(i,24)];
    rgtpos = [take(i,25), take(i,26), take(i,27)];
    llepos = [take(i,119), take(i,120), take(i,121)];
    rlepos = [take(i,167), take(i,168), take(i,169)];
    llmpos = [take(i,132), take(i,133), take(i,134)];
    rlmpos = [take(i,180), take(i,181), take(i,182)];

    lgt_lle = -(llepos-lgtpos); % pasamos los puntos a vectores
    llm_lle = (llepos-llmpos);
    rgt_rle = -(rlepos-rgtpos); 
    rlm_rle = (rlepos-rlmpos);

    CosThetal = max(min(dot(lgt_lle,llm_lle)/(norm(lgt_lle)*norm(llm_lle)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rgt_rle,rlm_rle)/(norm(rgt_rle)*norm(rlm_rle)),1),-1);
    angr(i) = real(acosd(CosThetar)); 
end

%% ploteamos el angulo

figure

subplot(2,1,1)
plot(take(:,2), angl)
title("Flexión-extensión rodilla izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Flexión-extensión rodilla derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
hold off

figure

plot(take(:,2), angl)
title("Flexión-extensión rodilla")
hold on
plot(take(:,2), angr)
hold off
legend("Rodilla izquierda", "Rodilla derecha")

%% cálculo de la desviación

meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para la rodilla izquierda\n" + ...
    "y derecha respectivamente, con una desviación estándar de %f y %f grados", ...
    meanl, meanr, stdl, stdr)