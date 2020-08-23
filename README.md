# Particle Swarm Optimization

## Description

A global optimization solver. It solves a problem by having a population of candidate solutions, here dubbed particles, and moving these particles around in the search-space according to simple mathematical formulae over the particle's position and velocity. Each particle's movement is influenced by its local best known position, but is also guided toward the best known positions in the search-space, which are updated as better positions are found by other particles. This is expected to move the swarm toward the best solutions ([Wikipedia](https://en.wikipedia.org/wiki/Particle_swarm_optimization)).

## Demo

Optimization problem: Rastrigin's Function

<p align="center">
<img src="https://github.com/yanghaoqin/PSO/blob/master/pic/rastriginsfcn.png" />
</p>

(Source: Matlab)

<br/>
Optimization performance:

<p align="center">
<img src="https://github.com/yanghaoqin/PSO/blob/master/pic/optimization.gif" />
</p>

## Usage

Run main.m script.
```matlab
pso = PSO(objfunc,2,'lower_bound',[-50,-50],'upper_bound',[50,50]);
pso = pso.initialize();
pso = pso.run();
```
