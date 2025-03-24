function[next] = next_cal(k, now, step_size)
    next(1) = now(1) + sqrt(power(step_size,2)/(power(k,2) + 1));
    next(2) = now(2) + k * sqrt(power(step_size,2)/(power(k,2) + 1));
end