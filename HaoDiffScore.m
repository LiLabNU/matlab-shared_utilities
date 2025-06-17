 function [DiffScore] = HaoDiffScore(Input,BaselineWindow)
             for r = 1:size(Input,1)
                Baseline = Input(r,BaselineWindow(1):BaselineWindow(2));
                mean_base = mean(Baseline);
                
            for t = 1:size(Input,2)
                DiffScore(r,t) = (Input(r,t) - mean_base);
            end
            end
                
        end