function [xdata,ydata] = RIXSplot(filelist)
    global filepath;
    
    if iscell(filelist)
        filenumber=size(filelist,2);
        for i=1:filenumber
            filename=[filepath,'/',filelist{i}];
            if i == 1
                refdata=h5read(filename,'/entry/analysis/spectrum');
                totTime = mean(h5read(filename,'/entry/instrument/NDAttributes/AcquireTime'));
                pixeldata=transpose([1:size(refdata)]);
                sumdata=refdata;
            else
                uncorrdata=h5read(filename,'/entry/analysis/spectrum');
                oneTime = mean(h5read(filename,'/entry/instrument/NDAttributes/AcquireTime'));
                corrdata=correlatedata(refdata,uncorrdata);
                sumdata=sumdata+corrdata;
                totTime=totTime+oneTime;
            end
        end
        avedata=sumdata/totTime*300;
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
    [pks,locs,w,p] = findpeaks(tempdata,'MinPeakHeight',max(tempdata)/20,'MinPeakProminence',3,'MinPeakWidth',4);
    zeropixel = locs(size(locs,1));
    try
        zerofit = fitelastic(pixeldata,tempdata,zeropixel);
        energydata = (pixeldata - zerofit) .* energydispersion;
    catch
        energydata = (pixeldata - zeropixel) .* energydispersion;
    end
end

function zerofit = fitelastic(pixeldata,tempdata,zeropixel)
    global energydispersion;

    func = fittype('a+b*x+amp*exp(-4*log(2)*(x-xc)^2/(fwhm)^2)','independent','x','coefficients', {'a','b','amp' , 'xc', 'fwhm'});
    op = fitoptions('Method','NonlinearLeastSquares','Lower',[0, -Inf, 0 , zeropixel-20, 8],'Upper',[Inf, 0, Inf, zeropixel+20, 16],'startpoint', [0, -1, 10,zeropixel, 10]);
    fitobject = fit( pixeldata(zeropixel-50:zeropixel+50,1),tempdata(zeropixel-50:zeropixel+50,1), func, op );
    results=coeffvalues(fitobject);
    zerofit = results(4);
end