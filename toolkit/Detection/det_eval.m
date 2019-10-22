% change this path if your code elsewhere
addpath([cd '/code']);

% initialize detection options
PRCVopts = det_init;
aps=0;
% test detector for each class
for i=1:PRCVopts.nclasses
    cls=PRCVopts.classes{i};
    [~,~,ap] = evaldet(PRCVopts,cls,false);  % compute recall prec and ap 
    aps=aps+ap;
    if i<PRCVopts.nclasses
        drawnow;
    else
        map=aps/PRCVopts.nclasses;
        fprintf('MAP = %.3f\n',map)
    end
end

