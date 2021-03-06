% this script generate train/val partation and generate test images 
rand('seed',0)

load ./../../data/RAP_annotation/RAP_annotation.mat

train_ids = RAP_annotation.partition_reid.train_identity;
test_ids = RAP_annotation.partition_reid.test_identity;
person_identity = RAP_annotation.person_identity;
images_name = RAP_annotation.name;

images_root = '.';


% generate the train/val and trainval images for training the classification model
train_ids_cnt = length(train_ids);
train_ids_map = 0:train_ids_cnt-1;

fid_train = fopen('classification/rap2_ide_train.txt', 'w+');
fid_val = fopen('classification/rap2_ide_val.txt', 'w+');
fid_trainval = fopen('classification/rap2_ide_trainval.txt', 'w+');
fid_test = fopen('classification/rap2_ide_test.txt', 'w+'); % consist labeled and unlabeled images

train_set = {};
val_set = {};
trainval_set = {};
train_image_cnt = 1;
val_image_cnt = 1;
trainval_image_cnt = 1;

for idx_pid = 1:train_ids_cnt
    idx_img = find(person_identity == train_ids(idx_pid));
    idx_val_img = idx_img(randperm(length(idx_img), 1));
    idx_train_img = setdiff(idx_img, idx_val_img);
    person_id = train_ids_map(idx_pid);
    % random the train images 
    for idx = 1:length(idx_train_img)
        tmp = sprintf('%s/%s %d\n', images_root, images_name{idx_train_img(idx)}, person_id);
        train_set{train_image_cnt} = tmp;
        train_image_cnt = train_image_cnt + 1;
        trainval_set{trainval_image_cnt} = tmp;
        trainval_image_cnt = trainval_image_cnt + 1;
    end
    % write the val images
    tmp = sprintf('%s/%s %d\n', images_root, images_name{idx_val_img(1)}, person_id);
    val_set{val_image_cnt} = tmp;
    val_image_cnt = val_image_cnt + 1;
    trainval_set{trainval_image_cnt} = tmp;
    trainval_image_cnt = trainval_image_cnt + 1;
end

train_set = train_set(randperm(length(train_set))); % random
trainval_set = trainval_set(randperm(length(trainval_set))); % random

for i=1:length(train_set)
    fprintf(fid_train, train_set{i});
end

for i=1:length(val_set)
    fprintf(fid_val, val_set{i});
end

for i=1:length(trainval_set)
    fprintf(fid_trainval, trainval_set{i});
end

fclose(fid_train);
fclose(fid_val);
fclose(fid_trainval);

trainval_image_cnt
val_image_cnt
train_image_cnt

% obtain the test images
test_set = {};
test_image_cnt = 1;
for idx_pid = 1:length(test_ids)
    idx_img_test = find(person_identity == test_ids(idx_pid));
    for idx = 1:length(idx_img_test)
        tmp = sprintf('%s/%s %d\n', images_root, images_name{idx_img_test(idx)}, test_ids(idx_pid));
        test_set{test_image_cnt} = tmp;
        test_image_cnt = test_image_cnt + 1;
    end
end
test_image_cnt
% write the -1 identity
idx_img_atest = find(person_identity == -1);
for idx = 1:length(idx_img_atest)
    tmp = sprintf('%s/%s %d\n', images_root, images_name{idx_img_atest(idx)}, -1);
    test_set{test_image_cnt} = tmp;
    test_image_cnt = test_image_cnt + 1;
end
for i=1:length(test_set)
    fprintf(fid_test, test_set{i});
end
fclose(fid_test);
test_image_cnt
