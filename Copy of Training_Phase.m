total_sub =38;
sub_img =10;%20;
train_img = 190; %60;
max_hist_level = 256;
bin_num = 9;
form_bin_num = 29;
train_processed_bin(form_bin_num,train_img) = 0;
K = 1;
train_hist_img = zeros(max_hist_level, train_img);

for Z=1:1:total_sub
    Z
    for X=1:2:sub_img    %%%train on odd number of images of each subject
        if Z >=3
            I = imread( strcat('TrainDatabase\S',int2str(Z),'\',int2str(X),'.bmp') );
        else
            I = imread( strcat('TrainDatabase\S',int2str(Z),'\',int2str(X),'.jpg') );
        end
       %figure(11),imshow(uint8(I)), title('Face Found')
        I= imresize(I,[128 128]);
        
        [rows,cols] = size(I);
        
        for i=1:1:rows
            for j=1:1:cols
                if( I(i,j) == 0 )
                    train_hist_img(max_hist_level, K) =  train_hist_img(max_hist_level, K) + 1;
                else
                    train_hist_img(I(i,j), K) = train_hist_img(I(i,j), K) + 1;
                end
            end
        end
        K = K + 1;
        pause(0.1)
    end
    
end

[r c] = size(train_hist_img);
sum = 0;
for i=1:1:c
    K = 1;
    for j=1:1:r
        if( (mod(j,bin_num)) == 0 )
            sum = sum + train_hist_img(j,i);
            train_processed_bin(K,i) = sum/bin_num;
            K = K + 1;
            sum = 0;
        else
            sum = sum + train_hist_img(j,i);
        end
    end
    train_processed_bin(K,i) = sum/bin_num;
end
[net]=Neural_Network_Training(train_processed_bin(1,:,:)');
msgbox('Training Done');
save 'train'  train_processed_bin;