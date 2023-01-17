%% análisis de los ángulos de las articulaciones según tres marcadores

% Con este programa se elige lo primero de todo el archivo a analizar.
% Tras ellos se obtendrán los marcadores necesarios y sus coordenadas en X,
% Y y Z según la articulación deseada, los cuales vienen indicados en el
% código.
% Una vez han sido obtenidos se utiliza el marcador localizado en la
% articulación como vértice, y los localizados en los miembros superior e
% inferior como los vectores en dirección a dicho vértice.
% De ahí con una función se obtiene el ángulo y posteriormente se grafica.

%% elegimos el archivo que queremos analizar

clear
clc

% con esta función elegimos el archivo
% que queramos analizar
[filename, path] = uigetfile('*.csv'); 
csvpath = fullfile(path,filename); 
take = readmatrix(csvpath);
take = take(6:end,:);

%% calculo de angulo segun tres marcadores (cadera ad-abd)

for i = 1:length(take)
    % sacamos los puntos que nos interesan, en este caso para la cadera
    % izquierda rasis y rca actúan como los brazos de los vectores y lasis
    % como vértice. Para la derecha rasis es el vértice y lasis y lca los
    % brazos.
    lasispos = [take(i,10), take(i,11), take(i,12)]; 
    rasispos = [take(i,13), take(i,14), take(i,15)];
    lcapos = [take(i,157), take(i,158), take(i,159)];
    rcapos = [take(i,205), take(i,206), take(i,207)];

    % pasamos los puntos a vectores mediante la resta de los marcadores de
    % los extremos con el del vértice.
    rasis_lasis = -(rasispos-lasispos); 
    lca_lasis = (lcapos-lasispos);
    rca_rasis = (rcapos-rasispos);

    CosThetal = max(min(dot(rasis_lasis,lca_lasis)/(norm(rasis_lasis)*norm(lca_lasis)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rasis_lasis,rca_rasis)/(norm(rasis_lasis)*norm(rca_rasis)),1),-1);
    angr(i) = real(acosd(CosThetar)); % calculamos el angulo
end

%% ploteamos el angulo (cadera ad-abd)

figure

subplot(2,1,1)
plot(take(:,2), angl)
title("Abducción-adducción cadera izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Abducción-adducción cadera derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

%% cálculo de la desviación (cadera ad-abd)

% se realiza un cálculo de la desviación media y la desviación estándar 
% mediante las funcione spertinentes con respecto a la línea horizontal
% que representa la posición estirada.
meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para la cadera izquierda\n" + ...
    "y derecha respectivamente (ad-abd), con una desviación estándar de %f y %f grados\n", ...
    meanl, meanr, stdl, stdr)

%% calculo de angulo segun tres marcadores (cadera flex-ext)

for i = 1:length(take)
    % sacamos los puntos que nos interesan, en este caso para la cadera
    % izquierda lasis y lle actúan como los brazos de los vectores y lgt
    % como vértice. Para la derecha rgt es el vértice y rasis y rle los
    % brazos.
    lasispos = [take(i,10), take(i,11), take(i,12)];  % sacamos los puntos que nos interesan
    rasispos = [take(i,13), take(i,14), take(i,15)];
    lgtpos = [take(i,22), take(i,23), take(i,24)];
    rgtpos = [take(i,25), take(i,26), take(i,27)];
    llepos = [take(i,119), take(i,120), take(i,121)];
    rlepos = [take(i,167), take(i,168), take(i,169)];

    % pasamos los puntos a vectores mediante la resta de los marcadores de
    % los extremos con el del vértice.
    lgt_lasis = (lgtpos-lasispos); 
    lle_lgt = -(llepos-lgtpos);
    rgt_rasis = (rgtpos-rasispos);
    rle_rgt = -(rlepos-rgtpos);

    CosThetal = max(min(dot(lgt_lasis,lle_lgt)/(norm(lgt_lasis)*norm(lle_lgt)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rgt_rasis,rle_rgt)/(norm(rgt_rasis)*norm(rle_rgt)),1),-1);
    angr(i) = real(acosd(CosThetar)); % calculamos el angulo
end

%% ploteamos el angulo (cadera flex-ext)

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

%% cálculo de la desviación (cadera flex-ext)

% se realiza un cálculo de la desviación media y la desviación estándar 
% mediante las funcione spertinentes con respecto a la línea horizontal
% que representa la posición estirada.
meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para la cadera izquierda\n" + ...
    "y derecha respectivamente (flex-ext), con una desviación estándar de %f" + ...
    " y %f grados\n", meanl, meanr, stdl, stdr)

