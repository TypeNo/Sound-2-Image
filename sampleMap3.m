
function [R] = sampleMap3(A,Fs)

RC=floor(sqrt(length(A)));   % get corresponding image size RC*RC
minA=min(min(A));  % find max and min (stereo sound)
maxA=max(max(A));  % to map the value into range 0-255

win = length(A)/16;

%Get the energy of the signal
N = round(length(A)/win); % number of framed
st = 1;
for n= 1:N-1
e = Energy(A(st:win+st),win);
x(n) = e;
st = (st+win);   
end

B=A(1:RC^2);
T = zeros(RC,RC,3); % initialize color images black

% map the value
for i=1:RC^2
 B(i)=floor((A(i)-minA)*(255) / (maxA-minA));  %map the range between 0-255
 
 %detect zero crossing and make the point white
 if (A(i)* -1)> 0
     B(i)= 255;
 end   
 
end


R=reshape(B,[RC,RC]); %reshape the value into RCxRC image



%imshow(R,'DisplayRange',[0 255]); % display the image in grayscale


end



% map the value
for i=1:RC^2
 T(i)= 
