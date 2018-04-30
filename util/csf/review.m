clear;

figure;

leg = {};

c = 0:1/1023:1;

% SMPTE ST 2084
L_PQ = 10000*((max(c.^(1 / 78.84375) - 0.8359375, 0)./(18.8515625 - 18.6875 * c.^(1 / 78.84375))) .^ (1 / 0.1593017578125));
L1_PQ = L_PQ(1:end-1);
contrastPQ = (L_PQ(2:end) - L1_PQ)./L1_PQ;
contrastPQ(1) = 1e5;
loglog(L1_PQ, contrastPQ*100); grid on; hold on;
leg = [leg {'PQ'}];

% Global Cone Response Model (GCRM)
Y = linspace(10^-5, 10^4, 1024);
L_G = gcrm(Y, 10);
L1_G = L_G(1:end-1);
contrastGCRM = (L_G(2:end) - L1_G) ./ L1_G;
loglog(L1_G, contrastGCRM*100);
leg = [leg {'GCRM'}];

% Barten
% barten = csvread('barten.csv');
% L_barten = barten(10);
% %L_barten = gdf_jnd(10);
% L1_barten = L_barten(1:end-1);
% contrastBarten = (L_barten(2:end) - L1_barten)./L1_barten;
% loglog(L1_barten, contrastBarten*100);
% leg = [leg {'GDF'}];

% % BBC HLG
% hlg = HLG();
% L_hlg = 10000*hlg.Decompress(c);
% L1_hlg = L_hlg(1:end-1);
% contrastHLG = (L_hlg(2:end) - L1_hlg)./L1_hlg;
% loglog(L1_hlg, contrastHLG*100);
% leg = [leg {'HLG'}];
% 
% % Fraunhofer
L_fraun = fraunhofer(1:1:1024);
L1_fraun = L_fraun(1:end-1);
contrastFraun = (L_fraun(2:end) - L1_fraun) ./ L1_fraun;
loglog(L1_fraun, contrastFraun*100);
leg = [leg {'LogLuV'}];
% 
% % HDRV
pur=csvread('purafal.csv');
L_hdrv = pur(:,1)';
L1_hdrv = L_hdrv(1:end-1);
contrastHDRV = (L_hdrv(2:end) - L1_hdrv) ./ L1_hdrv;
loglog(L1_hdrv, contrastHDRV*100);
leg = [leg {'HDRV'}];
% 
% % PROPOSED
L = 1:1:1024;
L_pr = proposed(L);
L1_pr = L_pr(1:end-1);
c_pr = (L_pr(2:end) - L1_pr)./L1_pr;
loglog(L1_pr, c_pr*100);
leg = [leg {'PROPOSED'}];
% 
% BT.2246 Barten
%Lbt2246 = bt2246(1);

%legend('SMTPE ST 2084', 'tf(x) = x^{2.2}', 'tf(x) = x^4', 'tf(x) = x^8', 'Barten DICOM', 'HLG', 'Fraunhofer', 'HDRV');
legend(leg);
xlabel('Luminance (cd/m^2)');
ylabel('Contrast (%)');
axis([1e-4 1e4 1e-1 1e2]);
