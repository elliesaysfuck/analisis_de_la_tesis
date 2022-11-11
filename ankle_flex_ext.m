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
    lhfpos = [take(i,141), take(i,142), take(i,143)];
    rhfpos = [take(i,189), take(i,190), take(i,191)];
    llmpos = [take(i,132), take(i,133), take(i,134)];
    rlmpos = [take(i,180), take(i,181), take(i,182)];
    lvmpos = [take(i,151), take(i,152), take(i,153)];
    rvmpos = [take(i,199), take(i,200), take(i,201)];

    lhf_llm = -(lhfpos-llmpos); % pasamos los puntos a vectores
    lvm_llm = (lvmpos-llmpos);
    rhf_rlm = -(rhfpos-rlmpos); 
    rvm_rlm = (rvmpos-rlmpos);

    CosThetal = max(min(dot(lhf_llm,lvm_llm)/(norm(lhf_llm)*norm(lvm_llm)),1),-1);
    angl(i) = real(acosd(CosThetal)); % calculamos el angulo
    CosThetar = max(min(dot(rhf_rlm,rvm_rlm)/(norm(rhf_rlm)*norm(rvm_rlm)),1),-1);
    angr(i) = real(acosd(CosThetar)); 
end

%% ploteamos el angulo

figure

subplot(2,1,1)
plot(take(:,2), angl)
title("Flexión-extensión tobillo izquierda")
hold on
plot([min(take(:,2)), max(take(:,2))], [angl(1), angl(1)])
hold off

subplot(2,1,2)
plot(take(:,2), angr)
title("Flexión-extensión tobillo derecha")
hold on
plot([min(take(:,2)), max(take(:,2))], [angr(1), angr(1)])
hold off

figure

plot(take(:,2), angl)
title("Flexión-extensión tobillo")
hold on
plot(take(:,2), angr)
hold off
legend("Tobillo izquierdo", "Tobillo derecho")

%% cálculo de la desviación

meanl = mean(abs(angl-angl(1)));
meanr = mean(abs(angr-angr(1)));
stdl = std(angl-angl(1));
stdr = std(angr-angr(1));

fprintf("La desviación media es de %f y %f grados para el tobillo izquierdo\n" + ...
    "y derecho respectivamente, con una desviación estándar de %f y %f grados", ...
    meanl, meanr, stdl, stdr);