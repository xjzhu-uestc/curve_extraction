% Simple 3D example
% Showing the effect of the different types of regularization
% Note the following:
% 1. Strong length regularization gives shortest possible curve.
% 2. Strong curvature regularization gives a straight curve.
% 3. Strong torsion regularization gives a curve contained in a plane.

% The blue surface corresponds to the start set 
% and the green surface to the end set.
close all; clear all;
addpath([fileparts(mfilename('fullpath')) filesep '..']);

rng(1)
n = 10;
data = rand(n,n,n);

% True at voxels where it allowed to start/end
start_set = false(size(data));
end_set = false(size(data));

% Possible to forbid certain voxels.
disallowed = false(size(data));

% Define start/end set.
start_set(:,:,1) = true;
end_set(:,:,end) = true;


%% Create Curve object
C = Curve_extraction(data, start_set, end_set, disallowed);
C.set_connectivity_by_radius(4);

C.store_visit_time = true;
strength = 1e2;
%%
C.length_penalty = strength;
C.curvature_penalty = 0;
C.torsion_penalty = 0;

c{1} = C.shortest_path();

%%
C.length_penalty = 0;
C.curvature_penalty = strength;
C.torsion_penalty = 0;

c{2} = C.shortest_path();

%%
C.length_penalty = 0;
C.curvature_penalty = 0;
C.torsion_penalty = strength;

c{3} = C.shortest_path();

%% View
figure(1); clf; hold on;
m = [0.0384 0.1112 0.2790;
    0.6650 0.1675 0.1675;
    0.3726 0.9210 0.1350];
	
for i = 1:length(c)
	plot3(c{i}(:,1),c{i}(:,2),c{i}(:,3),'color', m(i,:),'linewidth',3);
end

% Show start and end set
axis equal;
axis off;
axis vis3d;
view(3);
legend('Length','Curvature','Torsion');

% Bottom, start set
X = [1 1 n n];
Y = [1 n n 1];
Z = [1 1 1 1];
fill3(X,Y,Z,[0 0 0.8],'FaceAlpha', 0.2)

% Top, end set.
Z = [n n n n];
fill3(X,Y,Z,[0 0.8 0],'FaceAlpha', 0.2)

