function isOnSegment = isPointOnSegment(A, B, P, tol)
% 判断点P是否在线段AB上
% 输入：
%   A, B: 线段的两个端点，格式为 [x, y]
%   P: 待检测点，格式为 [x, y]
%   tol: 容差值（可选，默认为 1e-10）
% 输出：
%   isOnSegment: true/false

    if nargin < 4
        tol = 1e-10; % 默认容差值（用于处理浮点误差）
    end

    % 判断是否共线：叉积接近0
    cross_product = (B(1)-A(1))*(P(2)-A(2)) - (B(2)-A(2))*(P(1)-A(1));
    if abs(cross_product) > tol
        isOnSegment = false;
        return;
    end

    % 判断是否在端点范围内
    min_x = min(A(1), B(1));
    max_x = max(A(1), B(1));
    min_y = min(A(2), B(2));
    max_y = max(A(2), B(2));

    isOnSegment = (P(1) >= min_x - tol) && (P(1) <= max_x + tol) && ...
                  (P(2) >= min_y - tol) && (P(2) <= max_y + tol);
end