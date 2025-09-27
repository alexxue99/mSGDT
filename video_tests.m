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

% Run mSGDT on X for N = 10^6 iterations and p = 0.3
disp("Running mSGDT on shuttle video for p = 0.3")
[~, ~, v3] = mSGDT_uniform_streaming(X, 10^6, 5000, 0.3);

% Save solution as a video, and store first and last frames
writerObj = VideoWriter('draws/p3.avi');
writerObj.FrameRate = 30; 
open(writerObj);
for k = 1:size(v3, 3)
    frame = uint8(v3(:, :, k)); % Extract grayscale frame
    frameRGB = repmat(frame, [1 1 3]); % Convert to RGB (required by VideoWriter)

    if k == 1
        imwrite(frameRGB, 'draws/p3_first_frame.png');
    elseif k == size(v3, 3)
        imwrite(frameRGB, 'draws/p3_last_frame.png');
    end

    writeVideo(writerObj, frameRGB);   % Write frame
end
close(writerObj)


% Run mSGDT on X for N = 10^6 iterations and p = 0.7
disp("Running mSGDT on shuttle video for p = 0.7")
[~, ~, v7] = mSGDT_uniform_streaming(X, 10^6, 5000, 0.7);

% Save solution as a video, and store first and last frames
writerObj = VideoWriter('draws/p7.avi');
writerObj.FrameRate = 30; 
open(writerObj);
for k = 1:size(v7, 3)
    frame = uint8(v7(:, :, k));  % Extract grayscale frame
    frameRGB = repmat(frame, [1 1 3]); % Convert to RGB (required by VideoWriter)

    if k == 1
        imwrite(frameRGB, 'draws/p7_first_frame.png');
    elseif k == size(v7, 3)
        imwrite(frameRGB, 'draws/p7_last_frame.png');
    end

    writeVideo(writerObj, frameRGB);   % Write frame
end
close(writerObj)

