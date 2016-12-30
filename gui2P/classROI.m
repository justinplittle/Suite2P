function h = classROI(h)

[~, filename1] = fileparts(h.dat.cl.fpath);
set(h.text50,'String', [filename1 '.mat']);

st = h.st;
prior = h.prior;
statLabels = h.statLabels;

load(h.dat.cl.fpath);
% st = h.dat.st;
% statLabels = h.dat.statLabels;
stat = h.dat.stat;

ilbl = false(1, numel(statLabels));
% st0 = repmat( mean(st,1), numel(stat), 1);
st0 = zeros( numel(stat), numel(statLabels));
for j = 1:numel(statLabels)
    if isfield(stat, statLabels{j})
        ilbl(j) = true;
        st0(:,j) = eval(sprintf('[stat.%s]', statLabels{j}));
    end
end
st0(isnan(st0)) = 2;
ilbl(1) = false;

model       = buildaLDA(prior, st, statLabels(ilbl));
[Ypred, ps] = evaluateLDA(model, st0);

for j = 1:length(stat)
   stat(j).iscell = Ypred(j) > h.dat.cl.threshold; 
   stat(j).cellProb  = Ypred(j); 
end

statLabels = statLabels(ilbl);
h.dat.stat = stat;

h.st0 = st0;
h.statLabels = statLabels;

% h.dat.cl.rands = 0.1 + .8 * Ypred;    

% set(h.text51,'String', fname);