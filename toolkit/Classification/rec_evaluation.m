% function [top1,top2] = rec_evaluation(result_file)
    gt_id = './gt/val.txt';
    result_file = './results/results.txt';
    f_GT_id = fopen(gt_id, 'r');
    f_predict_id = fopen(result_file, 'r');

    predict_map = containers.Map();
    while ~feof(f_predict_id)
        str = fgetl(f_predict_id);
        img_name = str(1:strfind(str, '.jpg')+4);
        top_1 = str2num(str(strfind(str, 'top1')+6 : strfind(str, 'top5')-1));
        top_5_str = strsplit(str(strfind(str, 'top5')+6 : end));

        top_5 = zeros(1,5);
        top_5(1) = str2num(top_5_str{1});
        top_5(2) = str2num(top_5_str{2});
        top_5(3) = str2num(top_5_str{3});
        top_5(4) = str2num(top_5_str{4});
        top_5(5) = str2num(top_5_str{5});
        predict_map(img_name) = {top_1, top_5};
    end

    total_num = 0;
    top1_correct = 0;
    top5_correct = 0;

    while ~feof(f_GT_id)
        total_num = total_num + 1;
        str = fgetl(f_GT_id);

        img_name = str(1:strfind(str, '.jpg')+4);
        cls_GT = str2num(str(strfind(str, '.jpg')+6:end));

        img_score = predict_map(img_name);
        if ismember(cls_GT,img_score{2})
            top5_correct = top5_correct +1;
            if cls_GT == img_score{1}
                top1_correct = top1_correct +1;
            end
        end

    end

    top1_accuracy = double(top1_correct) / double(total_num);
    top5_accuracy = double(top5_correct) / double(total_num);
    fprintf('top1_accuracy: %f\n',  top1_accuracy);
    fprintf('top5_accuracy: %f\n',  top5_accuracy);
    top1 = top1_accuracy;
    top2 = top5_accuracy;

    fclose(f_GT_id);
    fclose(f_predict_id);
% end
