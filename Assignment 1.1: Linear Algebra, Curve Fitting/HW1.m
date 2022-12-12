load("HW1_Q1.mat")

%%LINEAR REGRESSION
t=(linspace(1,length(f), length(f)))';

%this is vector f
alpha = [t, ones([numel(t),1])];
%this is vector v
beta = f;

x = alpha\beta;
linearFit = x(1)*t+x(2);
altx = inv(alpha'*alpha)*(alpha'*beta);
altFit = x(1)*t+x(2);

%% QUADRATIC REGRESSION
alpha = [t.^2, t, ones([numel(t),1])];
beta = f;
x = alpha\beta;
quadraticFit = x(1)*(t.^2)+x(2)*t+x(3);

c = linspace(1,10,length(f));
scatter(t,f,10,c,'filled');
hold on;
plot(t,linearFit,color="red");
hold on;
plot(t,altFit,color="black");
hold on;
plot(t,quadraticFit,color="magenta");
%two methods (linear and alt) result in the same line

%is #3 the same as the residual minimization we did in class?