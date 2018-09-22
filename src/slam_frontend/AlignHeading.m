function [ out ] = AlignHeading( heading, degree )

for i=1:length(heading)
    out(i,1) = heading(i) + degree;
    if out(i,1) < -180
        out(i,1) = out(i) + 360;
    elseif out(i,1) > 180
        out(i,1) = out(i) - 360;
    end
end

end

