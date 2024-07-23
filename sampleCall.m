
%sample call


[A fs] = audioread('0228.wav'); % get the sound 1
R1 = sampleMap1(A);  
R2 = sampleMap2b7(A,256);

figure(1);
subplot(131);plot(A);
% display the image in grayscale;
subplot(132);imshow(R1,'DisplayRange',[0 255]);  title('Map1');
subplot(133);imshow(R2,'DisplayRange',[0 255]);  title('Map2');


 [A fs] = audioread('Ding.wav'); % get the sound 1
 R1 = sampleMap1(A);  
 R2 = sampleMap2b7(A,256);  
 figure(2);
 subplot(131);plot(A);
% % display the image in grayscale;
 subplot(132);imshow(R1,'DisplayRange',[0 255]);  title('Map1');
 subplot(133);imshow(R2,'DisplayRange',[0 255]);  title('Map2');
 
 [A fs] = audioread('5286.wav'); % get the sound 1
 R1 = sampleMap1(A);  
 R2 = sampleMap2b7(A,256); 
 figure(3);
 subplot(131);plot(A);
% % display the image in grayscale;
 subplot(132);imshow(R1,'DisplayRange',[0 255]);  title('Map1');
 subplot(133);imshow(R2,'DisplayRange',[0 255]);  title('Map2');
