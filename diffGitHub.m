!git show HEAD~1:models/f14_airframe.slx > models/airframe_orig.slx
comp=visdiff("models/airframe_orig.slx","models/f14_airframe.slx");
filter(comp, 'unfiltered');
file = publish(comp,'pdf')