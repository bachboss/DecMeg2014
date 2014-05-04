file_start = 2;
no_files = 6;
no_channels = 306;
no_times = 375;

% channel = 2;
% 
x = [];
for test_file = file_start:no_files
    fi = strcat('train_subject0', num2str(test_file),'.mat');
    fprintf('Loading file: %s\n', fi);
    load(fi);
    X = double(X);
    y = double(y);
    no_trials = size(X, 1);
    for trials = 1 : no_trials
%         start = tic();
        start = cputime;
        for channel = 1: no_channels
            X(trials, channel, :) = normalizeSignal(X(trials, channel, :));
            
            if (isnan(mean(X(trials, channel, :))))
                fprintf('Error here !\n');
            end
        end
%         endTime = toc(start);
        endTime = cputime - start;
        if (mod(trials, 10) == 0)
            fprintf('\t%d / %d\t %.2f\t%.2f\n', trials, no_trials, (trials / no_trials), endTime);
        end
    end
    save(strcat('pre_',fi), 'X', 'y');
end