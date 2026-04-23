vid = VideoReader('shuttle.avi');
frameHeight = vid.Height;
frameWidth = vid.Width;
numFrames = floor(vid.Duration * vid.FrameRate);

% Preallocate tensor (grayscale frames)
videoTensor = zeros(frameHeight, frameWidth, numFrames, 'uint8');
% Read each frame and store it as a frontal slice
frameIdx = 1;
while hasFrame(vid)
rgbFrame = readFrame(vid);          % Read frame (RGB)
grayFrame = rgb2gray(rgbFrame);     % Convert to grayscale
videoTensor(:, :, frameIdx) = grayFrame;

if frameIdx == 1
    imwrite(grayFrame, 'draws/first_frame.png')
end
frameIdx = frameIdx + 1;
end
imwrite(grayFrame, 'draws/last_frame.png')
X = double(videoTensor);

METHOD = "frontal";
p = 0.7;
N = 10^5; 
swapAt = 5000; 

str = METHOD + "_p" + sprintf("%d", 10*p);

% Run mSGDT on X for specified N and p = 0.3
disp("Running mSGDT on shuttle video for p = " + p + " with method " + METHOD);

if strcmpi(METHOD, "uniform")
    [~, ~, v3] = mSGDT_uniform_streaming(X, N, swapAt, p);
elseif strcmpi(METHOD, "column")
    [~, ~, v3] = mSGDT_column_streaming(X, N, swapAt, p, 8);
elseif strcmpi(METHOD, "frontal")
    [~, ~, v3] = mSGDT_frontal_streaming(X, N, swapAt, p);
end

% Save solution as a video, and store first and last frames
writerObj = VideoWriter('draws/' + str + '.avi');
writerObj.FrameRate = 30; 
open(writerObj);
for k = 1:size(v3, 3)
    frame = uint8(v3(:, :, k)); % Extract grayscale frame
    frameRGB = repmat(frame, [1 1 3]); % Convert to RGB (required by VideoWriter)

    if k == 1
        imwrite(frameRGB, 'draws/' + str + '_first_frame.png');
    elseif k == size(v3, 3)
        imwrite(frameRGB, 'draws/' + str + '_last_frame.png');
    end

    writeVideo(writerObj, frameRGB);   % Write frame
end
close(writerObj)

