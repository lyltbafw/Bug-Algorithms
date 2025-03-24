function foot = point_to_segment_projection(P, A, B)
% 计算点P到线段AB的垂足坐标
% 输入参数：
%   P: 目标点坐标 [x,y]
%   A: 线段端点1 [x1,y1]
%   B: 线段端点2 [x2,y2]
% 输出：
%   foot: 垂足坐标 [x,y]

% 计算向量AB和AP
vector_AB = B - A;
vector_AP = P - A;

% 计算线段长度的平方
len_sq_AB = sum(vector_AB.^2);

% 处理线段退化为点的情况
if len_sq_AB < eps
    foot = A;
    return;
end

% 计算投影参数t
t = sum(vector_AP .* vector_AB) / len_sq_AB;

% 约束t在[0,1]范围内
t = max(0, min(1, t));

% 计算垂足坐标
foot = A + t * vector_AB;
end