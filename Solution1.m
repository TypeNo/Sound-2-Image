
function [Res] = sampleMap2b(A, fs)

RC=floor(sqrt(length(A)));   % get corresponding image size RC*RC
minA=min(min(A));  % find max and min (stereo sound)
maxA=max(max(A));  % to map the value into range 0-255

B1=A(1:RC^2);  % 1 D

B = floor((0)+ ((B1-min(B1))*255)/(max(B1)-min(B1)));  %[0 255]
    
win = length(A)/16;   % find 16 portion energy
%Get the energy of the signal
N = round(length(A)/win); % number of framed
st = 1;
for n= 1:N-1
e = Energy(A(st:win+st),win);
x(n) = e;
st = (st+win);   
end

med = mean(x)


R=reshape(B,[RC,RC]); %reshape the value into RCxRC image
R3 = R(:,:,[1 1 1]); 

%based on the energy decide color
st=1;
j = 1;
win = floor(RC/15);
while j < 15 && ((st+win) < RC)
 %check energy
 if (x(j) < med)
    v = (0.5-0).*rand(3,1) 
      R3(j:st+win,j:st+win,1 ) = v(1);
      R3(j:st+win,j:st+win,2 ) = v(2);
       R3( 5:150,5:150,3 ) = v(3);
      
    clear v;
 elseif (x(j)>med)
    v1 = 0.5 + (1-0.5).*rand(3,1)
      R3(j:st+win,j:st+win,1 ) = v1(1);
      R3(j:st+win,j:st+win,2 ) = v1(2);
      R3( 100:150,5:150,3 ) = v1(3);

     clear v1;
 end     
   

st = (st+win)   
j
end


figure(1);
imshow(R,'DisplayRange',[0 255]); 
figure(2);
imshow(R3);

% figure(4);
% plot(R);

end



 
