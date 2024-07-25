data=readtable('final_new.csv','VariableNamingRule','preserve');
rng(5); % for reproducibility


data.Properties.VariableNames
data1=data(:,41:53);
y=data.t_caslt_cnt;

% get average of EPDO near 6 hexagons
dth_count1=data.dth_dnv_cnt_1;
dth_count2=data.dth_dnv_cnt_2;
dth_count3=data.dth_dnv_cnt_3;
dth_count4=data.dth_dnv_cnt_4;
dth_count5=data.dth_dnv_cnt_5;
dth_count6=data.dth_dnv_cnt_6;
mean_dth_count=(dth_count1+dth_count2+dth_count3+dth_count4+dth_count5+dth_count6)/6;


se_count1=data.se_dnv_cnt_1;
se_count2=data.se_dnv_cnt_2;
se_count3=data.se_dnv_cnt_3;
se_count4=data.se_dnv_cnt_4;
se_count5=data.se_dnv_cnt_5;
se_count6=data.se_dnv_cnt_6;
mean_se_count=(se_count1+se_count2+se_count3+se_count4+se_count5+se_count6)/6;

sl_count1=data.sl_dnv_cnt_1;
sl_count2=data.sl_dnv_cnt_2;
sl_count3=data.sl_dnv_cnt_3;
sl_count4=data.sl_dnv_cnt_4;
sl_count5=data.sl_dnv_cnt_5;
sl_count6=data.sl_dnv_cnt_6;
mean_sl_count=(sl_count1+sl_count2+sl_count3+sl_count4+sl_count5+sl_count6)/6;

epdo=4*mean_dth_count+2*mean_se_count+1*mean_sl_count;
data1.Properties.VariableNames

%correlation heatmap
r=corr(table2array(data1));
h = heatmap(r,'MissingDataColor','w')
labels=data1.Properties.VariableNames
h.XDisplayLabels = labels;
h.YDisplayLabels = labels; 
h.Interpreter = 'none';


% Train-Test Split 
cv=cvpartition(size(data1,1),'HoldOut',0.3);
idx=cv.test;

dataTrain=data1(~idx,:);
epdo_train=epdo(~idx,:);
dataTest=data1(idx,:);
epdo_test=epdo(idx,:);


%Linear Regression. 
model_linear=fitglm(dataTrain, epdo_train, 'Distribution','normal')
y_pred=predict(model_linear,dataTest);


rmse=mean((epdo_test-predict(model_linear,dataTest)).^2)
rmse_train=mean((epdo_train-predict(model_linear,dataTrain)).^2)