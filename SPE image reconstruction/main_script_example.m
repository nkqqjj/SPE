%% ------------------------------- 
    %target: birefringent phantom; 
    %SPE running mode: retardance mode
    
    path='./exampleData';
    path2write = './reconstructedImg';
    f_1 = 6421;%frame of interest
    f_2 = 6421;
    mode='ret';
    filename_prefix = 'ret';
    sample_name = 'no_drop';
    
    range_ret_dep = [0 1];
    radius = 580;
    centre_coord = [765,520];%Y & X coordinate 
    gamma_value = 2;% 1 = no gamma correction.
    sharpenning_parameters = [3.5,2];%radius value, amount value
    threshold_highlight = 240;
    threshold_underexposed = 7;
    mask_badAreas_ornot = 1; % 0 is no, 1 is yes
    run('subscript_hand.m');
    
    
    clear ROI_database
    ROI_database(1,:) = [300, 515, 40, 40]; % M letter left
    ROI_database(2,:) = [375, 515, 40, 40]; % M letter middle
    ROI_database(3,:) = [500, 515, 40, 40]; % M letter right
    ROI_database(4,:) = [622, 515, 40, 40]; % medium left
    ROI_database(5,:) = [692, 515, 40, 40]; % medium right
    run('subscript_phantom_roiAnalysis.m'); 

%% ------------------------------- 
    %target: paper; 
    %SPE running mode: retardance mode
    
    path='./exampleData';
    path2write = './reconstructedImg';
    f_1 = 59;%frame NO.
    f_2 = 59;
    mode='ret';
    filename_prefix = 'ret';
    sample_name = 'paper';
    
    range_ret_dep = [0 1];
    radius = 580;
    centre_coord = [765,520];%Y & X coordinate 
    gamma_value = 2;% 1 = no gamma correction.
    sharpenning_parameters = [3.5,2];%radius value, amount value
    threshold_highlight = 240;
    threshold_underexposed = 7;
    mask_badAreas_ornot = 1; % 0 is no, 1 is yes
    run('subscript_hand.m');
    
%% ------------------------------- 
    %target: paper; 
    %SPE running mode: depolarization mode
    
    path='./exampleData';
    path2write = './reconstructedImg';
    f_1 = 92;%frame of interest
    f_2 = 92;
    mode='dep';
    filename_prefix = 'dep';% this could be ret, dep, Dep, Ret or nil,
    sample_name = 'paper';% to save imgs
    
    range_ret_dep = [0 0.5];
    radius = 580;
    centre_coord = [765,520];%Y & X coordinate 
    gamma_value = 2;% 1 = no gamma correction.
    sharpenning_parameters = [3.5,2];%radius value, amount value
    gamma_value_dep = 1.;
    threshold_highlight = 240;
    threshold_underexposed = 7;
    mask_badAreas_ornot = 1; % 0 is no, 1 is yes
    run('subscript_hand.m');
    