% Created on 2020-08-22 by Raymond Yang

classdef PARTICLE
   properties
       position;
       velocity;
       cost;
       best_position;
       best_cost;
   end
   
   methods
       function obj = PARTICLE(num_var,varargin)
           IP = inputParser;
           addRequired(IP,'num_var',@(x)(x>0));
           addParameter(IP,'lower_bound',[]);
           addParameter(IP,'upper_bound',[]);
           addParameter(IP,'position',[]);
           parse(IP,num_var,varargin{:});
           
           if(isempty(IP.Results.lower_bound) && isempty(IP.Results.upper_bound) && ~isempty(IP.Results.position))
               obj.position = IP.Results.position;
           elseif(~isempty(IP.Results.lower_bound) && ~isempty(IP.Results.upper_bound) && isempty(IP.Results.position))
               obj.position = unifrnd(IP.Results.lower_bound,IP.Results.upper_bound);
           else
               obj.position = zeros(1,num_var);
           end
       end
   end   
end