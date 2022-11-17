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
    lasispos = [take(i,10), take(i,11), take(i,12)];  % sacamos los puntos que nos interesan
    rasispos = [take(i,13), take(i,14), take(i,15)];
    lgtpos = [take(i,22), take(i,23), take(i,24)];
    rgtpos = [take(i,25), take(i,26), take(i,27)];
    llepos = [take(i,119), take(i,120), take(i,121)];
    rlepos = [take(i,167), take(i,168), take(i,169)];

    lgt_lasis = (lgtpos-lasispos); % pasamos los puntos a vectores
    lle_lgt = -(llepos-lgtpos);
    rgt_rasis = (rgtpos-rasispos);
    rle_rgt = -(rlepos-rgtpos);

    CosThetal = max(min(dot(lgt_lasis,lle_lgt)/(norm(lgt_lasis)*norm(lle_lgt)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rgt_rasis,rle_rgt)/(norm(rgt_rasis)*norm(rle_rgt)),1),-1);
    angr(i) = real(acosd(CosThetar)); % calculamos el angulo
end

% angl = angl-angl(1);
% angr = angr-angr(1);

%% ploteamos el angulo

figure

subplot(2,1,1)
plot(take(:,2), angl)
title("Flexión-extensión cadera izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Flexión-extensión cadera derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

figure

plot(take(:,2), angl)
title("Flexión-extensión cadera")
hold on
plot(take(:,2), angr)
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off
legend("Cadera izquierda", "Cadera derecha")

%% cálculo de la desviación

meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para la cadera izquierda\n" + ...
    "y derecha respectivamente, con una desviación estándar de %f y %f grados", ...
    meanl, meanr, stdl, stdr)