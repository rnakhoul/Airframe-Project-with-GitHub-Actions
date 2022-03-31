!git show HEAD~1:models/f14_airframe.slx > airframe_orig.slx
comp=visdiff("airframe_orig","f14_airframe.slx");
filter(comp, 'unfiltered');
file = publish(comp)
web(file)
