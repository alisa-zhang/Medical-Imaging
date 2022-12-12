% Alisa Zhang Assignment 2.2 (worked with Keegan and Laila)

%Question 1a: DICOM to VTK
series=dir("pigdicom/*.dcm");
for i=1:length(series)
    slice=series(i,1,1);
    path=strcat("pigdicom/",slice.name);
    info=dicominfo(path);
    image(:,:,i)=dicomread(info);
end
spacing=[info.MagneticFieldStrength, info.MagneticFieldStrength, info.SpacingBetweenSlices];
write_vtk_Volume(image,spacing,'pigDicomVolume.vtk');

%Question 1c: STL to VTK
[v, f, n, c, stltitle]=stlread('pigLVcontour.stl',1);
[unique_v, ia, ic]=unique(v,'rows');
mean_vectors=zeros(length(unique_v),3);
nvec=zeros(length(f),1);
for i=length(f)
    p1=v(f(i,2),:);
    p2=v(f(i,2),:);
    p3=v(f(i,2),:);
    nvec(i,1:3)=computeNormals(p1,p2,p3);
end
for i=1:length(mean_vectors)
    ind=find(v(:,1)==v(ia(i),1)& v(:,2)==v(ia(i),2)& v(:,3)==v(ia(i)),3);
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

write_vtk_Surface("LVnormals.vtk",v,f,nvec,mean_vectors_86);


