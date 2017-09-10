total_sub =38;
sub_img =10;
train_img = 190;
max_hist_level = 256;
bin_num = 9;
form_bin_num = 29;
train_processed_bin(form_bin_num,train_img) = 0;
K = 1;
train_hist_img = zeros(max_hist_level, train_img);

pathname ='TrainDatabase\S';
load 'train'
test_hist_img(max_hist_level) = 0;
test_processed_bin(form_bin_num) = 0;
I = I(:,:,1);
I = imresize(I,[128 128]);
[rows cols] = size(I);

for i=1:1:rows
    for j=1:1:cols
        if( I(i,j) == 0 )
            test_hist_img(max_hist_level) =  test_hist_img(max_hist_level) + 1;
        else
            test_hist_img(I(i,j)) = test_hist_img(I(i,j)) + 1;
        end
    end
end

[r c] = size(test_hist_img);
sum = 0;

K = 1;
for j=1:1:c
    if( (mod(j,bin_num)) == 0 )
        sum = sum + test_hist_img(j);
        test_processed_bin(K) = sum/bin_num;
        K = K + 1;
        sum = 0;
    else
        sum = sum + test_hist_img(j);
    end
end

test_processed_bin(K) = sum/bin_num;

sum = 0;
K = 1;

for y=1:1:train_img
    for z=1:1:form_bin_num
        sum = sum + abs( test_processed_bin(z) - train_processed_bin(z,y) );
    end
    img_bin_hist_sum(K,1) = sum;
    sum = 0;
    K = K + 1;
end
load net;
[ACC] = Neural_Network_Testing (train_processed_bin, net,test_processed_bin', train_processed_bin);
[temp M] = min(img_bin_hist_sum);
M
if M>60

else
    M = ceil(M/10);
end
if ( M<=38)
                        
    Passcnt = Passcnt+1;
    %I = imread(strcat('TrainDatabase\S',num2str(M),'\5.jpg')); 
    Z=M;
    X=5;
    if Z >=3
            I = imread( strcat('TrainDatabase\S',int2str(Z),'\',int2str(X),'.bmp') );
        else
            I = imread( strcat('TrainDatabase\S',int2str(Z),'\',int2str(X),'.jpg') );
    end    
    k=M;
    if k == 1
          axes(handles.axes2),  imshow(I);   

    else

          axes(handles.axes3),  imshow(I);   
    end
  
    display ( ' Face Found ');

else
    %   display ([ 'Error==>  Testing Image of Subject >>' num2str(subjectindex) '  matches with the image of subject >> '  num2str(M)])

    msgbox ( 'Face Not Found - Invalid');
    return;
end

%display('Testing Done')
