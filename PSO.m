% Created on 2020-08-22 by Raymond Yang

classdef PSO
    
    properties (SetAccess = private)
        objfunc;
        num_var;
        lower_bound;
        upper_bound;
        swarm_size;
        c1;
        c2;
        w;
        w_damp;
        max_v;
        max_iter;
        
        gbest_cost_history;
        cur_iter;
        
        particle;
        gbest_position;
        gbest_cost;
    end
    
    methods
        function obj = PSO(objfunc,num_var,varargin)
            IP = inputParser;
            addRequired(IP,'objfunc');
            addRequired(IP,'num_var',@(x)(x>0));
            addParameter(IP,'lower_bound',@(x)(x>-inf));
            addParameter(IP,'upper_bound',@(x)(x<+inf));
            addParameter(IP,'swarm_size',20);
            addParameter(IP,'c1',2);
            addParameter(IP,'c2',2);
            addParameter(IP,'w',1);
            addParameter(IP,'w_damp',0.95);
            addParameter(IP,'max_v',0.05);
            addParameter(IP,'max_iter',20);
            parse(IP,objfunc,num_var,varargin{:});
            
            obj.objfunc = IP.Results.objfunc;
            obj.num_var = IP.Results.num_var;
            obj.lower_bound = IP.Results.lower_bound;
            obj.upper_bound = IP.Results.upper_bound;
            obj.swarm_size = IP.Results.swarm_size;
            obj.c1 = IP.Results.c1;
            obj.c2 = IP.Results.c2;
            obj.w = IP.Results.w;
            obj.w_damp = IP.Results.w_damp;
            obj.max_v = IP.Results.max_v;
            obj.max_iter = IP.Results.max_iter;
            
        end
        
        function obj = initialize(obj)
            obj.particle = repmat(PARTICLE(obj.num_var),obj.swarm_size,1);
            obj.gbest_cost = +inf;
            obj.gbest_cost_history = zeros(obj.max_iter,1);
            obj.cur_iter = 0;
            for i = 1:obj.swarm_size
%                 obj.particle(i) = PARTICLE(obj.num_var,'lower_bound',obj.lower_bound,'upper_bound',obj.upper_bound);
                obj.particle(i) = PARTICLE(obj.num_var,'position',[(floor((i-1)/10)+1)/10*obj.upper_bound(1)-4,(mod(i-1,10)+1)/10*obj.upper_bound(2)-4]);
                obj.particle(i).velocity = zeros(1,obj.num_var);
                obj.particle(i).cost = obj.objfunc(obj.particle(i).position);
                obj.particle(i).best_position = obj.particle(i).position;
                obj.particle(i).best_cost = obj.particle(i).cost;
                if obj.particle(i).best_cost < obj.gbest_cost
                    obj.gbest_position = obj.particle(i).best_position;
                    obj.gbest_cost = obj.particle(i).best_cost;
                end
            end
        end
      
        function obj = run(obj)
            for k = 1:obj.max_iter
                for i = 1:obj.swarm_size
                    next_velocity = obj.w*obj.particle(i).velocity ...
                        + obj.c1*rand([1,obj.num_var]).*(obj.particle(i).best_position - obj.particle(i).position) ...
                        + obj.c2*rand([1,obj.num_var]).*(obj.gbest_position - obj.particle(i).position); 
                    if(next_velocity <= obj.max_v)
                        obj.particle(i).velocity = next_velocity;
                    end

                    obj.particle(i).position = obj.particle(i).position + obj.particle(i).velocity;
                    obj.particle(i).position(obj.particle(i).position > obj.upper_bound) = obj.upper_bound(obj.particle(i).position > obj.upper_bound);
                    obj.particle(i).position(obj.particle(i).position < obj.lower_bound) = obj.lower_bound(obj.particle(i).position < obj.lower_bound);

                    obj.particle(i).cost = obj.objfunc(obj.particle(i).position);

                    if obj.particle(i).cost < obj.particle(i).best_cost
                        obj.particle(i).best_position = obj.particle(i).position;
                        obj.particle(i).best_cost = obj.particle(i).cost;
                    end    

                    if obj.particle(i).best_cost < obj.gbest_cost
                        obj.gbest_position = obj.particle(i).best_position;
                        obj.gbest_cost = obj.particle(i).best_cost;
                    end

                end
                obj.w = obj.w*obj.w_damp;
                obj.cur_iter = k;
                obj.gbest_cost_history(k) = obj.gbest_cost;
            end
        end

        function fdata = info(obj)
            fdata(obj.max_iter) = struct('cdata',[],'colormap',[]);
            figure,
            xlim([0 obj.max_iter])
            for k = 1:obj.max_iter
                hold on
                scatter(k,obj.gbest_cost_history(k),'b.')
                title(['Best Cost = ',num2str(obj.gbest_cost_history(k))])
                drawnow;
                fdata(k) = getframe;
            end
        end
        
    end    
end

