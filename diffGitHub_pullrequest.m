function diffGitHub_pullrequest(branchname)
    % Open project
    proj = openProject(pwd);

    % List modified models since branch diverged from main
    % Use *** to search recursively for modified SLX files starting in the current folder
    % git diff --name-only refs/remotes/origin/main..refs/remotes/origin/branchtomerge
    gitCommand = sprintf('git diff --name-only refs/remotes/origin/main..refs/remotes/origin/%s ***.slx', branchname);
    [status,modifiedFiles] = system(gitCommand);
    modifiedFiles = split(modifiedFiles);
    modifiedFiles = modifiedFiles(1:(end-1));
    
    if isempty(modifiedFiles)
        disp('No modified models to compare.')
        return
    end
    
    % Create a temporary folder
    tempdir = fullfile(proj.RootFolder, "modelscopy");
    mkdir(tempdir)
    
    % Generate a comparison report for every modified model file
    for i = 1: size(modifiedFiles)
        report = diffToAncestor(tempdir,string(modifiedFiles(i)),branchname);
    end
    
    % Delete the temporary folder
    rmdir modelscopy s
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function report = diffToAncestor(tempdir,fileName,branchname)
    
    ancestor = getAncestor(tempdir,fileName,branchname);

    % Compare models and publish results in a printable report. 
    % Specify the format using 'pdf', 'html', or 'docx'. 
    comp= visdiff(ancestor, fileName);
    filter(comp, 'unfiltered');
    report = publish(comp,'html');
    
end


function ancestor = getAncestor(tempdir,fileName,branchname)
    
    [relpath, name, ext] = fileparts(fileName);
    ancestor = fullfile(tempdir, name);
    
    % Replace seperators to work with Git and create ancestor file name
    fileName = strrep(fileName, '\', '/');
    ancestor = strrep(sprintf('%s%s%s',ancestor, "_ancestor", ext), '\', '/');
    % Build git command to get ancestor from main
    % git show refs/remotes/origin/main:models/modelname.slx > modelscopy/modelname_ancestor.slx
    gitCommand = sprintf('git show refs/remotes/origin/main:%s > %s', fileName, ancestor);
    
    [status, result] = system(gitCommand);
    assert(status==0, result);

end

%   Copyright 2022 The MathWorks, Inc.