function [ out ] = LinearSwitchFunc( x )

alpha = 1;

if x < 0
    out = 0;
elseif x > 1
    out = 1;
else
    out = 1/alpha*x;
end

end

