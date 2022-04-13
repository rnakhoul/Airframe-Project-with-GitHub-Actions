function diffGitHub_push(previouspush,lastpush)
    % Open project
    proj = openProject(pwd);
    
    % List last modified model since last push. Use *** to search recursively for modified 
    % SLX files starting in the current folder
    gitCommand = sprintf('git diff --name-only refs/remotes/origin/main %s ***.slx',previouspush);
    [status,modifiedFiles] = system(gitCommand);
    modifiedFiles = split(modifiedFiles);
    modifiedFiles = modifiedFiles(1:(end-1)); % Removing last element because it is empty.
    
    if isempty(modifiedFiles)
        disp('No modified models to compare.')
        return
    end
    
    % Create a temporary folder
    tempdir = fullfile(proj.RootFolder, "modelscopy");
    mkdir(tempdir)
    
    % Generate a comparison report for every modified model file
    for i = 1: size(modifiedFiles)
        report = diffToAncestor(tempdir,string(modifiedFiles(i)),previouspush);
    end
    
    % Delete the temporary folder
    rmdir modelscopy s
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function report = diffToAncestor(tempdir,fileName,previouspush)
        
        ancestor = getAncestor(tempdir,fileName,previouspush);
    
        % Compare models and publish results in a printable report. 
        % Specify the format using 'pdf', 'html', or 'docx'.
        comp= visdiff(ancestor, fileName);
        filter(comp, 'unfiltered');
        report = publish(comp,'html');
        
    end
    
    
    function ancestor = getAncestor(tempdir,fileName,previouspush)
        
        [relpath, name, ext] = fileparts(fileName);
        ancestor = fullfile(tempdir, name);
        
        % Replace seperators to work with Git and create ancestor file name
        fileName = strrep(fileName, '\', '/');
        ancestor = strrep(sprintf('%s%s%s',ancestor, "_ancestor", ext), '\', '/');
        
        % Build git command to get ancestor
        % git show lastpush:models/modelname.slx > modelscopy/modelname_ancestor.slx
        gitCommand = sprintf('git show refs/remotes/origin/main %s:%s > %s', previouspush, fileName, ancestor);
        
        [status, result] = system(gitCommand);
        assert(status==0, result);
    
    end
end

%   Copyright 2022 The MathWorks, Inc.