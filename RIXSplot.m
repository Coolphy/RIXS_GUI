function [xdata,ydata] = RIXSplot(filelist)
    global filepath;
    
    if iscell(filelist)
        filenumber=size(filelist,2);
        for i=1:filenumber
            filename=[filepath,'\',filelist{i}];
            if i == 1
                refdata=h5read(filename,'/entry/analysis/spectrum');
                pixeldata=[1:size(refdata)];
                sumdata=refdata;
            else
                uncorrdata=h5read(filename,'/entry/analysis/spectrum');
                corrdata=correlatedata(refdata,uncorrdata);
                sumdata=sumdata+corrdata;
            end
        end
        avedata=sumdata/filenumber;
        ydata=avedata;
        xdata = zeroenergy(pixeldata,avedata);
    end

end

function corrdata = correlatedata(refdata,uncorrdata)
    [r,lags] = xcorr(refdata,uncorrdata);
    [m,p] = max(r);
    corrdata = circshift(uncorrdata,lags(p));
end

function energydata = zeroenergy(pixeldata,tempdata)
    global energydispersion;
    [pks,locs,w,p] = findpeaks(tempdata,'MinPeakHeight',5,'MinPeakProminence',3,'MinPeakWidth',4);
    zeropixel = locs(size(locs,1));
    try
        zerofit = fitelastic(tempdata,pks,locs,w,p);
        energydata = (pixeldata - zerofit) .* energydispersion;
    catch
        energydata = (pixeldata - zeropixel) .* energydispersion;
    end
end

function zerofit = fitelastic(tempdata,pks,locs,w,p)
    
end