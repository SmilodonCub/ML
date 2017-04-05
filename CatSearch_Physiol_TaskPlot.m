function [ ] = CatSearch_Physiol_TaskPlot( TrialRecord )
%CatSearch_Physiol_TaskPlot this function is to be used with the
%CatSearch_Physiol to display a polarplot of the previous ttrials target 
%array. This plot appears where the Reaction Time histograms would notmally
%be displayed. This plot also displays text to indicate where the Response 
%Field (RF), target (T), distractors (D), & most/least lure distractor (ML) 
%positions are withion the array. This is to enable the user to visually
%evaluate a trial within the MonkeyLogic control screen.

cla;
try
    ArrayOriginrad= str2num(TrialRecord.CurrentConditionInfo.ArOr);
    targetcon= str2num(TrialRecord.CurrentConditionInfo.ifTarget);
    Mostcon= str2num(TrialRecord.CurrentConditionInfo.MOSTTarget);
    numArrayImages = 5;
    imageXY = zeros( [ numArrayImages,4 ] );
    for i = 1 : numArrayImages
        imageXY( i,1 ) = TrialRecord.CurrentConditionStimulusInfo{ 8-numArrayImages + i }.XPos;
        imageXY( i,2 ) = TrialRecord.CurrentConditionStimulusInfo{ 8-numArrayImages + i }.YPos;
    end
    imageXY( :,3 ) = atan2( imageXY( :,2 ), imageXY( :,1 ) );
    imageXY( :,4 ) = round( hypot( imageXY( :,1 ),imageXY( :,2 ) ) );
    %ArrayPosInfo = ArrayOriginrad : ( pi/2 ) : ( ArrayOriginrad+2*pi );
    ArrayPosPlot = polarplot( imageXY( :,3 ), imageXY( :,4 ) );
    hold on
    rlim( [ 0 20 ] )
    ArrayPosPlot.Color = [ 0.8 1 0.8 ];
    ArrayPosPlot.Marker = 'o';
    ArrayPosPlot.MarkerSize = 20;
    ArrayPosPlot.LineStyle = 'none';
    ArrayPosPlot.LineWidth = 4;
    ArrayPosPlot.MarkerFaceColor = [ 0.95 1 0.95 ];
    if targetcon
        TargetPosPlot = polarplot( imageXY( 2,3 ), imageXY( 2,4 ) );
        TargetPosPlot.Color = [ 1 0.8 0.8 ];
        TargetPosPlot.Marker = 'd';
        TargetPosPlot.MarkerSize = 15;
        TargetPosPlot.LineStyle = 'none';
        TargetPosPlot.LineWidth = 4;
    end
    MostPosPlot = polarplot( imageXY( 3,3 ), imageXY( 3,4 ) );
    MostPosPlot.Color = [ 0.8 0.8 1 ];
    MostPosPlot.Marker = 's';
    MostPosPlot.MarkerSize = 15;
    MostPosPlot.LineStyle = 'none';
    MostPosPlot.LineWidth = 4;
    text( ArrayOriginrad, imageXY( end,4 )-5, 'RF', 'FontSize', 12  )
    ArrayLabels = { 'TAB', 'T','ML','D','D' };
    for i = 1:numArrayImages
        labelText = ArrayLabels{ i };
        text( imageXY( i,3 ), imageXY( i,4 ), labelText , 'FontSize', 9  )
    end
catch ME
    disp( ME.identifier )
end


end


