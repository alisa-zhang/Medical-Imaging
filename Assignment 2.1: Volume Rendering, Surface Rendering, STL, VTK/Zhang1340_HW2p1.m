% Alisa Zhang Assignment 2.1 (worked with Keegan and Laila)
close all
clear all
clc
% 1.1
A=[5,0,0];
B=[0,0,5];
C=[10,0,5];
Unitnormal=cross(B-A,C-A);

% 1.2
nvec=computeNormals([5,0,0],[0,0,5],[10,0,5]);
[v, f, n, c, stltitle] = stlread('CoronaryArteryBranch-1.stl',1);
[unique_v,ia,ic]=unique(v,'rows');
mean_vectors=zeros(length(unique_v),3);
nvec=zeros(length(f),1);
for i=length(f)
    p1=v(f(i,2),:);
    p2=v(f(i,2),:);
    p3=v(f(i,3),:);
    nvec(i,1:3)=computeNormals(p1,p2,p3);
end 
 for i=1:length(mean_vectors)
 ind=find(v(:,1)==v(ia(i),1) & v(:,2)==v(ia(i),2)& v(:,3)==v(ia(i)),3);
 all_vec=[];
 for j=1:size(ind,1)
     [row,~]=find(f==ind(j));
     all_vec(j,:)=nvec(row,:);
 end 
mean_vectors(i,:)=mean(all_vec);
if mod(i,10000)==0
    fprintf('%g\n',i)
end 
     end 
mean_vectors_86=zeros(length(v),3);

for i=1:length(mean_vectors)
    ind=find(v(:,1)==v(ia(i),1)& v(:,2)==v(ia(i),2)& v(:,3)==v(ia(i)),3);
    mean_vectors_86(ind,:)=repmat(mean_vectors(i,:),length(ind),1);
    if mod(i,10000)==0
        fprintf('%g\n',i)
    end 
       
   end 

write_vtk_Surface('points1340.vtk',v,f,nvec,mean_vectors_86);
%% Question 2 
% Part 1
keV=[15.4; 16.7; 18.6; 19.8; 22.7; 26.6; 29.5];
T=[-40; -20; 0; 20; 25; 40; 60];
fitresult = fit(T, keV,'poly3');
figure;
subplot(1,2,1);
plot(fitresult,T', keV');
display(fitresult);

% Part 3
A =[1,-40; 1,-20; 1,0; 1,20; 1,25; 1,40; 1,60];
b=[15.4; 16.7; 18.6; 19.8; 22.7; 26.6; 29.5];
t = (linspace(-35, 65, 110))';
x=A\b;
subplot(1,2,2);
scatter(A(:,2),b);
hold on;
plot(t,x(1)+x(2)*t);
display(x);
ylim([15,30]);
xlim([-35,65]);
