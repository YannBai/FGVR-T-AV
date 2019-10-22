% TANKEVALSEG Evaluates a set of segmentation results.
% TANKEVALSEG(TANKopts); prints out the per class and overall
% segmentation accuracies. Accuracies are given using the intersection/union 
% metric:
%   true positives / (true positives + false positives + false negatives) 

function [accuracies,avacc,conf,rawcounts] = Tankevalseg(TANKopts)

% image test set
[gtids]=textread([TANKopts.seg.imgsetpath,'/',TANKopts.testset],'%s');%groudtruth id

% number of labels = number of classes plus one for the background
num = TANKopts.nclasses+1; 
confcounts = zeros(num);
count=0;

num_missing_img = 0;

tic;
for i=1:length(gtids)
    % display progress
    if toc>1
        fprintf('test confusion: %d/%d\n',i,length(gtids));
        drawnow;
        tic;
    end
        
    imname = [gtids{i},'.png'];
    %fprintf('pic: %s\n',imname);%by
    % ground truth label file
    gtfile = [TANKopts.seg.clsimgpath,'/',imname];
    [gtim,map] = imread(gtfile);    
    gtim = double(gtim);
    
    % results file
    resfile = [TANKopts.seg.clsrespath,'/',imname];
    try
      [resim,map] = imread(resfile);
    catch err
      num_missing_img = num_missing_img + 1;
      %fprintf(1, 'Fail to read %s\n', resfile);
      continue;
    end

    resim = double(resim);
    
    % Check validity of results image
    maxlabel = max(resim(:));
    if (maxlabel>TANKopts.nclasses)
        error('Results image ''%s'' has out of range value %d (the value should be <= %d)',imname,maxlabel,TANKopts.nclasses);
    end

    szgtim = size(gtim); szresim = size(resim);
    if any(szgtim~=szresim)
        error('Results image ''%s'' is the wrong size, was %d x %d, should be %d x %d.',imname,szresim(1),szresim(2),szgtim(1),szgtim(2));
    end
    
    %pixel locations to include in computation
    locs = gtim<255;
    
    % joint histogram
    sumim = 1+gtim+resim*num;
    hs = histc(sumim(locs),1:num*num);
    count = count + numel(find(locs));
    confcounts(:) = confcounts(:) + hs(:);
end

if (num_missing_img > 0)
  fprintf(1, 'WARNING: There are %d missing results!\n', num_missing_img);
end

% confusion matrix - first index is true label, second is inferred label
%conf = zeros(num);
conf = 100*confcounts./repmat(1E-20+sum(confcounts,2),[1 size(confcounts,2)]);
rawcounts = confcounts;

% Pixel Accuracy
overall_acc = 100*sum(diag(confcounts)) / sum(confcounts(:));
fprintf('Percentage of pixels correctly labelled overall: %6.3f%%\n',overall_acc);

% Class Accuracy
class_acc = zeros(1, num);
class_count = 0;
fprintf('Accuracy for each class (pixel accuracy)\n');
for i = 1 : num
    denom = sum(confcounts(i, :));
    if (denom == 0)
        denom = 1;
    end
    class_acc(i) = 100 * confcounts(i, i) / denom; 
    if i == 1
      clname = 'background';
    else
      clname = TANKopts.classes{i-1};
    end
    
    if ~strcmp(clname, 'void')
        class_count = class_count + 1;
        fprintf('  %14s: %6.3f%%\n', clname, class_acc(i));
    end
end
fprintf('-------------------------\n');
avg_class_acc = sum(class_acc) / (class_count-3);
fprintf('Mean Class Accuracy: %6.3f%%\n', avg_class_acc);

% Pixel IOU
accuracies = zeros(TANKopts.nclasses,1);
fprintf('Accuracy for each class (intersection/union measure)\n');

real_class_count = 0;

for j=1:num
   
   gtj=sum(confcounts(j,:));
   resj=sum(confcounts(:,j));
   gtjresj=confcounts(j,j);
   % The accuracy is: true positive / (true positive + false positive + false negative) 
   % which is equivalent to the following percentage:
   denom = (gtj+resj-gtjresj);

   if denom == 0
     denom = 1;
   end
   
   accuracies(j)=100*gtjresj/denom;
   
   clname = 'background';
   if (j>1), clname = TANKopts.classes{j-1};
   end
   
   if ~strcmp(clname, 'void')
       real_class_count = real_class_count + 1;
   else
       if denom ~= 1
           fprintf(1, 'WARNING: this void class has denom = %d\n', denom);
       end
   end
   
   if ~strcmp(clname, 'void')
       fprintf('  %14s: %6.3f%%\n',clname,accuracies(j));
   end
end

%accuracies = accuracies(1:end);
%avacc = mean(accuracies);
avacc = sum(accuracies) / (real_class_count);

fprintf('-------------------------\n');
fprintf('Average accuracy: %6.3f%%\n',avacc);
fprintf('Your final result is: %6.3f%%\n',avacc);