%% calculo de angulo segun tres marcadores (rodilla flex-ext)

for i = 1:length(take)
    % sacamos los puntos que nos interesan, en este caso para la cadera
    % izquierda lgt y llm actúan como los brazos de los vectores y lle
    % como vértice. Para la derecha rle es el vértice y rgt y rlm los
    % brazos.
    lgtpos = [take(i,22), take(i,23), take(i,24)];
    rgtpos = [take(i,25), take(i,26), take(i,27)];
    llepos = [take(i,119), take(i,120), take(i,121)];
    rlepos = [take(i,167), take(i,168), take(i,169)];
    llmpos = [take(i,132), take(i,133), take(i,134)];
    rlmpos = [take(i,180), take(i,181), take(i,182)];

    % pasamos los puntos a vectores mediante la resta de los marcadores de
    % los extremos con el del vértice.
    lgt_lle = -(llepos-lgtpos); 
    llm_lle = (llepos-llmpos);
    rgt_rle = -(rlepos-rgtpos); 
    rlm_rle = (rlepos-rlmpos);

    CosThetal = max(min(dot(lgt_lle,llm_lle)/(norm(lgt_lle)*norm(llm_lle)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rgt_rle,rlm_rle)/(norm(rgt_rle)*norm(rlm_rle)),1),-1);
    angr(i) = real(acosd(CosThetar)); 
end

%% ploteamos el angulo (rodilla flex-ext)

figure

subplot(2,1,1)
plot(take(:,2), angl)
title("Flexión-extensión rodilla izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Flexión-extensión rodilla derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

figure

plot(take(:,2), angl)
title("Flexión-extensión rodilla")
hold on     
plot(take(:,2), angr)
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off
legend("Rodilla izquierda", "Rodilla derecha")

%% cálculo de la desviación (rodilla flex-ext)

% se realiza un cálculo de la desviación media y la desviación estándar 
% mediante las funcione spertinentes con respecto a la línea horizontal
% que representa la posición estirada.
meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para la rodilla izquierda\n" + ...
    "y derecha respectivamente, con una desviación estándar de %f y %f grados\n", ...
    meanl, meanr, stdl, stdr)

%% calculo de angulo segun tres marcadores (tobillo flex-ext)

for i = 1:length(take)
    % sacamos los puntos que nos interesan, en este caso para la cadera
    % izquierda lhf y lvm actúan como los brazos de los vectores y llm
    % como vértice. Para la derecha rlm es el vértice y rhf y rvm los
    % brazos.
    lhfpos = [take(i,141), take(i,142), take(i,143)];
    rhfpos = [take(i,189), take(i,190), take(i,191)];
    llmpos = [take(i,132), take(i,133), take(i,134)];
    rlmpos = [take(i,180), take(i,181), take(i,182)];
    lvmpos = [take(i,151), take(i,152), take(i,153)];
    rvmpos = [take(i,199), take(i,200), take(i,201)];

    % pasamos los puntos a vectores mediante la resta de los marcadores de
    % los extremos con el del vértice.
    lhf_llm = -(lhfpos-llmpos); 
    lvm_llm = (lvmpos-llmpos);
    rhf_rlm = -(rhfpos-rlmpos); 
    rvm_rlm = (rvmpos-rlmpos);

    CosThetal = max(min(dot(lhf_llm,lvm_llm)/(norm(lhf_llm)*norm(lvm_llm)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rhf_rlm,rvm_rlm)/(norm(rhf_rlm)*norm(rvm_rlm)),1),-1);
    angr(i) = real(acosd(CosThetar)); 
end

%% ploteamos el angulo (tobillo flex-ext)

figure

subplot(2,1,1)
plot(take(:,2), angl)
title("Flexión-extensión tobillo izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Flexión-extensión tobillo derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off

figure

plot(take(:,2), angl)
title("Flexión-extensión tobillo")
hold on
plot(take(:,2), angr)
xlabel("Tiempo (s)")
ylabel("Ángulo (º)")
hold off
legend("Tobillo izquierdo", "Tobillo derecho")

%% cálculo de la desviación (tobillo flex-ext)

% se realiza un cálculo de la desviación media y la desviación estándar 
% mediante las funcione spertinentes con respecto a la línea horizontal
% que representa la posición estirada.
meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para el tobillo izquierdo\n" + ...
    "y derecho respectivamente, con una desviación estándar de %f y %f grados\n", ...
    meanl, meanr, stdl, stdr);