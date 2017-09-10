sub_img=10;
total_Users=5;
TrModel=[];

for Z=1:1:total_Users
    Z
    temp=[];
    for X=1:1:sub_img    
       
        I = imread( strcat('TrainDatabase\S',int2str(Z),'\',int2str(X),'.jpg') );
        
        %I= imresize(I,[64 64]);
        res=mean(I(:));
        temp =[temp res];
       
    end
    tt=mean(temp);
    temp1=temp;
    clear temp
    TrModel = [TrModel tt];

end

 [net]=Neural_Network_Training(temp1');
% save('trmodel.mat','temp')
msgbox('Training Done');

