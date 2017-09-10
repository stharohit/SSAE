
load net;
load trmodel;
[ACC] = Neural_Network_Testing (temp, net,temp, temp);
for i = 1:length(TrModel)
    res(i)=abs(testface-TrModel(i));
end
[val,ind]=min(res);
I = imread(strcat('TestDatabase\S',num2str(ind),'\1.jpg'));
if ind<=length(TrModel)
    Passcnt = Passcnt+1;
    axes(handles.axes2),  imshow(I);
    display ( ' Face Found ');
else
    msgbox ( 'Face Not Found - Invalid');
    return;
end