% Open project
proj = openProject("AirframeExample.prj");

% List of last modified models. Use *** to search recursively for modified 
% SLX files starting in the current folder
[status,modifiedFiles] = system("git diff --name-only HEAD~1..HEAD ***.slx ")
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
    report = diffToAncestor(tempdir,string(modifiedFiles(i)))
end

% Delete the temporary folder
rmdir modelscopy s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function report = diffToAncestor(tempdir,fileName)
    
    ancestor = getAncestor(tempdir,fileName);

    % Compare models and publish report
    comp= visdiff(ancestor, fileName);
    filter(comp, 'unfiltered');
    report = publish(comp,'html');
    
end


function ancestor = getAncestor(tempdir,fileName)
    
    [relpath, name, ext] = fileparts(fileName);
    ancestor = fullfile(tempdir, name);
    
    % Replace seperators to work with Git and create ancestor file name
    fileName = strrep(fileName, '\', '/');
    ancestor = strrep(sprintf('%s%s%s',ancestor, "_ancestor", ext), '\', '/');
    
    % Build git command to get ancestor -> !git show HEAD~1:models/modelname.slx > modelscopy/modelname_ancestor.slx
    gitCommand = sprintf('git show HEAD~1:%s > %s', fileName, ancestor);
    
    [status, result] = system(gitCommand);
    assert(status==0, result);

end