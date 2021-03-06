%%
close all;
tic;
numberOfElectrodes = 16;
samplingRate = 399;
timeWindow = 5*60*samplingRate;  %5 minutes* 60 seconds * sampling rate 
numberOfWindows = 14;  %number of 5 minute intervals present in the data
numberOfTestWindows = 780;

[dogDataSet,testData] = getdogData('I004_A0001_D001','IITResearch','IIT_ieeglogin.bin',floor(timeWindow)+1,numberOfElectrodes,numberOfWindows,samplingRate,numberOfTestWindows);
fprintf("%s\n",'dog data done');
toc;
%%
WD_left=zeros(1,12);
WD_right=zeros(1,12);
      
triodes = [[1,2,5,9,10,13];[1,2,6,9,10,14];[5,6,1,13,14,9];[5,6,2,13,14,10];[2,3,6,10,11,14];[2,3,7,10,11,15];[2,6,7,10,14,15];[3,6,7,11,14,15];[3,4,7,11,12,15];[3,4,8,11,12,16];[3,7,8,11,15,16];[4,7,8,12,15,16]];

for i = 1:12
    [WD_left(i),WD_right(i)] = CalculateWardDistance(triodes(i,:),dogDataSet,numberOfWindows,samplingRate);
    fprintf("%d\n",i);
end

BestTriode_left = triodes(find(WD_left == max(WD_left)),1:3); 
BestTriode_right = triodes(find(WD_right == max(WD_right)),4:6);

if max(WD_left) > max(WD_right)
    x = BestTriode_left(1);
    y = BestTriode_left(2);
    z = BestTriode_left(3);
else
    x = BestTriode_right(1);
    y = BestTriode_right(2);
    z = BestTriode_right(3);
end

figure(40)
plot(WD_left,'-o')
hold on
plot(WD_right,'-x')

%%
tic;
[ictal_Ref,interictal_Ref] = GenerateReference(dogDataSet,numberOfWindows,BestTriode_left,BestTriode_right,samplingRate);
fprintf("%s\n",'ref done');
toc;
%%
tic;
x = 3;
y = 4;
z = 8;
[ictal_match,interictal_match] = FullCharacterisation(testData,numberOfTestWindows,samplingRate,ictal_Ref,interictal_Ref,x,y,z);
toc;
figure(7)
plot(interictal_match,'-o')
hold on
plot(ictal_match,'-x')
