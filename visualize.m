function p = visualize( L, P_loads, P_gen, I_line)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% extracting sources and target from L matrix
set(0,'defaultAxesFontSize',20);
set(0,'defaultTextFontSize',20);
new_col = zeros(1,size(L,2));
new_row = zeros(1,size(L,1)+1)';
L = [new_col;L];
L = [new_row,L];
L(1,1) = -1;
L(2,1) = 1;

S =[];
T =[];

for u=1:size(L,1)
    for v =1:size(L,2)
        if L(v,u) == 1
            S = [S,u];
            T=[T,v]; 
        end
    end
end

%% Adapt defined configuratrion to graph 
%Without this for loop configuration could be wrong in some point because
%the way that Graph class sets the node and edges can be differnet from what we introduced.

NewILine = zeros(size(I_line));
for i=1:size(T,2)
    NewILine(i,:)= I_line(T(i)-1,:);
end

%% name setting
% it is conventional that the name of lines coincides with the name of
% ending node between parentheses (e.g. line (14) ends to node 14)

EdgesNames = {};
for j=1:size(T,2)
    name = strcat({'('},num2str(T(j)-1), {')'});
    EdgesNames=[EdgesNames,name];
end

NodeNames = {};
for j=1:size(L,1)
    name = num2str(j-1);
    NodeNames=[NodeNames,name];
end

%% line color setting
edge_colors = zeros(size(T,2),3);
edge_colors(:,3) = 1 ;

%% node color setting
node_colors = zeros(size(L,2),3);
node_colors(:,3) = 1 ;
node_colors(1,2) = 1 ;

shadow_node_colors = zeros(size(L,2),3);
shadow_node_colors(:,3) = 1 ;
shadow_node_colors(1,2) = 1 ;
%% graph
figure('name', 'Physical Network Structure and Heatmap Analysis','NumberTitle','off');
hold on
set(gcf,'units','normalized','outerposition',[0 0 1 1])
G = graph(S,T);

% p0 = plot(G);
% X_pos = p0.XData;
% Y_pos = p0.YData;

% shadow graphPlot is dedicated to the second layer 
p = plot(G,'Layout','layered','EdgeLabel', EdgesNames,'NodeLabel',NodeNames);
p_shadow = plot(G,'Layout','layered');
p.NodeLabel = repmat({''}, 1, size(L,1));
p.EdgeAlpha = 1;
p_shadow.LineStyle = {'none'};
p_shadow.Marker = ['none', repmat({'o'}, 1, size(L,1)-1)];

% p.XData = X_pos;
% p.YData = Y_pos;

az = 30;
el = 80;
axis off
% rotate3d on
% view(az,el);

%% attribute setting
p.MarkerSize = ones(1,size(L,1))*10;
p_shadow.MarkerSize = ones(1,size(L,1))*10;

p.MarkerSize(1) = p.MarkerSize(1,1)*2;
p.Marker = ['s', repmat({'o'}, 1, size(L,1)-1)];

p.NodeColor = node_colors;
p_shadow.NodeColor = shadow_node_colors;

p.EdgeColor = edge_colors;

p_shadow.NodeLabel = NodeNames;
p.NodeLabel(1) = {'Slack bus'};

line_width = ones(1,size(T,2));

mkdir('images');
print('images\cold','-dpng');

%pause(0.25);

%% Heatmap Visualization
heat_map()

%% Heat Map function; implemented here to simplfy to underestand the process
    function heat_map()
        i_abs_max = max(max(I_line));
        p_max = max(max(max(abs(P_gen))),max(max(P_loads)));
        P_major = zeros(size(P_loads));
        gen_idx = find (abs(P_gen)>P_loads);
        P_major (gen_idx) = P_gen(gen_idx);
        load_idx = find (abs(P_gen)<=P_loads);
        P_major (load_idx) = P_loads(load_idx);
        
        P_minor = zeros(size(P_loads));
        gen_idx = find (abs(P_gen)<=P_loads);
        P_minor (gen_idx) = P_gen(gen_idx);
        load_idx = find (abs(P_gen)>P_loads);
        P_minor (load_idx) = P_loads(load_idx);
        for l=1:size(NewILine,2)
            p.LineWidth = 10*(NewILine(:,l)/i_abs_max)';
            
            idx1 = find(NewILine(:,l)>0.9);
            idx2 = find(NewILine(:,l)<0.2);
%           idx3 = setdiff(1:length(I_line(:,l)), idx1);
            warm = NewILine(:,l);
%           cold = I_line(:,l);
            warm(idx1)=1;
            warm(idx2)=0;
            
            p.EdgeColor(:,1) = warm;
            p.EdgeColor(:,2) = (1 - warm)*0.25;
            p.EdgeColor(:,3) = 1 - warm;

            p.MarkerSize(2:end)=(abs(P_major(:,l).^0.65))';
            p_shadow.MarkerSize(2:end)=(abs(abs(P_minor(:,l)+0.1).^0.65))';

            for ii=1:size(P_major,1)
                if P_major(ii,l)>0
                    p.NodeColor(ii+1,:) = [1 0 0];
                elseif P_major(ii,l)<0
                    p.NodeColor(ii+1,:) = [0 1 0];
                else
                    p.NodeColor(ii+1,:) = [0 1 1];
                end
            end
            
           for ii=1:size(P_minor,1)
                if P_minor(ii,l)>0
                    p_shadow.NodeColor(ii+1,:) = [1 0 0];
                elseif P_minor(ii,l)<0
                    p_shadow.NodeColor(ii+1,:) = [0 1 0];
                else
                    p_shadow.NodeColor(ii+1,:) = [0 1 1];
                end
           end
            
            axis off
            title(strcat(num2str(l),' : 00 : 00'));
%           sprintf('Time: %02d:%02d:%02d', hours, minutes, seconds)
            if l<10
                DispVal = strcat('img00',num2str(l));
            else 
                DispVal = strcat('img0',num2str(l));
            end
%             print(strcat('images\',DispVal),'-dpng');
            saveas( gcf, strcat('images\',DispVal), 'jpg' );
            
        end
    end
end

