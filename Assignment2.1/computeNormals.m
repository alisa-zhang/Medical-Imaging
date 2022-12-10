function [normal] = computeNormals(p1,p2,p3)
v1 = p1-p2;
v2 = p3-p2;
normal = cross(v1,v2);
end