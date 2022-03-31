proj = openProject("AirframeExample.prj");
files = proj.Files;
testFiles = [findLabel(files,"Classification","Test").File];
runtests(testFiles)
close(proj)