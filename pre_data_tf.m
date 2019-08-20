
function [data,data_H,const_array, num_row, num_col, num_total] = pre_data_tf(C)
HHHH = squeeze(C(1,1,:,:));
span = HHHH + squeeze(C(2,2,:,:)) + squeeze(C(3,3,:,:));
delta1 = HHHH./span;
delta2 = squeeze(C(2,2,:,:))./span;
delta3 = squeeze(C(3,3,:,:))./span;

rho12 = squeeze(C(1,2,:,:))./sqrt(HHHH.*squeeze(C(2,2,:,:))+1e-10);
rho13 = squeeze(C(1,3,:,:))./sqrt(HHHH.*squeeze(C(3,3,:,:))+1e-10);
rho23 = squeeze(C(2,3,:,:))./sqrt(squeeze(C(2,2,:,:).*C(3,3,:,:))+1e-10);

const_array = zeros(9,32);
[~,T] = histeq(delta1,32); const_array(1,:) = unique(T);
[~,T] = histeq(delta2,39); const_array(2,:) = unique(T);
[~,T] = histeq(delta3,32); const_array(3,:) = unique(T);
[~,T] = histeq((real(rho12)+1.0)./2,32); const_array(4,:) = unique(T)*2-1;
[~,T] = histeq((imag(rho12)+1.0)./2,32); const_array(5,:) = unique(T)*2-1;
[~,T] = histeq((real(rho13)+1.0)./2,32); const_array(6,:) = unique(T)*2-1;
[~,T] = histeq((imag(rho13)+1.0)./2,32); const_array(7,:) = unique(T)*2-1;
[~,T] = histeq((real(rho23)+1.0)./2,32); const_array(8,:) = unique(T)*2-1;
[~,T] = histeq((imag(rho23)+1.0)./2,32); const_array(9,:) = unique(T)*2-1;

k = 0;
for i = 1:300:(size(delta1,1)-400)
    for j = 1:300:(size(delta1,2)-400)
        k = k+1;
        data(k,:,:,1) = delta1(i:i+399,j:j+399);
        data(k,:,:,2) = delta2(i:i+399,j:j+399);
        data(k,:,:,3) = delta3(i:i+399,j:j+399);
        data(k,:,:,4) = real(rho12(i:i+399,j:j+399));
        data(k,:,:,5) = imag(rho12(i:i+399,j:j+399));
        data(k,:,:,6) = real(rho13(i:i+399,j:j+399));
        data(k,:,:,7) = imag(rho13(i:i+399,j:j+399));
        data(k,:,:,8) = real(rho23(i:i+399,j:j+399));
        data(k,:,:,9) = imag(rho23(i:i+399,j:j+399));
        data_H(k,:,:) = HHHH(i:i+399,j:j+399);
    end
end
disp(['Number of pixels (row): ', num2str(i+399)])      % The right part of the image is discarded.
disp(['Number of pixels (width): ', num2str(j+399)])   % The bottom part of the image is discarded.
disp(['Number of samples: ', num2str(k)])
num_total = k;
num_row = size(1:300:(size(delta1,1)-400), 2);
num_col = size(1:300:(size(delta1,2)-400), 2);
