function [stats,prop] = responsiveNeuronTest_hao(dataToplot, bsl, win, type)
% bsl = [1 50]
% win = [51 70]
% type = "ranksum" or "zscore"

pcutoff = 0.05;
zcutoff = 1.98;
win1 = win(1);
win2 = win(2);

if ~isempty(dataToplot)
    for j = 1:size(dataToplot,3)
        temp = dataToplot(:,:,j);
        for k = 1:size(temp,1)
            temp2 = temp(k,:);
            temp3 = HaozScore(temp2,[bsl(1) bsl(2)]);

            p = ranksum(temp2(bsl(1):bsl(2)),temp2(win1:win2));
            z_average = nanmean(temp3(win1:win2),2);

            if type == "ranksum"
                if p <= pcutoff && z_average > 0
                    stats(k,j) = 1;
                elseif p <= pcutoff && z_average < 0
                    stats(k,j) = -1;
                else
                    stats(k,j) = 0;
                end

            elseif type == "zscore"
                if z_average >= zcutoff
                    stats(k,j) = 1;
                elseif z_average <= zcutoff*-1
                    stats(k,j) = -1;
                else
                    stats(k,j) = 0;
                end
            end

        end
    end


    % prop

    temp = stats;
    for j = 1:size(temp,2)
        temp2 = temp(:,j);
        prop(1,j) = sum(temp2==1)/size(temp2,1);
        prop(2,j) = sum(temp2==-1)/size(temp2,1);
        prop(3,j) = sum(temp2==0)/size(temp2,1);
    end
else
    stats = [];
    prop = [];
end
end
