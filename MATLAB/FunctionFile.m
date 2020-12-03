classdef FunctionFile
   properties
    name;
    state;
   end

   methods

    function obj = FunctionFile(name)
        obj.name = name;
        obj.state = containers.Map();
    end

    function save(obj, varargin)
        for kk = 1:length(varargin)
            name = varargin{kk};
            obj.state(name) = evalin('caller', name);
        end
        return  
    end

    function close(obj)
        k = keys(obj.state);
        val = values(obj.state);
        s = struct();
        for i = 1:length(obj.state)
            s.(k{i})=val{i};
        end
        hash = DataHash(s);
        hash = hash(end-11:end);
        filename = [obj.name, '-', hash, '.mat'];
        if ~exist(filename, 'file')
            save(filename, '-struct', 's')
        else
            display(['File ', filename, ' already exists. Not overwriting.'])
        end
    end

end  % end methods
end  % end classdef

