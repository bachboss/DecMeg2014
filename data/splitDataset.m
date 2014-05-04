file_start = 2;
file_end = 6;
for file_num = file_start:file_end
    data = [];
    fi = strcat('pre_train_subject0', num2str(file_num), '.mat');
    fprintf('Loading: %s\n', fi);
    load(fi);
    
    fo = strcat('data.',num2str(file_num),'.mat');

    test_size = 100;
    cv_size = 100;
    train_size = size(X, 1) - test_size - cv_size;

    X = double(X);
    % X_fft = zeros(size(X, 2) * floor(size(X, 3) / 2), size(X, 1));
    X_fft = zeros(size(X, 2) * floor(size(X, 3)), size(X, 1));
    y = double(y);

    lab = zeros(2, size(X, 1));
    for trial=1:size(X, 2)
        if y(trial) > 0.5
            lab(2, trial) = 1;
        else
            lab(1, trial) = 1;
        end 
    end


    for trial=1:size(X, 1)
        a = zeros(1, size(X, 2) * floor(size(X, 3)));
        start = cputime;
        t = 1;
        for channel=1:size(X, 2)
            data = X(trial, channel, :);
            data = data(:);
    %         data = fft(data);
    %         data = data(1: floor(length(data) / 2));
            a(t:t+length(data)-1) = data';
            t = t + length(data);
        end    
        X_fft(:, trial) = a;
    %     X_fft(:, trial) = abs(a); 
    %     if (isnan(mean(X_fft(:, trial))))
    %         fprintf('Error Here !')
    %     end


        endTime = cputime - start;
        if (mod(trial, 10) == 0)
            fprintf('\t%d / %d = %.2f\t%.2f (s)\n', trial, size(X, 1), (trial / size(X, 1)), endTime);
        end
    end

    % for i=1:size(X_fft, 2)
    %     X_fft(:, i) = log(X_fft(:, i));
    %     X_fft(:, i) = (X_fft(:, i) - mean(X_fft(:, i))) / std(X_fft(:, i));
    % end

    data = {};

    data.test = {};
    data.test.inputs = X_fft(   :, 1:test_size);
    data.test.targets = lab(    :, 1:test_size);

    data.validation = {};
    data.validation.inputs =  X_fft(:, test_size+1 : test_size + cv_size);
    data.validation.targets = lab(  :, test_size+1 : test_size + cv_size);

    data.training = {};
    data.training.inputs =  X_fft(  :, test_size + cv_size + 1:end);
    data.training.targets = lab(    :, test_size + cv_size + 1:end);

    fprintf('Saving: %s\n', fo);
    save (fo, 'data');
end
