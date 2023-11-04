classdef ADRESS_RIXS_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        RIXSplotUIFigure          matlab.ui.Figure
        OpenButton                matlab.ui.control.Button
        PATHEditFieldLabel        matlab.ui.control.Label
        PATHEditField             matlab.ui.control.EditField
        ListBox                   matlab.ui.control.ListBox
        DispersionEditFieldLabel  matlab.ui.control.Label
        DispersionEditField       matlab.ui.control.EditField
        PlotButton                matlab.ui.control.Button
        ShiftEditField            matlab.ui.control.EditField
        ShiftButton               matlab.ui.control.Button
        SaveButton                matlab.ui.control.Button
        HoldCheckBox              matlab.ui.control.CheckBox
        INFOTextAreaLabel         matlab.ui.control.Label
        INFOTextArea              matlab.ui.control.TextArea
        PositionEditField         matlab.ui.control.EditField
        UIAxes                    matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: OpenButton
        function OpenButtonPushed(app, event)
            app.PATHEditField.Value = uigetdir('C:\');
            global filepath;
            filepath = app.PATHEditField.Value;
            fileinfo = dir([filepath,'/*.h5']);
            app.ListBox.Items = {fileinfo.name};
%             cd(filepath);
%             cd('..');
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            global xdata ydata energydispersion;
            filelist = app.ListBox.Value;
            energydispersion = str2double(app.DispersionEditField.Value);
            [xdata,ydata] = RIXSplot(filelist);
            plot(app.UIAxes,xdata,ydata);
        end

        % Button pushed function: ShiftButton
        function ShiftButtonPushed(app, event)
            global xdata ydata;
            shiftvalue = app.ShiftEditField.Value;
            xdata = xdata + str2double(shiftvalue);
            plot(app.UIAxes,xdata,ydata);
        end

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            infovalue = app.ListBox.Value;
            app.INFOTextArea.Value = RIXSinfo(infovalue);
            value = app.HoldCheckBox.Value;
            if value == 0
                PlotButtonPushed(app, event);
            end
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            global xdata ydata;
            data = [xdata,ydata];
            comments = RIXSinfo(app.ListBox.Value);
            [fname,pth] = uiputfile('.txt');
            fid = fopen([pth,fname], 'wt');
            fprintf(fid,'%s', comments);
            fclose(fid);
            dlmwrite([pth,fname],data,'delimiter','\t','-append');
        end

        % Value changed function: HoldCheckBox
        function HoldCheckBoxValueChanged(app, event)
            value = app.HoldCheckBox.Value;
            if value == 1
                app.UIAxes.NextPlot = 'add';
            else
                app.UIAxes.NextPlot = 'replacechildren';
            end
        end

        % Window button motion function: RIXSplotUIFigure
        function RIXSplotUIFigureWindowButtonMotion(app, event)
            currPt = app.UIAxes.CurrentPoint;
            app.PositionEditField.Value = sprintf('( %.3f , %.3f )',currPt(1,1),currPt(1,2));
        end

        % Value changing function: PATHEditField
        function PATHEditFieldValueChanging(app, event)
            changingValue = event.Value;
            global filepath;
            filepath = changingValue;
            fileinfo = dir([filepath,'/*.h5']);
            app.ListBox.Items = {fileinfo.name};
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create RIXSplotUIFigure and hide until all components are created
            app.RIXSplotUIFigure = uifigure('Visible', 'off');
            app.RIXSplotUIFigure.Position = [100 100 839 477];
            app.RIXSplotUIFigure.Name = 'RIXSplot';
            app.RIXSplotUIFigure.WindowButtonMotionFcn = createCallbackFcn(app, @RIXSplotUIFigureWindowButtonMotion, true);

            % Create OpenButton
            app.OpenButton = uibutton(app.RIXSplotUIFigure, 'push');
            app.OpenButton.ButtonPushedFcn = createCallbackFcn(app, @OpenButtonPushed, true);
            app.OpenButton.Position = [18 435 114 26];
            app.OpenButton.Text = 'Open';

            % Create PATHEditFieldLabel
            app.PATHEditFieldLabel = uilabel(app.RIXSplotUIFigure);
            app.PATHEditFieldLabel.HorizontalAlignment = 'right';
            app.PATHEditFieldLabel.Position = [145 437 35 22];
            app.PATHEditFieldLabel.Text = 'PATH';

            % Create PATHEditField
            app.PATHEditField = uieditfield(app.RIXSplotUIFigure, 'text');
            app.PATHEditField.ValueChangingFcn = createCallbackFcn(app, @PATHEditFieldValueChanging, true);
            app.PATHEditField.Tag = 'pathtext';
            app.PATHEditField.Position = [195 435 428 26];
            app.PATHEditField.Value = 'X:\';

            % Create ListBox
            app.ListBox = uilistbox(app.RIXSplotUIFigure);
            app.ListBox.Items = {};
            app.ListBox.Multiselect = 'on';
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Position = [18 136 114 285];
            app.ListBox.Value = {};

            % Create DispersionEditFieldLabel
            app.DispersionEditFieldLabel = uilabel(app.RIXSplotUIFigure);
            app.DispersionEditFieldLabel.HorizontalAlignment = 'right';
            app.DispersionEditFieldLabel.Position = [19 105 62 22];
            app.DispersionEditFieldLabel.Text = 'Dispersion';

            % Create DispersionEditField
            app.DispersionEditField = uieditfield(app.RIXSplotUIFigure, 'text');
            app.DispersionEditField.Position = [89 105 44 21];
            app.DispersionEditField.Value = '1';

            % Create PlotButton
            app.PlotButton = uibutton(app.RIXSplotUIFigure, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [19 75 114 22];
            app.PlotButton.Text = 'Plot';

            % Create ShiftEditField
            app.ShiftEditField = uieditfield(app.RIXSplotUIFigure, 'text');
            app.ShiftEditField.Position = [89 44 44 18];
            app.ShiftEditField.Value = '0';

            % Create ShiftButton
            app.ShiftButton = uibutton(app.RIXSplotUIFigure, 'push');
            app.ShiftButton.ButtonPushedFcn = createCallbackFcn(app, @ShiftButtonPushed, true);
            app.ShiftButton.Position = [19 42 64 22];
            app.ShiftButton.Text = 'Shift';

            % Create SaveButton
            app.SaveButton = uibutton(app.RIXSplotUIFigure, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.Position = [18 7 114 22];
            app.SaveButton.Text = 'Save';

            % Create HoldCheckBox
            app.HoldCheckBox = uicheckbox(app.RIXSplotUIFigure);
            app.HoldCheckBox.ValueChangedFcn = createCallbackFcn(app, @HoldCheckBoxValueChanged, true);
            app.HoldCheckBox.Text = 'Hold';
            app.HoldCheckBox.Position = [639 436 47 22];

            % Create INFOTextAreaLabel
            app.INFOTextAreaLabel = uilabel(app.RIXSplotUIFigure);
            app.INFOTextAreaLabel.HorizontalAlignment = 'right';
            app.INFOTextAreaLabel.Position = [639 411 34 22];
            app.INFOTextAreaLabel.Text = 'INFO';

            % Create INFOTextArea
            app.INFOTextArea = uitextarea(app.RIXSplotUIFigure);
            app.INFOTextArea.Position = [639 223 188 189];

            % Create PositionEditField
            app.PositionEditField = uieditfield(app.RIXSplotUIFigure, 'text');
            app.PositionEditField.Editable = 'off';
            app.PositionEditField.HorizontalAlignment = 'center';
            app.PositionEditField.Position = [639 19 188 26];

            % Create UIAxes
            app.UIAxes = uiaxes(app.RIXSplotUIFigure);
            xlabel(app.UIAxes, 'Energy Transfer (eV)')
            ylabel(app.UIAxes, 'Intensity (arb. units)')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 12;
            app.UIAxes.Position = [145 7 486 414];

            % Show the figure after all components are created
            app.RIXSplotUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ADRESS_RIXS_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.RIXSplotUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.RIXSplotUIFigure)
        end
    end
end