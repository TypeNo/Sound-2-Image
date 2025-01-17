% image color generation generation

A= imread('dummy.jpg');  % load a white image format .jpg
 
st=1;
ed=100;
row=400;
col=400;
subplot(2,2,1);
imshow(A); title('Image 1: All white');

 max = ceil(355.*rand(1,1)); %get max value randomlt between 100 - 255   
 r = ceil(max.*rand(row*col,1));  % max is the max, 1 is min and row*col is the numbers of random   
 R=reshape(r,[row,col]);
 A(:,:,1)=R;
 A(:,:,2)=R/2;
 A(:,:,3)=R/2;
 subplot(2,2,2);
 imshow(A); title('Image 2: channel 1 ');

 max = ceil(355.*rand(1,1)); %get max value randomlt between 100 - 255   
 r = ceil(max.*rand(row*col,1));  % max is the max, 1 is min and row*col is the numbers of random   
 R=reshape(r,[row,col]);
 A(:,:,1)=R/2;
 A(:,:,2)=R;
 A(:,:,3)=R/2;

 subplot(2,2,3);
 imshow(A); title('Image 3: channel 2 ');

 max = ceil(355.*rand(1,1)); %get max value randomlt between 100 - 255   
 r = ceil(max.*rand(row*col,1));  % max is the max, 1 is min and row*col is the numbers of random   
 R=reshape(r,[row,col]);
 A(:,:,1)=R/2;
 A(:,:,2)=R/2;
 A(:,:,3)=R;

 subplot(2,2,4);
 imshow(A);title('Image 4: channel 3 ');
