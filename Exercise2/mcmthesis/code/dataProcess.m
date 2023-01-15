%% 初始化
clc,clear,close all;
%% 数据导入
matches=readcell("matches.csv");
passingEvents=readcell("passingevents.csv");
fullEvents=readcell("fullevents.csv");
%% 数据处理
playerNet=digraph(passingEvents(2:567,3),passingEvents(2:567,4));
plot(playerNet);