classdef IOData < handle
    % A class to handle IO
    
    properties
        img_path
        lines_path
    end
    
    methods
        function obj = IOData(img_path_in, lines_path_in)
            obj.img_path = img_path_in;
            obj.lines_path = lines_path_in;
        end
        
        function [img,flag] = read_pgm(obj,idx)
            img_name = fullfile(obj.img_path,strcat(num2str(idx),'.pgm'));
            if (exist(img_name) == 0)
                flag = 0;
                img = [];
            else
                flag = 1;
                img = im2double(imread(img_name));
            end
        end
        
        function [lines,flag] = read_lines(obj,idx)
            mat_name = fullfile(obj.lines_path,strcat(num2str(idx),'.mat'));
            if (exist(mat_name) == 0)
                flag = 0;
                lines = [];
            else
                flag = 1;
                load(mat_name);
                % return lines
                return;
            end
        end
    end
    
end

