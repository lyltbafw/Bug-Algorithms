function coordinates = generate_rotated_coordinates(center, start_pos, angle_step_deg)
    angleRad = deg2rad(angle_step_deg);  %将角度从度转换为弧度  
    T=zeros(2,2);                  %平面内的坐标旋转矩阵
    T(1,1)=cos(angleRad);
    T(1,2)=sin(angleRad);
    T(2,1)=-sin(angleRad);
    T(2,2)=cos(angleRad);
    pos = start_pos-center;
    pos = [pos(1);pos(2)];
    pos = T*pos;
    pos = [pos(1), pos(2)];
    coordinates = pos + center;


end