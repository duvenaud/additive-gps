function plot_3d_density( V, range1, range2, range3 )

dx1 = range1(2) - range1(1);
dx2 = range2(2) - range2(1);
dx3 = range3(2) - range3(1);
cmap = colormap;

% normalize V to be between 0 and 1;
maxV = max(V(:));
minV = min(V(:));
V = V - minV;
V = V ./ ( maxV - minV);

figure;
hist(V(:));

figure;
for i = 1:length(range1)
    for j = 1:length(range2)
        for k = 1:length(range3)     
            cur_val = V(i,j,k);
            cur_color = cmap(floor(cur_val * (length(cmap) - 1) + 1),:);
            voxel( [range1(i), range2(j), range3(k)], [dx1 dx2 dx3], cur_color, cur_val/5);
        end
    end
end
view(3); daspect([1 1 1]); %axis tight;
axis( [ min(range1), max(range1),min(range2),max(range2),min(range3),max(range3)]);
end
