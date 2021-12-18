clear all; close all;

data_depth = 400
export_fig = 1
vraag = 'vraage'

[data_R_temp,files_R,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\R9.5199e_7\',data_depth,vraag);      %_R means for cte R, Q is variating
[data_Q_temp,files_Q,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\Qe_8\',data_depth,vraag);

[m,n,pR] = size(data_R_temp);
[~,~,pQ] = size(data_Q_temp);

data = zeros(m,n,(pR+pQ));
data(:,:,(1:pR)) = data_R_temp;
data(:,:,((pR+1):(pR+pQ))) = data_Q_temp;
files = [files_R, files_Q];

for i = 1:length(files)
    
    filename = convertCharsToStrings(files(i))
    
    figure()
    hold on 
    plot(t, data(:,9,i))
    plot(t, -data(:,10,i))
    xlabel("t [s]",'Interpreter','Latex')
    ylabel('-$\hat{x}$ [m] , y [m]','Interpreter','Latex')
    legend("Measured front distance", "Estimated state",'Interpreter','Latex')
    
    filename = strsplit(filename,'\');
    measurementName = erase(filename(end),'.csv');

    if export_fig
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 6 3];
        print(measurementName,'-dpng','-r0')
        movefile(".\"+measurementName+".png", ".\Estimator_response")
    end 

end