classdef ImageProcessingTest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        LoadImageButton        matlab.ui.control.Button
        Slider                 matlab.ui.control.Slider
        SliderLabel            matlab.ui.control.Label
        FrequencyDomainLabel   matlab.ui.control.Label
        EdgeDetectionLabel     matlab.ui.control.Label
        ThresholdedImageLabel  matlab.ui.control.Label
        HistogramLabel         matlab.ui.control.Label
        OriginalImageLabel     matlab.ui.control.Label
        UIAxes5                matlab.ui.control.UIAxes
        UIAxes4                matlab.ui.control.UIAxes
        UIAxes3                matlab.ui.control.UIAxes
        UIAxes2                matlab.ui.control.UIAxes
        UIAxes                 matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
       ImageArray 
       grayImg 
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            [file, path] = uigetfile('*.png'); 
            if isequal(file, 0)
                disp('No file selected');
            else
                img = imread(fullfile(path, file)); 
                app.ImageArray = img; 
                imshow(img, 'Parent', app.UIAxes); 
                % Gri tonlama işlemi
                if size(app.ImageArray, 3) == 3 
                    app.grayImg = rgb2gray(app.ImageArray); 
                else
                    app.grayImg = app.ImageArray; 
                end

                % Histogram
                if size(app.ImageArray, 3) == 1 
                    histogram(app.UIAxes2, img(:), 'BinLimits', [0, 255], 'BinWidth', 1);
                    title(app.UIAxes2, 'Gray Level Histogram');
                else 
                    histogram(app.UIAxes2, img(:,:,1), 'FaceColor', 'r'); 
                    hold(app.UIAxes2, 'on');
                    histogram(app.UIAxes2, img(:,:,2), 'FaceColor', 'g');
                    histogram(app.UIAxes2, img(:,:,3), 'FaceColor', 'b'); 
                    hold(app.UIAxes2, 'off');
                    title(app.UIAxes2, 'RGB Histogram');
                end

                
                edges = edge(app.grayImg, 'Canny'); 
                imshow(edges, 'Parent', app.UIAxes4); 
                freqDomain = fftshift(log(1 + abs(fft2(app.grayImg)))); 
                imshow(freqDomain, [], 'Parent', app.UIAxes5); 
            end
        end

        % Value changed function: Slider
        function SliderValueChanged(app, event)
           value = app.Slider.Value;
            thresholdValue = app.Slider.Value; 
            thresholdedImg = app.grayImg > thresholdValue; 
            thresholdedImg = uint8(thresholdedImg) * 255; 
            imshow(thresholdedImg, 'Parent', app.UIAxes3); 
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 893 693];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'UIAxes')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontWeight = 'bold';
            app.UIAxes.Position = [498 468 326 206];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'UIAxes2')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.FontWeight = 'bold';
            app.UIAxes2.Position = [58 473 320 196];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'UIAxes3')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.FontWeight = 'bold';
            app.UIAxes3.Position = [499 237 326 194];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 'UIAxes4')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.Position = [63 16 326 187];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.UIFigure);
            title(app.UIAxes5, 'UIAxes5')
            xlabel(app.UIAxes5, 'X')
            ylabel(app.UIAxes5, 'Y')
            zlabel(app.UIAxes5, 'Z')
            app.UIAxes5.FontWeight = 'bold';
            app.UIAxes5.Position = [59 241 320 190];

            % Create OriginalImageLabel
            app.OriginalImageLabel = uilabel(app.UIFigure);
            app.OriginalImageLabel.FontWeight = 'bold';
            app.OriginalImageLabel.Position = [640 452 87 22];
            app.OriginalImageLabel.Text = 'Original Image';

            % Create HistogramLabel
            app.HistogramLabel = uilabel(app.UIFigure);
            app.HistogramLabel.FontWeight = 'bold';
            app.HistogramLabel.Position = [199 457 64 22];
            app.HistogramLabel.Text = 'Histogram';

            % Create ThresholdedImageLabel
            app.ThresholdedImageLabel = uilabel(app.UIFigure);
            app.ThresholdedImageLabel.FontWeight = 'bold';
            app.ThresholdedImageLabel.Position = [626 217 114 22];
            app.ThresholdedImageLabel.Text = 'Thresholded Image';

            % Create EdgeDetectionLabel
            app.EdgeDetectionLabel = uilabel(app.UIFigure);
            app.EdgeDetectionLabel.FontWeight = 'bold';
            app.EdgeDetectionLabel.Position = [195 1 90 22];
            app.EdgeDetectionLabel.Text = 'Edge Detection';

            % Create FrequencyDomainLabel
            app.FrequencyDomainLabel = uilabel(app.UIFigure);
            app.FrequencyDomainLabel.FontWeight = 'bold';
            app.FrequencyDomainLabel.Position = [174 227 110 22];
            app.FrequencyDomainLabel.Text = 'Frequency Domain';

            % Create SliderLabel
            app.SliderLabel = uilabel(app.UIFigure);
            app.SliderLabel.HorizontalAlignment = 'right';
            app.SliderLabel.Position = [534 170 37 22];
            app.SliderLabel.Text = 'Slider';

            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.Limits = [0 255];
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.Position = [592 179 231 3];
            app.Slider.Value = 128;

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.BackgroundColor = [0.8 0.8 0.8];
            app.LoadImageButton.FontSize = 14;
            app.LoadImageButton.FontWeight = 'bold';
            app.LoadImageButton.FontColor = [0.149 0.149 0.149];
            app.LoadImageButton.Position = [712 34 112 28];
            app.LoadImageButton.Text = 'Load Image';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageProcessingTest

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
