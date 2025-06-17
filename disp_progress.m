function [] = disp_progress(i, totalsize)

temp_str = strcat("Processing ", num2str(i), "/", num2str(totalsize));
disp(temp_str)

end 