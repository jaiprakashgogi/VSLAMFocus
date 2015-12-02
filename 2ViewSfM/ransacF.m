function [ F ] = ransacF( pts1, pts2, M,numItr )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

thr_error=10;
numPointPair=size(pts1,1);
thr_numInlier=numPointPair/4;
bestError=30;
for i=1:numItr
    pointPairIdx=randi(numPointPair,7,1);
    sevenPts1=pts1(pointPairIdx,:);
    sevenPts2=pts2(pointPairIdx,:);
    fittedF=sevenpoint(sevenPts1,sevenPts2,M);
    for j=1:size(fittedF,1)
        F1=fittedF{j};
        avg_error=0;
        numInlier=0;
        for n=1:numPointPair
            epiLine1=F1*[pts2(n,:),1]';
            epiLine2=F1'*[pts1(n,:),1]';
            error1=abs([pts1(n,:),1]*epiLine1)/sqrt(epiLine1(1,1)^2+epiLine1(2,1)^2);
            error2=abs([pts2(n,:),1]*epiLine2)/sqrt(epiLine2(1,1)^2+epiLine2(2,1)^2);
            error=error1+error2;
            if error<thr_error
                avg_error=(avg_error*numInlier+error)/(numInlier+1);
                numInlier=numInlier+1;
            end
        end
        if numInlier>thr_numInlier && avg_error<bestError
            F=F1;
            bestError=avg_error;
        end
    end
end
             
end

