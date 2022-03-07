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

        info = strcat('# Energy : ',ee,' eV');
        info = [info newline strcat('# Polarization : ',pp)];
        info = [info newline strcat('# Temperature : ',tt,' K')];
        info = [info newline strcat('# Sample x : ',xx,' mm')];
        info = [info newline strcat('# Sample y : ',yy,' mm')];
        info = [info newline strcat('# Sample z : ',zz,' mm')];
        info = [info newline strcat('# Sample Theta : ',thth,' deg.')];
        info = [info newline strcat('# Sample Phi : ',phph,' deg.')];
        info = [info newline strcat('# Sample Tilt : ',tltl,' deg.')];
        info = [info newline strcat('# Acquire Time : ',atat,' s')];
        info = [info newline strcat('# Exposure Split : ',spsp,' s')];
        info = [info newline strcat('# Exit Slit : ',slsl,' um')];
        info = [info newline strcat('# Beam Current : ',bcbc,' mA')];
        
        fileinfo = info;
    end
end
