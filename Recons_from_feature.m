%=======================================================
%Recons_from_feature.m
%Reconstruct C matrix from predicted_features
%by Qian Song on Jan. 14th 2019
%=======================================================

function IM_test = Recons_from_feature(filename, filename_input)

load(filename_input);
clear data
Re_data = h5read(filename, '/Re_data');
Re_data = permute(Re_data, [4,3,2,1]);
% size(Re_data)

im_size = 300;
IM_test = zeros(3,3,num_row*300+100, num_col*300+100);

% temp_sum = sum(Re_data(:,:,:,1:3),4);
% for i = 1:3
%     Re_data(:,:,:,i) = Re_data(:,:,:,i)./temp_sum;
% end
% clear temp_sum

%%
k = 0;
for i = 1:num_row
    for j = 1:num_col
        k = k + 1;
        SPAN_ = data_H(k,:,:)./Re_data(k,:,:,1);
        SPAN_(SPAN_<0) = 0;
        if (i==1 &&j==1)
            IM_test(1,1,1:350,1:350) = data_H(k,1:350,1:350);
            temp2 = SPAN_(1,1:350,1:350).*Re_data(k,1:350,1:350,2);
            IM_test(2,2,1:350,1:350) = temp2;
            temp3 = SPAN_(1,1:350,1:350).*Re_data(k,1:350,1:350,3);
            IM_test(3,3,1:350,1:350) = temp3;
            IM_test(1,2,1:350,1:350) = sqrt(temp2.*data_H(k,1:350,1:350)).*Re_data(k,1:350,1:350,4)+1i*sqrt(temp2.*data_H(k,1:350,1:350)).*Re_data(k,1:350,1:350,5);
            IM_test(1,3,1:350,1:350) = sqrt(temp3.*data_H(k,1:350,1:350)).*Re_data(k,1:350,1:350,6)+1i*sqrt(temp3.*data_H(k,1:350,1:350)).*Re_data(k,1:350,1:350,7);
            IM_test(2,3,1:350,1:350) = sqrt(temp2.*temp3).*Re_data(k,1:350,1:350,8)+1i*sqrt(temp2.*temp3).*Re_data(k,1:350,1:350,9);
            
            elseif (i==num_row &&j==num_col)
            IM_test(1,1,(i-1)*im_size+51:i*im_size+100,(j-1)*im_size+51:j*im_size+100) = data_H(k,51:400,51:400);
            temp2 = SPAN_(1,51:400,51:400).*Re_data(k,51:400,51:400,2);
            IM_test(2,2,(i-1)*im_size+51:i*im_size+100,(j-1)*im_size+51:j*im_size+100) = temp2;
            temp3 = SPAN_(1,51:400,51:400).*Re_data(k,51:400,51:400,3);            
            IM_test(3,3,(i-1)*im_size+51:i*im_size+100,(j-1)*im_size+51:j*im_size+100) = temp3;
            
            elseif (i==1 &&j==num_col)
            IM_test(1,1,1:350,(j-1)*im_size+51:j*im_size+100) = data_H(k,1:350,51:400);
            temp2 = SPAN_(1,1:350,51:400).*Re_data(k,1:350,51:400,2);
            IM_test(2,2,1:350,(j-1)*im_size+51:j*im_size+100) = temp2;
            temp3 = SPAN_(1,1:350,51:400).*Re_data(k,1:350,51:400,3);            
            IM_test(3,3,1:350,(j-1)*im_size+51:j*im_size+100) = temp3;
            
            elseif (i==num_row &&j==1)
            IM_test(1,1,(i-1)*im_size+51:i*im_size+100,1:350) = data_H(k,51:400,1:350);
            temp2 = SPAN_(1,51:400,1:350).*Re_data(k,51:400,1:350,2);
            IM_test(2,2,(i-1)*im_size+51:i*im_size+100,1:350) = temp2;
            temp3 = SPAN_(1,51:400,1:350).*Re_data(k,51:400,1:350,3);            
            IM_test(3,3,(i-1)*im_size+51:i*im_size+100,1:350) = temp3;
            
        elseif(i==1 && j~=num_col)
            IM_test(1,1,1:350,(j-1)*im_size+51:j*im_size+50) = data_H(k,1:350,51:350);
            temp2 = SPAN_(1,1:350,51:350).*Re_data(k,1:350,51:350,2);
            IM_test(2,2,1:350,(j-1)*im_size+51:j*im_size+50) = temp2;
            temp3 = SPAN_(1,1:350,51:350).*Re_data(k,1:350,51:350,3);
            IM_test(3,3,1:350,(j-1)*im_size+51:j*im_size+50) = temp3;
            IM_test(1,2,1:350,(j-1)*im_size+51:j*im_size+50) = sqrt(temp2.*data_H(k,1:350,51:350)).*Re_data(k,1:350,51:350,4)+1i*sqrt(temp2.*data_H(k,1:350,51:350)).*Re_data(k,1:350,51:350,5);
            IM_test(1,3,1:350,(j-1)*im_size+51:j*im_size+50) = sqrt(temp3.*data_H(k,1:350,51:350)).*Re_data(k,1:350,51:350,6)+1i*sqrt(temp3.*data_H(k,1:350,51:350)).*Re_data(k,1:350,51:350,7);
            IM_test(2,3,1:350,(j-1)*im_size+51:j*im_size+50) = sqrt(temp2.*temp3).*Re_data(k,1:350,51:350,8)+1i*sqrt(temp2.*temp3).*Re_data(k,1:350,51:350,9);
            

        elseif (j==1 && i~=num_row)
            IM_test(1,1,(i-1)*im_size+51:i*im_size+50,1:350) = data_H(k,51:350,1:350);
            temp2 = SPAN_(1,51:350,1:350).*Re_data(k,51:350,1:350,2);
            IM_test(2,2,(i-1)*im_size+51:i*im_size+50,1:350) = temp2;
            temp3 = SPAN_(1,51:350,1:350).*Re_data(k,51:350,1:350,3);
            IM_test(3,3,(i-1)*im_size+51:i*im_size+50,1:350) = temp3;
            IM_test(1,2,(i-1)*im_size+51:i*im_size+50,1:350) = sqrt(temp2.*data_H(k,51:350,1:350)).*Re_data(k,51:350,1:350,4)+1i*sqrt(temp2.*data_H(k,51:350,1:350)).*Re_data(k,51:350,1:350,5);
            IM_test(1,3,(i-1)*im_size+51:i*im_size+50,1:350) = sqrt(temp3.*data_H(k,51:350,1:350)).*Re_data(k,51:350,1:350,6)+1i*sqrt(temp3.*data_H(k,51:350,1:350)).*Re_data(k,51:350,1:350,7);
            IM_test(2,3,(i-1)*im_size+51:i*im_size+50,1:350) = sqrt(temp2.*temp3).*Re_data(k,51:350,1:350,8)+1i*sqrt(temp2.*temp3).*Re_data(k,51:350,1:350,9);
            
                
            elseif i==num_row
            IM_test(1,1,(i-1)*im_size+51:i*im_size+100,(j-1)*im_size+51:j*im_size+50) = data_H(k,51:400,51:350);
            temp2 = SPAN_(1,51:400,51:350).*Re_data(k,51:400,51:350,2);
            IM_test(2,2,(i-1)*im_size+51:i*im_size+100,(j-1)*im_size+51:j*im_size+50) = temp2;
            temp3 = SPAN_(1,51:400,51:350).*Re_data(k,51:400,51:350,3);            
            IM_test(3,3,(i-1)*im_size+51:i*im_size+100,(j-1)*im_size+51:j*im_size+50) = temp3;
            
            elseif j==num_col
            IM_test(1,1,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+100) = data_H(k,51:350,51:400);
            temp2 = SPAN_(1,51:350,51:400).*Re_data(k,51:350,51:400,2);
            IM_test(2,2,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+100) = temp2;
            temp3 = SPAN_(1,51:350,51:400).*Re_data(k,51:350,51:400,3);
            IM_test(3,3,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+100) = temp3;

        else
            IM_test(1,1,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+50) = data_H(k,51:350,51:350);
            temp2 = SPAN_(1,51:350,51:350).*Re_data(k,51:350,51:350,2);
            IM_test(2,2,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+50) = temp2;
            temp3 = SPAN_(1,51:350,51:350).*Re_data(k,51:350,51:350,3);
            IM_test(3,3,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+50) = temp3;
            IM_test(1,2,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+50) = sqrt(temp2.*data_H(k,51:350,51:350)).*Re_data(k,51:350,51:350,4)+1i*sqrt(temp2.*data_H(k,51:350,51:350)).*Re_data(k,51:350,51:350,5);
            IM_test(1,3,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+50) = sqrt(temp3.*data_H(k,51:350,51:350)).*Re_data(k,51:350,51:350,6)+1i*sqrt(temp3.*data_H(k,51:350,51:350)).*Re_data(k,51:350,51:350,7);
            IM_test(2,3,(i-1)*im_size+51:i*im_size+50,(j-1)*im_size+51:j*im_size+50) = sqrt(temp2.*temp3).*Re_data(k,51:350,51:350,8)+1i*sqrt(temp2.*temp3).*Re_data(k,51:350,51:350,9);
            
        end
    end
end
if k~=num_total
    error('Mismatching training and test data.')
end


