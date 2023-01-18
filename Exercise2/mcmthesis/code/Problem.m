%% 初始化
clc,clear,close all;
%% 数据导入
matches=readcell("matches.csv");
passingEvents=readcell("passingevents.csv");
fullEvents=readcell("fullevents.csv");
%% 网络初步构建
playerNet=digraph(passingEvents(2:320,3),passingEvents(2:320,4),1);
playerNet2=simplify(playerNet,'sum');
playerNet2=adjacency(playerNet2,"weighted");
name={'HuskiesD1','HuskiesF1','HuskiesM1','HuskiesF2','OpponentD2','OpponentG1','OpponentF1','HuskiesM2','HuskiesM3','OpponentD1','OpponentF2','OpponentM1','OpponentD3','OpponentM2','HuskiesG1','HuskiesD2','HuskiesD3','HuskiesD4','OpponentD4','OpponentM3','OpponentF3','HuskiesF3'};
playerNet2=digraph(playerNet2,name);
figure
p=plot(playerNet2,'EdgeLabel',playerNet2.Edges.Weight,'LineWidth',6*playerNet2.Edges.Weight/max(playerNet2.Edges.Weight));
% figure
% plot(playerNet);
%% 坐标添加
namelist={'Huskies_D1','Huskies_F1','Huskies_M1','Huskies_F2','Opponent1_D2','Opponent1_G1','Opponent1_F1','Huskies_M2','Huskies_M3','Opponent1_D1','Opponent1_F2','Opponent1_M1','Opponent1_D3','Opponent1_M2','Huskies_G1','Huskies_D2','Huskies_D3','Huskies_D4','Opponent1_D4','Opponent1_M3','Opponent1_F3','Huskies_F3'};
coordinate=zeros(22,2);
for i=1:22
    temp=zeros(320,2);
    for j=1:320
        if strcmp(passingEvents{j,3},namelist{1,i})
            temp(j,1)=passingEvents{j,8};
            temp(j,2)=passingEvents{j,9};
        end
    end
    temp=temp(temp(:,1)~=0,:);
    coordinate(i,1)=mean(temp(:,1));
    coordinate(i,2)=mean(temp(:,2));
end
p.XData=coordinate(:,1);
p.YData=coordinate(:,2);
%% 提取子图
playerNet2_H=subgraph(playerNet2,{'HuskiesD1','HuskiesF1','HuskiesM1','HuskiesM2','HuskiesG1','HuskiesM3','HuskiesF2','HuskiesD2','HuskiesD3','HuskiesD4','HuskiesF3'});
playerNet2_O=subgraph(playerNet2,{'OpponentD2','OpponentG1','OpponentF1','OpponentD1','OpponentF2','OpponentM1','OpponentD3','OpponentM2','OpponentD4','OpponentM3','OpponentF3'});
figure
plot(playerNet2_H,'XData',coordinate([1:4,8:9,15:18,22],1),'YData',coordinate([1:4,8:9,15:18,22],2),'EdgeLabel',playerNet2_H.Edges.Weight,'LineWidth',6*playerNet2_H.Edges.Weight/max(playerNet2_H.Edges.Weight));
figure
plot(playerNet2_O,'XData',coordinate([5:7,10:14,19:21],1),'YData',coordinate([5:7,10:14,19:21],2),'EdgeLabel',playerNet2_O.Edges.Weight,'LineWidth',6*playerNet2_O.Edges.Weight/max(playerNet2_O.Edges.Weight));
%% 网络分析
deg_ranks = centrality(playerNet2_H,'outdegree','Importance',playerNet2_H.Edges.Weight);
color=centrality(playerNet2_H,'outcloseness');
edges = linspace(min(deg_ranks),max(deg_ranks),10);
bins = discretize(deg_ranks,edges);
figure
plot(playerNet2_H,'XData',coordinate([1:4,8:9,15:18,22],1),'YData',coordinate([1:4,8:9,15:18,22],2),'MarkerSize',bins,'NodeCData',color);
deg_ranks = centrality(playerNet2_H,'indegree','Importance',playerNet2_H.Edges.Weight);
color=centrality(playerNet2_H,'incloseness');
edges = linspace(min(deg_ranks),max(deg_ranks),10);
bins = discretize(deg_ranks,edges);
figure
plot(playerNet2_H,'XData',coordinate([1:4,8:9,15:18,22],1),'YData',coordinate([1:4,8:9,15:18,22],2),'MarkerSize',bins,'NodeCData',color);
