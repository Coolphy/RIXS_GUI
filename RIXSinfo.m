function fileinfo = RIXSinfo(filelist)
    global filepath;
    fileinfo = 'info';
    
    if iscell(filelist)
        filename=[filepath,'/',filelist{1}];
        ee=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/PhotonEnergy')));
        p=mean(h5read(filename,'/entry/instrument/NDAttributes/PolarMode'));
        if p == 0
            pp = 'LH';
        elseif p == 1
            pp = 'LV';
        elseif p == 2
            pp = 'C+';
        else
            pp = 'C-';
        end
        tt=sprintf('%.1f',mean(h5read(filename,'/entry/instrument/NDAttributes/SampleTemp')));
        xx=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/SampleXs')));
        yy=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/SampleYs')));
        zz=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/SampleZ')));
        thth=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/SampleTheta')));
        phph=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/SamplePhi')));
        tltl=sprintf('%.3f',mean(h5read(filename,'/entry/instrument/NDAttributes/SampleTilt')));
        atat=sprintf('%d',mean(h5read(filename,'/entry/instrument/NDAttributes/AcquireTime')));
        spsp=sprintf('%d',mean(h5read(filename,'/entry/instrument/NDAttributes/ExposureSplit')));
        slsl=sprintf('%.1f',mean(h5read(filename,'/entry/instrument/NDAttributes/ExitSlit')));
        bcbc=sprintf('%.0f',mean(h5read(filename,'/entry/instrument/NDAttributes/BeamCurrent')));

        info = strcat('# Energy : ',ee);
        info = [info newline strcat('# Polarization : ',pp)];
        info = [info newline strcat('# Temperature : ',tt)];
        info = [info newline strcat('# Sample x : ',xx)];
        info = [info newline strcat('# Sample y : ',yy)];
        info = [info newline strcat('# Sample z : ',zz)];
        info = [info newline strcat('# Sample Theta : ',thth)];
        info = [info newline strcat('# Sample Phi : ',phph)];
        info = [info newline strcat('# Sample Tilt : ',tltl)];
        info = [info newline strcat('# Acquire Time : ',atat)];
        info = [info newline strcat('# Exposure Split : ',spsp)];
        info = [info newline strcat('# Exit Slit : ',slsl)];
        info = [info newline strcat('# Beam Current : ',bcbc)];
        
        fileinfo = info;
    end
end
