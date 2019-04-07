function PSNR_out = PSNR(f, g)
    % f - Normal/original image 
    % g - Test image (that's been modified somehow) 

    % MSE = Mean Squared Error
        % Cumulative squared error b/w compressed & original image 
    % PSNR = Peak Signal to Noise Ratio 
        % Measure of peak error (Lower the MSE, lower the Peak Error) 
        
    % Get size of test input image (g) -> M and N are # rows/columns 
    M = size(g, 1); % rows 
    N = size(g, 2); % columns
    
    % Since have to square difference, must make it into a double instead of int (need double precision instead) 
    % https://www.mathworks.com/matlabcentral/answers/164869-error-using-mtimes-is-not-fully-supported-for-integer-classes-at-least-one-input-must-be-scalar    
    % Changing double of f and g because image read as an integer 
    squared_difference = (double(f)-double(g)).^2;
    MSE = sum(squared_difference(:))/(M*N); % Sum both rows and columns 

    R = 255; % Using 8-bit unsigned integer data type so max is 255
    PSNR_out = 10*log10(R^2/MSE); % Calculate PSNR 
end