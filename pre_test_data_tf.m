
function [data_H, num_row, num_col, num_total] = pre_test_data_tf(C)
HHHH = squeeze(C(1,1,:,:));

k = 0;
for i = 1:300:(size(C,3)-400)
    for j = 1:300:(size(C,4)-400)
        k = k+1;
        data_H(k,:,:) = HHHH(i:i+399,j:j+399);
    end
end
disp(['Number of pixels (row): ', num2str(i+399)])      % The right part of the image is discarded.
disp(['Number of pixels (width): ', num2str(j+399)])   % The bottom part of the image is discarded.
disp(['Number of samples: ', num2str(k)])
num_total = k;
num_row = size(1:300:(size(C,3)-400), 2);
num_col = size(1:300:(size(C,4)-400), 2);
