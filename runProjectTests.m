% Open project
proj = openProject("AirframeExample.prj");

% List all project files with the label "Test"
files = proj.Files;
testFiles = [findLabel(files,"Classification","Test").File];

% Run tests
runtests(testFiles)

close(proj)

%   Copyright 2022 The MathWorks, Inc.