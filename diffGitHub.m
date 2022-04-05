[status,modifiedFiles] = system("git diff --name-only HEAD~1..HEAD '*.slx' ");
modifiedFiles = split(modifiedFiles)
modifiedFiles = modifiedFiles(1:(end-1))
!(git show HEAD~1:models/f14_airframe.slx > models/airframe_orig.slx)
comp=visdiff("models/airframe_orig.slx","models/f14_airframe.slx");
filter(comp, 'unfiltered');
file = publish(comp,'pdf')