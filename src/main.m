% Created on 2020-08-22 by Raymond Yang
clear; close all; clc;

% Optimization function: De Jong's fifth function
% [-50,50]
% objfunc = @dejong5fcn;

% Optimization function: Rastrigin's function
% Global minimum at [0,0]
objfunc = @rastriginsfcn; 

pso = PSO(objfunc,2,'lower_bound',[-50,-50],'upper_bound',[50,50],...
    'max_iter',150,'max_v',10,'c1',0.5,'c2',2,'swarm_size',100,...
    'w_damp',0.95);

pso = pso.initialize();
pso = pso.run();
frames = pso.info();
