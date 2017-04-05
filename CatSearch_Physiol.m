%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _________         __                                     .__     
% \_   ___ \_____ _/  |_  ______ ____ _____ _______   ____ |  |__  
% /    \  \/\__  \\   __\/  ___// __ \\__  \\_  __ \_/ ___\|  |  \ 
% \     \____/ __ \|  |  \___ \\  ___/ / __ \|  | \/\  \___|   Y  \
%  \______  (____  /__| /____  >\___  >____  /__|    \___  >___|  /
%         \/     \/          \/     \/     \/            \/     \/ 
% __________.__                 .__       .__                      
% \______   \  |__ ___.__. _____|__| ____ |  |                     
%  |     ___/  |  <   |  |/  ___/  |/  _ \|  |                     
%  |    |   |   Y  \___  |\___ \|  (  <_> )  |__                   
%  |____|   |___|  / ____/____  >__|\____/|____/                   
%                \/\/         \/                              
%                                                       
%                                                                                                                                                
%   .timing script for categorical_search_training, a MonkeyLogic task 
%   1) a category specific fixation point (blue:butterfly red:bear) appears
%   for wait_for_fix msec
%   2) subjects holds fixation for initial_fix msec
%   3) on some trials a target is presented: the target (e.g. TBear) is 
%   presented in an array with a lure from the other category (e.g. BFly) 
%   and a set number of distractors (optional). the subject has 
%   max_reaction_time msec to complete a saccade to the target. 
%   4) the subject then holds fixation on the target for hold_target_time
%   msec to recieve a reward
%   5) on other trials, there is no target present, only the lure & 
%   distractors. in this case, the subject has max_reaction_time to fixate 
%   on the TA_button in the periphery and hold for hold_target_time to 
%   recieve a reward.
%
%
% 
% %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _   _           _                             _       _    
% | | (_)         (_)                           (_)     | |   
% | |_ _ _ __ ___  _ _ __   __ _   ___  ___ _ __ _ _ __ | |_  
% | __| | '_ ` _ \| | '_ \ / _` | / __|/ __| '__| | '_ \| __| 
% | |_| | | | | | | | | | | (_| | \__ \ (__| |  | | |_) | |_  
%  \__|_|_| |_| |_|_|_| |_|\__, | |___/\___|_|  |_| .__/ \__| 
%                           __/ |                 | |         
%                          |___/                  |_|        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
%%                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%editables. these can be changed dynamically in ML task menu ( press 'v')
editable('fix_window');
editable('target_window');
editable('wait_for_fix');        
editable('initial_fix'); 
editable('min_delay_fix');
editable('max_reaction_time');      
editable('hold_target_time');
editable('intTint');
editable('reward');
editable('num_reward');
editable('pause_reward');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Send Start Experiment Stobes
trialcodenum = TrialRecord.LastTrialCodes.CodeNumbers; %get the eventmarkers that were sent in the previous trial
if isempty( trialcodenum ); %if there weren't any eventmarkers this must be the 1st trial
    disp( 'start experiment' )
    eventmarker( 5555 );
    formatOut = 31; 
    DateStr = datestr(now,formatOut);
    disp( DateStr )
    bhv_variable('DateStr',DateStr);
    DateStrSplit = regexp(DateStr, '[- :]', 'split');
    yyyyStrobe = str2double( DateStrSplit{1} );
    mmddStrobe = str2double( [ DateStrSplit{2} DateStrSplit{3} ] );
    hhmmStrobe = str2double( [ DateStrSplit{4} DateStrSplit{5} ] );
    mmssStrobe = str2double( [ DateStrSplit{5} DateStrSplit{6} ] );
    eventmarker( [ yyyyStrobe mmddStrobe hhmmStrobe mmssStrobe ] );
%elseif ~isempty( trialcodenum );
   %happyStr = '??(???)???(???)???(???)??';
   %disp( happyStr );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% task variables
% % % give names to the TaskObjects defined in the conditions file:
% the numbers correspond with the TaskObject# in the text files
bzz = 1;
bzz2 = 2;
fixation_point = 3;     %red square target. 
TAbutton = 4;
hold_image = 5;
target_image = 5; 
distract1 = 6; distract2 = 7; distract3 = 8; distract4 = 9; distract5 = 10; distract6 = 11; distract7 = 12; distract8 = 13; distract9 = 14; distract10 = 15; distract11 = 16; 
targetobject_array = [fixation_point hold_image target_image TAbutton distract1 distract2 distract3 distract4 distract5...
    distract6 distract7 distract8 distract9 distract10 distract11];

% stimulus_array length is contingent on the how many distractors, so:
num_TaskObjects = length( TrialRecord.CurrentConditionStimulusInfo );
stim_array = targetobject_array( 2:(num_TaskObjects-1)); 
distractor_array = targetobject_array( 5:end );
%trialSpecificTargetObject_array = targetobject_array( 1:(num_TaskObjects-3 ));

% define time intervals (in ms) these are all editable:
wait_for_fix = 1500;         %interval to wait for fixation to start
initial_fix = 500;          %hold fixation on fixation_point
min_delay_fix = 0;            %hold fixation on fixation point while target is toggled on (msec)
delay_fix_increment = 50;       %ms to randomly add in random increasing multiple (up to 4) to min_delay_fix    
max_reaction_time = 2000;    %max time after fixation given to complete a saccade
hold_target_time = 500;     %hold fixation on bear_image to get rewardTAbutton_time = 100;      %if no bear target is present, this is the interval of time the subject must hold fixation for reward
intTint = 100;               %idle time inbetween conditions, useful to have a pause so that manual reward can be given during training.

% fixation window (in degrees):
fix_window = 4;
target_window = 5;

reward = 400;
num_reward = 3;
pause_reward = 75;
hotkey('g', 'goodmonkey(400, ''NumReward'', 2,''PauseTime'', 50);' );


%flag in case the Target Absent Button is the target of a saccade for a
%Target present trial
TAbutton_flag = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('______________________________________________________________________')
disp('START TRIAL')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
eventmarker(1);
%%


% initial fixation:
toggleobject(fixation_point, 'eventmarker', 2, 'status', 'on' ); %toggle fixation_point on
ontarget = eyejoytrack('acquirefix', fixation_point, fix_window, wait_for_fix);
if ~ontarget,                   %make sure fixation during wait_for_fixation
    eventmarker(5);    
    trialerror(4); % no fixation
    toggleobject(fixation_point, 'eventmarker', 4, 'status', 'off' ); %toggle fixation_point off
    eventmarker(100);
    disp('did not fixate')
    return
end

ontarget = eyejoytrack('holdfix', fixation_point, fix_window, initial_fix);
if ~ontarget,
    eventmarker(7);
    trialerror(3); % broke fixation
    toggleobject(fixation_point, 'eventmarker', 4, 'status', 'off' ); % toggle fixation_point off
    eventmarker(100);
    disp('did not fixate long enough')
    return
end

eventmarker(6);
disp('fixated')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% delay period

if min_delay_fix ~= 0
    [delay_fixation, framenumber] = trialtime;
    %get delay_fixation to use a few sections
    %down to find the length of the aisample
    %length to use to analyze for fixations
    
    eventmarker(41)                 %delay period starts
    toggleobject([ stim_array ],...
        'eventmarker', 21, 'status', 'on');
    %displays target (fixation point stays on)
    ontarget = eyejoytrack('acquirefix', fixation_point, fix_window, 10);
    %eyejoytrack will not take '0' as an value
    %for the 'duration' parameter. so here i
    %use a super short (10ms) duration just to
    %check that fixation is still within
    %fixation_point window. in ML it's good to
    %aquirefix before you holdfix.
    if ~ontarget,                   %@fixation?
        eventmarker(43);            %delay period not aquired
        trialerror(4);              %not holding delay fixation
        toggleobject([fixation_point stim_array], 'eventmarker', 22, 'status', 'off');
        %toggle fixation_point & target off
        return
    end
    eventmarker(44);                %delay fixation acquired
    
    
    random_delay_fix = min_delay_fix + delay_fix_increment*(unidrnd(4)-1);
    %randomize the length of the delay period
    %in increments of 50msec > delay_fix
    ontarget = eyejoytrack('holdfix', fixation_point, fix_window, random_delay_fix);
    if ~ontarget,                   %stayed @fixation for delay_fix?
        eventmarker(45);            %delay period break
        trialerror(3);              %broke delay fixation
        toggleobject([fixation_point stim_array], 'eventmarker', 22, 'status', 'off');
        %toggle fixation_point & targetoff
        return
    end
    
    toggleobject([fixation_point],...
        'eventmarker', 4, 'status', 'off'); %turn off fixation
    
else
    toggleobject([fixation_point],...
        'eventmarker', 4, 'status', 'off'); %turn off fixation
    toggleobject([ stim_array ],...
        'eventmarker', 21, 'status', 'on'); 
end

[ arrayon_time, arrayon_frame ] = trialtime;
array_time = arrayon_time;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image presentation and response
targetcon= str2num(TrialRecord.CurrentConditionInfo.ifTarget);  %get condition info: does this trial present a target(1) or not(0)?
break_flag = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% bear_image present
if targetcon == 1
    disp('there is a target')   
    
    while array_time < ( arrayon_time + max_reaction_time )
        [ array_time, arrayon_frame ] = trialtime;
         % turns on fix2 point and displays target array
        ontarget = eyejoytrack('holdfix', fixation_point, fix_window, max_reaction_time);
        if ontarget, % max_reaction_time has elapsed and is still on fix spot
            eventmarker(17);
            trialerror(1); % no response
            toggleobject([stim_array], ...
                'eventmarker', 22, 'status', 'off'); % toggle target array off
            toggleobject(bzz2, 'eventmarker', 96);
            eventmarker(100);
            disp('did not leave fixation/react in time')
            return
        end
        
        [ontarget rt] = eyejoytrack('acquirefix', [ target_image ], target_window, max_reaction_time);
        if ~ontarget,
            eventmarker(15);
            trialerror(6); % did not land on bear_image
            toggleobject([stim_array],...
                'eventmarker', 22, 'status', 'off');
            eventmarker(100);
            toggleobject(bzz2, 'eventmarker', 96);
            disp('did not land on the target in time')
            return
        end
        
        % hold target then reward
        ontarget = eyejoytrack('holdfix', hold_image, target_window, hold_target_time);
        if ~ontarget && array_time >= ( arrayon_time + max_reaction_time - hold_target_time),
            eventmarker(16);
            trialerror(3); % broke fixation on target
            toggleobject([stim_array],...
                'eventmarker', 22, 'status', 'off');
            toggleobject(bzz2, 'eventmarker', 96);
            eventmarker(100);
            disp('did not hold target long enough')
            return 
        elseif ontarget
            eventmarker(14); %correct
            trialerror(0); % correct
            toggleobject(bzz, 'eventmarker', 96);
            goodmonkey(reward, 'NumReward', num_reward, 'PauseTime', pause_reward);
            [ endtime, endframe ] = trialtime;
            disp(['GOOD MONKEY....trialtime = ' num2str(endtime)])
            break_flag = 1;
            break
        end
        
        if break_flag == 1
            break
        end
       
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%no bear_image present
elseif targetcon == 0
    disp('there is no target')
    while array_time < ( arrayon_time + max_reaction_time )
        [ array_time, arrayon_frame ] = trialtime;
        
        [ ontarget rt ] = eyejoytrack('acquirefix', TAbutton, target_window, max_reaction_time);
        if ~ontarget, 
            eventmarker(15);
            trialerror(1); % did not land on bear_image
            toggleobject([stim_array],...
                'eventmarker', 22, 'status', 'off');
            toggleobject(bzz2, 'eventmarker', 96);
            eventmarker(100);
            return
        end
        
        % hold target then reward
        ontarget = eyejoytrack('holdfix', TAbutton, target_window, hold_target_time);
        if ~ontarget && array_time >= ( arrayon_time + max_reaction_time - hold_target_time ),
            eventmarker(16);
            trialerror(3); % broke fixation
            toggleobject([stim_array],...
                'eventmarker', 22, 'status', 'off');
            toggleobject(bzz2, 'eventmarker', 96);
            eventmarker(100);
            disp('did not retrun to fixation long enough')
            return
        elseif ontarget
            eventmarker(14); %correct
            trialerror(0); % correct
            toggleobject(bzz, 'eventmarker', 96);
            goodmonkey(reward, 'NumReward', num_reward, 'PauseTime', pause_reward);
            [ endtime, endframe ] = trialtime;
            disp(['GOOD MONKEY....trialtime = ' num2str(endtime)])
            break_flag = 1;
            break
        end
        
        if break_flag == 1
            break
        end
        
    end
    
end
    
toggleobject([stim_array],...
    'eventmarker', 22, 'status', 'off'); %turn off bear_image
eventmarker(100);
[ endtime, endframe ] = trialtime;
disp( ['END TRIAL @ t =' num2str(endtime)] )
idle(intTint);

