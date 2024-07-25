data=readtable('final_new.csv','VariableNamingRule','preserve');
rng(1); % for reproducibility

%show columns

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


rng(4)

cv=cvpartition(size(data1,1),'HoldOut',0.3);
idx=cv.test;

dataTrain=data1(~idx,:);
epdo_train=epdo(~idx,:);
dataTest=data1(idx,:);
epdo_test=epdo(idx,:);

inputArg1=dataTrain;
inputArg2=epdo_train;



% Bayesin Optimization Process usin gOOB Samples 
maxMinLS=20;
minLS=optimizableVariable('minLS',[1,maxMinLS],'Type','integer'); % min LS: 1 to 20, minimum leaf size: 1 to 20
numPTS=optimizableVariable('numPTS',[1,size(inputArg1,2)-1],'Type','integer'); % number of predictors to sample: 1 to 12
num_tree=optimizableVariable('num_tree',[1,100],'Type','integer'); % number of trees: 1 to 100
hyperparametersRF=[minLS;numPTS;num_tree];

% loop for bayesian optimization
results = bayesopt(@(params)oobErrRF(params,inputArg1,inputArg2),hyperparametersRF,...
    'AcquisitionFunctionName','expected-improvement-plus','Verbose',1);
bestOOBErr=results.MinObjective
bestHyperparameters=results.XAtMinObjective

% TreeBagger Model with Optimal Hyperparameters, OOB Error
function oobErr = oobErrRF(params,inputArg1, inputArg2)

model_bagging=TreeBagger(params.num_tree,inputArg1,inputArg2,...
    'MinLeafSize',params.minLS,...
'NumPredictorstoSample',params.numPTS, OOBPrediction="on", Method="regression");

%function oobErr = oobErrRF(params,X)
oobErr = oobError(model_bagging, 'Mode','ensemble');

end

model_bagger_opt=TreeBagger(bestHyperparameters.num_tree,inputArg1,inputArg2,...
    'MinLeafSize',bestHyperparameters.minLS,...
'NumPredictorstoSample',bestHyperparameters.numPTS, OOBPrediction="on", Method="regression");





y_pred=predict(model_bagger_opt,inputArg1);

% calculate rmse
rmse_test=mean((epdo_test-predict(model_bagger_opt,dataTest)).^2)
rmse_train=mean((epdo_train-predict(model_bagger_opt,dataTrain)).^2)


f=@(inputArg1)predict(model_bagger_opt,inputArg1,Trees=1:bestHyperparameters.num_tree);

% SHAPLEY for one sampel, it would take a while to run multiple samples, simple define more rows in fit function. 
explainer=shapley(f,inputArg1);
explainer=fit(explainer,inputArg1([1],:));
% shows the swarmchart
swarmchart(explainer)