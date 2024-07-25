# Basic Description


## 1. 데이터 설명

총 1200 개의 랜덤으로 뽑힌 도로좌표로 구성한 헥사곤들에 대한 정보

`'x'` :  도로x 좌표

`'y'` : 도로 y좌표

`'h3_address'` : 해당 도로를 포함하는 헥사곤 좌표

`'neighbours'` : 해당 핵사곤의 근접한 6개의 핵사곤 좌표

`'neighbours_centroids'` : 근접한 6개의 핵사곤의 중심좌표

`'caslt_cnt'`  : 중심 헥사곤의 사상자수

`'dth_dnv_cnt`' :중심 헥사곤에서의 사망자수

`'se_dnv_cnt'`  : 중심 헥사곤에서의 중상자수

`'sl_dnv_cnt'` : 중심 헥사곤에서의 경상자수

`'wnd_dnv_cnt'` :중심 헥사곤에서의 부상 신고자수

`'caslt_cnt_i'` : i번째 이웃 헥사곤에서의 사상자수  ($i=1 \sim 6)$

('dth_dnv_cnt_i','se_dnv_cnt_i','sl_dnv_cnt_i','wnd_dnv_cnt_i’ 도 마찬가지로)

`'bus_station_cnt'` : 중심핵사곤 안에 존재하는 버스정류장 수

`'traffic_cnt'` :중심 핵사곤 안에 존재하는 신호등 수

`'pleasure_cnt'` : 중심좌표 반경 500m안에 존재하는 유흥업소 수

`'seoul_police_cnt'` :중심좌표 반경 500m안에 존재하는 경찰서수

`'park_cnt'`  : 중심좌표 반경 500m안에 존재하는 공원수

`'seoul_safety_cnt'` : 중심좌표 반경 500m안에 존재하는 어린이 안전구역

`'crossroad_cnt'` : 중심 헥사곤 안에 존재하는 교차로

`'도로10이하_cnt'` : 중심 헥사곤 안에 존재하는 도로폭 10m이하의 도로수

`'도로10_20_cnt'` :중심 헥사곤 안에 존재하는 도로폭 10 이상 20m이하의 도로수

`'도로20_30_cnt'` :중심 헥사곤 안에 존재하는 도로폭 20이상 30m이하의 도로수

`'도로30이상_cnt'` :중심 헥사곤 안에 존재하는 도로폭 30m이상의 도로수

`'silver_cnt'`: 중심좌표 반경 500m안에 존재하는 노인보호구역(요양원수) 

`'crosswalk_cnt'` : 중심 헥사곤 안에 존재하는 횡단보도수

## 2. Matlab Implementation

Our results are tested and built upon Matlab2024a and Statistics and Machine Learning Toolbox are required to reproduce our code

- Linear Regression 
run `regression_run.m` to check the result for Linear Regression 


- Bagging
run `bag_run.m` to check the result for Bagging, it will automatically perform bayesian optimization and show the result for SHAP.(we have utilized `TreeBagger`  with Regression.) 


- Boosting 
run `boost_run.m` to check the result for Boosting, it will automatically perform bayesian optimization and show the result.(we have utilized `fitrensemble` with Least Squrare )Boosting. 

