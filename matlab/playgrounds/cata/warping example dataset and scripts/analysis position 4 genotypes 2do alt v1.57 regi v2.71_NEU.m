
%% ------------------------------------------------------------------------
%    Step 1.1: Initialize
% ------------------------------------------------------------------------
%% Red to blue colormap
m=[];
n=[];
cr=[];
cg=[];
cb=[];
ja_colormap_redblue = [];
ja_colormap_bluered = [];

m = 101;
n = fix(0.5*m);
cr = [(0:1:n-1)/n,ones(1,n)];
cg = [(0:n-1)/n, (n-1:-1:0)/n];
cb = [ones(1,n),(n-1:-1:0)/n];
ja_colormap_redblue = [cr(:), cg(:), cb(:)];
ja_colormap_bluered = flipud(ja_colormap_redblue);


%%
%load data for development
load ('kym_130330_HD233_Dev_340wms_Annot')
%%
%loaction: \\home.files.med.harvard.edu\home\Lab\Projects\Redox\Data files from Cata\Analysis for paper\WT_2do_FUDR
%location  \\home.files.med.harvard.edu\home\Lab\Projects\Redox\Data files from Cata\Analysis for paper\WT_2do_FUDR\Analysis_130112_16_HD233_WT_2doFUDR
%load variables
annotation=[];
strain_names=[];
exp_cond = [];
annotation_col_names = [];
strain_averages = [];
kym410 = [];
kym470 = [];
n_worms = [];
annotation = [];
strain_annotation =[];

n_strains = 4; % legacy
strain_names = {'HD233', 'HD236', 'HD240', 'HD244'};

% annotation_col_names = {'Date', 'Strain', 'Age','Worm', 'Movement'};
%annotation_col_names = {'StageTL', 'MovementScore', 'PickedAs'};
annotation_col_names = {'Date', 'Worm', 'Hours post L4', 'Time in anesthesia', ...
    'Time in imaging', 'time in levamisole', 'Mode 410', 'Mode 470', 'Movement'};

%experimetal conditions: strain age fudr(1= yes 0=no)
exp_cond = [233 2 1];
strain_annotation_workspace = load('FourGenotypes2doFUDRannotation.mat');

%transfer data from loaded structures to arrays
strain_annotation = strain_annotation_workspace.FourGenot2doFUDRspltRegJA2;

strain_annotation_labels = strain_annotation_workspace.FourGenot2doFUDRspltRegJA2_Labels;
% 1	'Date'
% 2	'Strain'
% 3	'Age'
% 4	'worm 2'
% 5	'Strain_Reg'
% 6	'OxD MedAx - OxD pm3'
% 7	'OxD MedAx - OxD pm4'
% 8	'OxD MedAx - OxD pm5'
% 9	'OxD MedAx - OxD pm7'
% 10	'OxD pm3 - OxD pm7'
% 11	'OxD pm4 - OxDpm7'
% 12	'hours post L4'
% 13	'time in anesthesia'
% 14	'time in imaging'
% 15	'time in lev'
% 16	'Mode 410'
% 17	'Mode 470'
% 18	'Movement'
% 19	'OxD Medial Axis'
% 20	'OxD pm3'
% 21	'OxD pm4'
% 22	'OxD pm5'
% 23	'OxD pm7'
% 24	'E-Eph Medial Axis'
% 25	'E-Eph pm3'
% 26	'E-Eph pm4'
% 27	'E-Eph pm5'
% 28	'E-Eph pm7'
% 29	'Mean 410 Medial Axis'
% 30	'Mean 410 pm3'
% 31	'Mean 410 pm4'
% 32	'Mean 410 pm5'
% 33	'Mean 410 pm7'
% 34	'Mean 470 Medial Axis'
% 35	'Mean 470 pm3'
% 36	'Mean 470 pm4'
% 37	'Mean 470 pm5'
% 38	'Mean 470 pm7'
% 39	'R1000 Medial Axis'
% 40	'R1000 pm3'
% 41	'R1000 pm4'
% 42	'R1000 pm5'
% 43	'R1000 pm7'
% 44	'd37'
% 45	'd35'
% 46	'd57'

strain_averages{1} = load('AvgPerCell_HD233.mat');
strain_averages{2} = load('AvgPerCell_HD236.mat');
strain_averages{3} = load('AvgPerCell_HD240.mat');
strain_averages{4} = load('AvgPerCell_HD244.mat');

strain_kym{1} = load('Kym_HD233.mat');
strain_kym{2} = load('Kym_HD236.mat');
strain_kym{3} = load('Kym_HD240.mat');
strain_kym{4} = load('Kym_HD244.mat');


%kym410, kym470 (position, worm)
for a = 1:n_strains
    kym410 = cat(2,kym410,strain_kym{a}.kym_410);
    kym470 = cat(2,kym470,strain_kym{a}.kym_470);
    n_worms(a) = size(strain_kym{a}.kym_410,2);
end

% find indeces for StageTL
unique_group = [];
%selection_criteria = find(strain_annotation{1}(:,2) <= 1 & strain_annotation{1}(:,1) == 2);
selection_criteria = find(strain_annotation(:,18) <= 1);

%selection_criteria = selection_criteria(randsample(length(selection_criteria),300));%%%%%%%%%%%%%%%%%if low memory


%selection_criteria = find(strain_annotation(:,18) <= 1 & (strain_annotation(:,2) == 233 | strain_annotation(:,2) == 240));
annotation = strain_annotation(selection_criteria,:);
%strain_annotation
%strain_names = {'HD233' 'HD240'};
%
[unique_group,igroup,igroup2data] = unique(annotation(:,2));

sub_subset =[];
group_index=[];
group_index=cell(length(unique_group),1);
for gr = 1:length(unique_group)
    group_index{gr}=find(igroup2data==gr);
     gr_size(gr) = size(group_index{gr},1);
end

%this is for the aging data
%unique_group_nice = {'tlL1','tlL2','tlL3','tlL4','tl1dAdult','tl2dAdult'};
unique_group_nice = strain_names;
counter2unique_group = [1 2 3 4];%[2 4 1 3];[1 3 4 2];[1 2];%

region_labels = {'medial-axis', 'pm7', 'pm4', 'pm5', 'pm3'};
%region_boundaries = [2 95; 5 12; 57 63; 29 48; 73 92];
region_boundaries = [2 95; 5 9; 57 63; 29 48; 73 92];
 plot_color={'k','b','r','m'};
%% ------------------------------------------------------------------------
%    Step 1.2: Calculate R OxD E for each strain_age group
% ------------------------------------------------------------------------

R_region = [];
R_pixbypix = [];
R_all = [];
R = [];
OxD = [];
R_all = [];

R = kym410./kym470;
OxD = ja_oxd(R);
E = ja_E(OxD);
    



%%calculate region means and pixel-by-pixel region means
a = [];
b = [];
c = [];
tR_region = [];
tR_pixbypix = [];


    for b = 1:5
        for a = 1:size(kym410,2)
            tR_region(a,b) = sum(kym410(region_boundaries(b,1):region_boundaries(b,2),a))/ ...
                sum(kym470(region_boundaries(b,1):region_boundaries(b,2),a));
            tR_pixbypix(a,b) = mean(kym410(region_boundaries(b,1):region_boundaries(b,2),a) ./ ...
                kym470(region_boundaries(b,1):region_boundaries(b,2),a));
        end
        %     figure; cdfplot(tR_region(:,b)./tR_pixbypix(:,b))
    end
    R_region =  tR_region;
    R_pixbypix = tR_pixbypix;
    mean(R_region./R_pixbypix)
    std(R_region./R_pixbypix)

%
% again, obviously the lop below is just reusing old code for one strain only
positional_data = [];

positional_data = cat(3,kym410(:,selection_criteria),kym470(:,selection_criteria),R(:,selection_criteria), ...
    OxD(:,selection_criteria),E(:,selection_criteria),...
    E(:,selection_criteria)-(ja_E(ja_oxd(R_region(selection_criteria,1)* ones(1,100))))' ,...
     E(:,selection_criteria)-(ja_E(ja_oxd(R_region(selection_criteria,5)* ones(1,100))))' ,...
      E(:,selection_criteria)-(ja_E(ja_oxd(R_region(selection_criteria,4)* ones(1,100))))',...
   E(:,selection_criteria)-(ja_E(ja_oxd(R_region(selection_criteria,2)* ones(1,100))))' );


data_col_labels ={ 'i410','i470','R','OxD','E (mV)','E-Emedialaxis (mV)','E-Epm3 (mV)','E-Epm5 (mV)','E-Epm7 (mV)'};

%% ------------------------------------------------------------------------
%    Step 1.3: Sort and plot variable each group
% ------------------------------------------------------------------------
cm = cptcmap('CM_cool-warm');
variable_name = {'OxD','E','E-Eref','E-Eref'};
var1=[];
var2=[];


s_worm = 199;
diagnostic_plots = 1;
variable =[];
var_ref = [];
var_sorted = [];

selected_var = 4;
ref_region = 2;
sorting_region_pair=[5 2];

bounds(1,:) = [0.2 0.6];
bounds(2,:) = [-280 -260];%ja_E(bounds(1,:));
bounds(3,:) = [-5 5];
bounds(4,:) = [-5 5];

for c = 1:n_strains
    gr1 = group_index{counter2unique_group(c)};
    switch selected_var
        case 1
            variable{c} = OxD(:,gr1);
            var_ref{c} = ja_oxd(R_region(gr1,ref_region));
            var1 = variable_name{1};
            var2 = strcat(variable_name{1},region_labels{ref_region});
        case 2
            variable{c} = E(:,gr1);
            var_ref{c} = ja_E(ja_oxd(R_region(gr1,ref_region)));
            var1 = variable_name{2};
            var2 = strcat(variable_name{1},region_labels{ref_region});
        case 3
            variable{c} =E(:,gr1)-ones(100,1)*ja_E(ja_oxd(R_region(gr1,ref_region)))';
            var_ref{c} = ja_E(ja_oxd(R_region(gr1,sorting_region_pair(1))))-ja_E(ja_oxd(R_region(gr1,sorting_region_pair(2))));
            var1 = strcat('E-E', region_labels{ref_region});
            var2 = strcat('\DeltaE(', region_labels{sorting_region_pair(1)},'-',region_labels{sorting_region_pair(2)}, ')');
        case 4
            variable{c} = E(:,gr1)-ones(100,1)*ja_E(ja_oxd(R_region(gr1,ref_region)))';
            var_ref{c} = ja_E(ja_oxd(R_region(gr1,ref_region)));
            var1 = strcat('E-E', region_labels{ref_region});
            var2 = strcat(variable_name{2},region_labels{ref_region});
    end
    
    
    [tmp,index] = sort(var_ref{c});
    var_sorted{c} = variable{c}(:,index);
    s_worm_index = find(index == s_worm);
    
    criteria = find(annotation(gr1,18) == 0);
    var_movement_0{c} = variable{c}(:,criteria);
    [tmp,index] = sort(var_ref{c}(criteria));
    var_movement_0_sorted{c} = var_movement_0{c}(:,index);
    
    criteria = find(annotation(gr1,18) == 1);
    var_movement_1{c} = variable{c}(:,criteria);
    [tmp,index] = sort(var_ref{c}(criteria));
    var_movement_1_sorted{c} = var_movement_1{c}(:,index);
    
    criteria = find(annotation(gr1,18) >= 2);
    var_movement_23{c} = variable{c}(:,criteria);
    [tmp,index] = sort(var_ref{c}(criteria));
    var_movement_23_sorted{c} = var_movement_23{c}(:,index);
    
    criteria = find(annotation(gr1,18) <= 1);
    var_movement_01{c} = variable{c}(:,criteria);
    [tmp,index] = sort(var_ref{c}(criteria));
    var_movement_01_sorted{c} = var_movement_01{c}(:,index);
    s_worm_index = find(index == s_worm);
    
    if diagnostic_plots == 1
        
        figure;
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
        hold on
        subplot(4,2,1);
        imagesc(variable{c});
        colorbar; colormap(cm); caxis(bounds(selected_var,:));
        title([strain_names{counter2unique_group(c)} ' ' var1]); ylabel('position'); xlabel('worm');
        grid on;
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        set(gca,'XTick',[]);
        
        
        subplot(4,2,3);
        imagesc(var_sorted{c});
        colorbar; colormap(cm); caxis(bounds(selected_var,:));
        title([strain_names{counter2unique_group(c)} ' ' var1 ' sorted by ' var2]); ylabel('position'); xlabel('worm');
        grid on;
        %set(gca,'YTick',[2.5 10.5 20.5 40.5 52.5 60.5 70.5 90.5]);
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        hold off
        
        subplot(4,2,2);
        imagesc(var_movement_0_sorted{c});
        colorbar; colormap(cm); caxis(bounds(selected_var,:));
        title([strain_names{counter2unique_group(c)} ' ' var1 ' sorted by ' var2 ', movement=0']); ylabel('position'); xlabel('worm');
        grid on;
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        set(gca,'XTick',[]);
        hold off
        
        subplot(4,2,4);
        imagesc(var_movement_1_sorted{c});
        colorbar; colormap(cm); caxis(bounds(selected_var,:));
        title([strain_names{counter2unique_group(c)} ' ' var1 ' sorted by ' var2  ', movement=1']); ylabel('position'); xlabel('worm');
        grid on;
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        set(gca,'XTick',[]);
        hold off
        
        subplot(4,2,6);
        imagesc(var_movement_23_sorted{c});
        colorbar; colormap(cm); caxis(bounds(selected_var,:));
        title([strain_names{counter2unique_group(c)} ' ' var1 ' sorted by ' var2  ', movement>=2']); ylabel('position'); xlabel('worm');
        grid on;
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        set(gca,'XTick',[]);
        hold off
        
        
        subplot(4,2,8);
        imagesc(var_movement_01_sorted{c});
        colorbar; colormap(cm); caxis(bounds(selected_var,:));
        title([strain_names{counter2unique_group(c)} ' ' var1 ' sorted by ' var2  ', movement<=1']); ylabel('position'); xlabel('worm');
        grid on;
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        set(gca,'XTick',[]);
        hold off
    end
    
    
end

if  diagnostic_plots == 1
    %
    figure('Name',[strain_names{counter2unique_group(c)} ' ' var1 ' 2do 2x2 bin , movement 01 sorted by ' region_labels{ref_region}]);
    set(gcf,'Units','Normalized','OuterPosition',[0.2 0.1 0.5 0.9]);
    
    for c = 1:n_strains
        subplot(2,2,c)
        imagesc(var_movement_01_sorted{c});
        colorbar;
        colormap(cm);
        caxis(bounds(selected_var,:));
        axis square
        title([strain_names{counter2unique_group(c)} ' ' var1 ' sorted by ' var2 ', movement<=1']);
        ylabel('position');
        xlabel('worm');
        grid on;
        set(gca,'YTick',[5.5 12.5 29.5 48.5 73.5 92.5],'YTickLabel',{'','','','','',''},'TickLength',[0 0]);
        set(gca,'XTick',s_worm,'YDir','normal'); %'XGrid','off',
        
    end
    %
    %     colorbar('location', 'EastOutside');
    %     cptcmap('CM_cool-warm');
    % cptcmap('CM_green-purple');
    % cptcmap('CM_purple-orange');
    % colormap(flipud(cptcmap('CM_blue-tan')));
    % colormap(flipud(cptcmap('CM_green-purple')));
    % cptcmap('CM_cbcPiYG');
    % colormap(flipud(cptcmap('CM_cbcRdYlBu')));
    % cptcmap('CM_cbcRdBu','flip',true);
    % cptcmap('CM_001-fire');
end
%

%% ------------------------------------------------------------------------
%    Step 2: select a worm subset for  study
% ------------------------------------------------------------------------
% tbaselineends_index = 21;
% % This retuns the index of the first observation that is ~NaN after
% % baseline(tindex1-21) until t=9 min (tindex35)
% % if there are no NaNs then returns 1
% worm_firsttime_idx = (max(isnan(data(tbaselineends_index+1:35,:,1,1)) .* ([tbaselineends_index+1:35]'*ones(1,size(data,2))))+1)';
% tstart_index = 29;% =  max(worm_firsttime_idx);
%
% %select wt 2do for '64wt 2do alone'  experiment
% worm_subset = find(metadata(:,8)==1); %

worm_subset = find(annotation(:,18) <= 1); % this currently works with only one strain, need to keep track of which worm is on which strain

worm_subset=worm_subset([1 2 3 4 260 261 262 465 466 467 690 691 692 693]);

%select observation
observation_subset = 1;%5;%[4 5 6  7 8 9];%[4 5 6];
% region_subset = [2 3 4];

% % find indeces for strain_age
% unique_group = [];
% [unique_group,igroup,igroup2data] = unique(metadata_txt(worm_subset,5));
%
% group_index=[];
% group_index=cell(length(unique_group),1);
% for gr = 1:length(unique_group)
%     group_index{gr}=find(igroup2data==gr);
% end
%
% %this is for the aging data
% unique_group_nice = strrep(unique_group,' do','');
% unique_group_nice = strrep(unique_group_nice,'_',' day ');
% counter2unique_group = [1];%[2 4 1 3];

%settings for various if/then situtations
take_derivative= 0;
diagnostic_plots = 1; %1 = yes 0=no 2= only regression
savefigures = 0;%1 = yes 0=no
export_figures = 0;

% nregions = length(region_subset);
nobs = length(observation_subset);
 ngroups = length(igroup);
%ngroups = 1; %**************temp

%set ntimepoints to trim from the end of each timeseries
timetrim = 0;

% colormaps
cm = cptcmap('CM_cool-warm');
%cm = cptcmap('CM_001-fire');


region_boundaries2 = 101- region_boundaries;
%% ------------------------------------------------------------------------
%    Step 2: Registration using intensity410 data
% ------------------------------------------------------------------------
varprop = [];
harmonics = [];
Rsq_pos_pca_t = [];
harmfd =[];
diagnostic_plots = 4;
scounter = 1;

alpha = 0.95;
num_std = 1.96;

cm = cptcmap('CM_cool-warm');
export_figures = 0;
if export_figures == 1
    close all
end

for timetrim = [0]
    obs_counter = 0;
    
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = 1;%= obs_counter +1;
        %         obs_counter=1;      %for testing
        
        
        %this is the reference positon fd object used to create the positon
        %warping
        take_derivative= 1;
        ref_observation =1;
        ref_data_subset = [];
        ref_data_subset = positional_data(end:-1:1,worm_subset,ref_observation);
        ref_data_subset = squeeze(ref_data_subset);
        nworms = size(ref_data_subset,2);
        
        % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
                timeshift = 0;%-time(1); %this is necessary to avoid negative times
        %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
        %
        position = 1:size(positional_data,1);
        ref_dataset = ref_data_subset;
        
        ref_basis_range = [min(position) max(position)];
        ref_norder = 6;
        ref_bspline_nbreaks = 96;
        
        ref_breaks = linspace(min(position),max(position),ref_bspline_nbreaks);
        ref_nbasis = length(ref_breaks) + ref_norder - 2;
        ref_bspline_obj = create_bspline_basis(ref_basis_range,ref_nbasis,ref_norder,ref_breaks);
        
        % plot bspline object
        if diagnostic_plots == 0
            figure('Name','detail of bspline object')
            plot(ref_bspline_obj)
            xlim(ref_basis_range)
            xlabel(['position + ' num2str(timeshift) ])
        end
        %
        
        % Use a differential operator to smooth data
        ref_Lfd2 = int2Lfd(2);
        ref_lambda2 = 10^(-1.5);
        ref_pos_Par2 = fdPar(ref_bspline_obj,ref_Lfd2,ref_lambda2);
        [ref_pos_fd,df,gcv] = smooth_basis(position,ref_dataset,ref_pos_Par2);
        df,sum(gcv)
        
        %determine wether to transform data to derivative form
        if take_derivative ~= 0
            ref_pos_fd = deriv_fd(ref_pos_fd,take_derivative)
        end
        
         pos = linspace(min(position),max(position),501);
        
        %%  Set up a cubic spline basis for continuous registration
        
        ref_wbasis  = create_bspline_basis(ref_basis_range, ref_bspline_nbreaks, ref_norder);
        ref_Wfd0    = fd(zeros(ref_bspline_nbreaks,nworms),ref_wbasis);%use nworms instead of 5
        ref_lambda  = 1;
        ref_WfdPar  = fdPar(ref_Wfd0, 1, ref_lambda);
        
     
        %%
        %  carry out the registration
%         [pos_fdCR, warpfdCR, WfdCR] = register_fd(mean(ref_pos_fd), ref_pos_fd, ref_WfdPar);%(1:5)
%         save('registration 904 test')

% instead of registering to the global mean, one could register to the mean
% of wild type!!
 %  carry out the registration
       % [pos_fdCR, warpfdCR, WfdCR] = register_fd(mean(ref_pos_fd(group_index{counter2unique_group(1)})), ref_pos_fd, ref_WfdPar);%(1:5)
         [pos_fdCR, warpfdCR, WfdCR] = register_fd(mean(ref_pos_fd([1:14])), ref_pos_fd, ref_WfdPar);%(1:5)
        save('registration using D1 i410 wt as template 904 test_NEU')
        %% this is the position fd we want to aply the position warping to
        take_derivative=0;
        data_subset = [];
        data_subset = positional_data(end:-1:1,worm_subset,1); %select data 1=i410 2=i470 3=R 4=OxD 5=E 6=E-Ema
        data_subset = squeeze(data_subset);
        nworms = size(data_subset,2);
        
        % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
        
        timeshift = 0;%-time(1); %this is necessary to avoid negative times
        %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
        %
        position = 1:size(positional_data,1);
        dataset = data_subset;
        
        basis_range = [min(position) max(position)];
        norder = 6;
        bspline_nbreaks = 96;
        
        breaks = linspace(min(position),max(position),bspline_nbreaks);
        nbasis = length(breaks) + norder - 2;
        bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);
        
        % plot bspline object
        if diagnostic_plots == 0
            figure('Name','detail of bspline object')
            plot(bspline_obj)
            xlim(basis_range)
            xlabel(['position + ' num2str(timeshift) ])
        end
        %
        
        % Use a differential operator to smooth data
        Lfd2 = int2Lfd(2);
        lambda2 = 10^(-0.3);
        pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
        [pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
        df,sum(gcv);
        
        %determine wether to transform data to derivative form
        if take_derivative ~= 0
            pos_fd = deriv_fd(pos_fd,take_derivative)
        end
        
        
        %%
        %pos_matCR = eval_fd(pos, pos_fdCR);
        if diagnostic_plots == 4
            figure('Name',['warpfdCR']);
            set(gcf,'Units','Normalized','OuterPosition',[0.2 0.2 0.6 0.6]);
            plot(warpfdCR)
            set(gca,'TickDir','Out','Fontsize',10);
            axis square
            xlabel(['position-UR along pharynx' ])
            ylabel(['position-CR along pharynx' ])
        end
             %%
        if diagnostic_plots == 4
            figure('Name',['individual traces CR vs UR']);
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
              hold on
              for i=1:14;% 902:nworms;1:nworms;%465
                  i
                  subplot(2,2,1)
                  
                  plot(pos, eval_fd(pos,ref_pos_fd(i)),'-b')
                  hold on
                  plot(pos, eval_fd(pos,mean(ref_pos_fd)),'-b','linewidth',2)
                  plot(pos, eval_fd(pos,pos_fdCR(i)),'-r')
                  plot(pos, eval_fd(pos,mean(pos_fdCR)),'-r','linewidth',2)
                  set(gca,'TickDir','Out','Fontsize',10);
                  axis square
                  hold off
                  xlabel(['position along pharynx' ])
                  ylabel([data_col_labels{ref_observation}])
                  ylim([-2000 2000])
                  y1 = get(gca,'YLim'); 
                  for rr = 2:size(region_boundaries2,1);
                      line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                      line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                  end
                  title(['worm ' num2str(i) ])
                  legend('UR','mean UR', 'CR', 'mean CR','location','Eastoutside')
                  
                subplot(2,2,3)
                  wposi = eval_fd(pos,warpfdCR(i));
                  wposi(wposi<1)=1;
                  wposi(wposi>100)=100;
                  wposm = eval_fd(pos,mean(warpfdCR));
                   wposm(wposm<1)=1;
                  wposm(wposm>100)=100; 
                  
                  plot(pos, eval_fd(pos,pos_fd(i)),'-b')
                  hold on
                  plot(pos, eval_fd(pos,mean(pos_fd)),'-b','linewidth',2)
                  
                  plot(pos, eval_fd(wposi,pos_fd(i)),'-r')
                  
                  plot(pos, eval_fd(wposm,mean(pos_fd)),'-r','linewidth',2)
%                   plot(pos, eval_fd(pos,pos_fdCR(i)),'-r')
%                   plot(pos, eval_fd(pos,mean(pos_fdCR)),'-r','linewidth',2)
                  set(gca,'TickDir','Out','Fontsize',10);
                  axis square
                  hold off
                  xlabel(['position along pharynx' ])
                  ylabel([data_col_labels{ref_observation}])
                  xlim([0 100])
                  y1 = get(gca,'YLim');
                  for rr = 2:size(region_boundaries2,1);
                      line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                      line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                  end
                  title(['worm ' num2str(i) ])
                  legend('UR','mean UR', 'CR', 'mean CR','location','Eastoutside')
                  
                  
                  subplot(2,2,2)
                  
                  %phdl = plot(warpfdCR(i))
                  plot(pos,eval_fd(pos,warpfdCR(i)))
                  set(gca,'TickDir','Out','Fontsize',10);
                  axis square
                  
                  xlabel(['UR position along pharynx' ])
                  ylabel(['CR position along pharynx' ])
                  title(['worm ' num2str(i) ])
                  xlim([min(pos), max(pos)])
                  ylim([min(pos), max(pos)])
                  y1 = get(gca,'YLim');
                  for rr = 2:size(region_boundaries2,1);
                      line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                      line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                  end
                  pause
              end
              hold off
        end
        
        
        %%
        %
        plot_style={'-k','-b','-r','-k','-b','-r','-k','-b','-r'};
       
%         color_list = cptcmap('GMT_wysiwyg','ncol',ngroups);
        color_list = cptcmap('CM_Paired_08','ncol',ngroups,'flip',false);%ngroups
        %yaxis_limits = [0.2 0.8; -280 -250;-2.5 12.5];
        %yaxis_limits = [0.2 0.8; -280 -250;-5 20];
        %         yaxis_limits = [0.2 0.8; -277.5 -257.5;-2.5 20];
        %         yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -8 8];
        yaxis_limits = [0.3 0.5; -275 -265; -3 3; -1 5; -3 3; -5 1];
        
        
        
        %plot fd
        if diagnostic_plots == 4
            legend_names= [];
            figure('Name',['Mean Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
            
           subplot(1,2,1)
            for gr = 1:ngroups
                hold on
                gr1 = group_index{counter2unique_group(gr)};
                plot(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),'Color', color_list(gr,:),'linewidth',2);
                legend_names{gr} = unique_group_nice{counter2unique_group(gr)};
            end
            legend(legend_names,'location','NorthWest');
            
            subplot(1,2,2)
            for gr = 1:ngroups
                hold on
                gr1 = group_index{counter2unique_group(gr)};
                eval_posCR=[];
                for worm=1:length(gr1);
                  %eval_posCR(:,worm)= eval_fd(pos-timeshift,warpfdCR(gr1(worm)));
                  wposi=[];
                  wposi=eval_fd(pos-timeshift,warpfdCR(gr1(worm)));
                  wposi(wposi<1)=1;
                  wposi(wposi>100)=100;
                    eval_posCR(:,worm)= eval_fd(wposi,pos_fd(gr1(worm))) ;
                end
                plot(pos-timeshift,mean(eval_posCR,2)','Color', color_list(gr,:),'linewidth',2);
                %legend_names{gr} = unique_group_nice{counter2unique_group(gr)};
            end
            legend(legend_names,'location','NorthWest');
            
%             for gr = 1:ngroups
%                 gr1 = group_index{counter2unique_group(gr)};
%                 % errorbar(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),num_std.*std(eval_fd(pos,pos_fd(gr1)),0,2)./sqrt(gr_size(counter2unique_group(gr))),...
%                 %     'Color', color_list(gr,:),'linewidth',0.25);
%                 
%                 [hl,hp] = boundedline(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2), num_std.*std(eval_fd(pos,pos_fd(gr1)),0,2)./sqrt(gr_size(gr)),...
%                     'alpha','cmap',color_list(gr,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1) ./sqrt(length(worm_subset))
%                 %outlinebounds(hl,hp);
%             end
            
            for s=1:2
                subplot(1,2,s)
                 axis square
                 set(gca,'TickDir','Out','Fontsize',10);
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel(['mean +/- ' num2str(num_std) ' s.e.m. ' data_col_labels{observation_subset(obs_counter)}])
                title([' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)])
                
                
                y1 = get(gca,'YLim');
                for rr = 2:size(region_boundaries2,1);
                    line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                    line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                end
            end
            hold off
        end
        
        color_list = cptcmap('CM_Paired_08','ncol',ngroups*2,'flip',false);%ngroups
        if diagnostic_plots == 4
            legend_names= [];
            figure('Name',['Mean Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0.2 0 0.5 1]);
            
            axis square
            for gr = 1:ngroups
                subplot(2,2,gr)
                set(gca,'TickDir','Out','Fontsize',10);
                hold on
                gr1 = group_index{counter2unique_group(gr)};
                plot(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),'Color', color_list(gr*2,:),'linewidth',2);
                eval_posCR=[];
                for worm=1:length(gr1);
                    wposi=[];
                    wposi=eval_fd(pos-timeshift,warpfdCR(gr1(worm)));
                    wposi(wposi<1)=1;
                    wposi(wposi>100)=100;
                    %eval_posCR(:,worm)= eval_fd(pos-timeshift,warpfdCR(gr1(worm)));
                    eval_posCR(:,worm)= eval_fd(wposi,pos_fd(gr1(worm))) ;
                end
                plot(pos-timeshift,mean(eval_posCR,2)','Color', color_list(gr*2-1,:),'linewidth',2);
                %legend_names{gr} = unique_group_nice{counter2unique_group(gr)};
            end

            for gr= 1:ngroups
                subplot(2,2,gr)
                legend('UR','CR','location','NorthWest');
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    %ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel(['mean ' data_col_labels{observation_subset(obs_counter)} ' +/- ' num2str(num_std) ' s.e.m. ' data_col_labels{observation_subset(obs_counter)}])
                title([unique_group_nice{counter2unique_group(gr)} ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2,2) ' Deriv=' num2str(take_derivative) ' timetrim=' num2str(timetrim)])
                y1 = get(gca,'YLim');
                for rr = 2:size(region_boundaries2,1);
                    line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                    line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                end
            end
            hold off
        end
        
        if diagnostic_plots == 4
            figure('Name',['Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
            
            yaxis_limits = [0.1 0.8; -280 -230; -15 15];
            yaxis_limits = [0.1 0.8; -280 -260; -15 15; -15 15; -15 15; -15 15];
            for gr = 1:ngroups
                gr1 = group_index{counter2unique_group(gr)};
                [~,sorted_trace_index]= sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend');
                % color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,quantile(positional_data(1,gr1,5)-positional_data(1,gr1,6),[0.05 0.95]));
                color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,[-260 -280]);
                subplot(2,4,gr)
                set(gca,'TickDir','Out','Fontsize',10);
                axis square
                hold on
                for worm = 1:length(sorted_trace_index);
                    %plot sorted by a specific criterion
                    % for s = 1:size(gr1,1)
                    % plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index))),plot_style{gr},'linewidth',0.25);
                    plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index(worm)))),'Color',color_selection(worm,:),'linewidth',0.15);
                end
                % legend(unique_regions{region_subset(region_counter)},'location','SouthEast');
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    % ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel([data_col_labels{observation_subset(obs_counter)} ])
                title(unique_group_nice{counter2unique_group(gr)});
                y1 = get(gca,'YLim');
                for rr = 2:size(region_boundaries2,1);
                    line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                    line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                end
            end
            for gr = 1:ngroups
                gr1 = group_index{counter2unique_group(gr)};
                [~,sorted_trace_index]= sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend');
                % color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,quantile(positional_data(1,gr1,5)-positional_data(1,gr1,6),[0.05 0.95]));
                color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,[-260 -280]);
                subplot(2,4,gr+4)
                set(gca,'TickDir','Out','Fontsize',10);
                axis square
                hold on
                for worm = 1:length(sorted_trace_index);
                    %plot sorted by a specific criterion
                    % for s = 1:size(gr1,1)
                    % plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index))),plot_style{gr},'linewidth',0.25);
                    wormi= gr1(sorted_trace_index(worm));
                    wposi=[];
                    wposi=eval_fd(pos-timeshift,warpfdCR(wormi));
                    wposi(wposi<1)=1;
                    wposi(wposi>100)=100;
                    plot(pos-timeshift,eval_fd(wposi,pos_fd(wormi)),'Color',color_selection(worm,:),'linewidth',0.15);
                    
                end
                % legend(unique_regions{region_subset(region_counter)},'location','SouthEast');
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    % ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel([data_col_labels{observation_subset(obs_counter)} ])
                title(['CR ' unique_group_nice{counter2unique_group(gr)}]);
                y1 = get(gca,'YLim');
                for rr = 2:size(region_boundaries2,1);
                    line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                    line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                end
            end
            hold off
        end
        
        if diagnostic_plots == 6
            figure('Name','Evaluate each fit');
            % plotfit_fd_ja_withbasis(dataset,position,pos_fd)
            plotfit_fd(dataset,position,pos_fd)
        end
    end
end

if export_figures == 8
    figurecount = length(findobj('Type','figure'));
    figure_basename = 'hd233 2do64w GCV optimized smooth d';
    fig_name = [];
    for fig=[1:figurecount]
        set(gcf,'PaperPositionMode','auto','PaperOrientation','portrait','PaperUnits','normalized')
        fig_name{fig} = strcat([figure_basename ' ' num2str(fig) ' ' get(gcf,'Name') '.pdf']);
        
        export_fig(figure(fig),'-r300',fig_name{fig},'-pdf','-transparent','-q100','-append','-bookmark');
    end
    append_pdfs([figure_basename '.pdf'],fig_name{:})
    %
    % close all
    
end

%% ------------------------------------------------------------------------
%    Step 3: Plot data with preliminary smooth
% ------------------------------------------------------------------------
varprop = [];
harmonics = [];
Rsq_pos_pca_t = [];
harmfd =[];
diagnostic_plots = 4;
scounter = 1;

alpha = 0.95;
num_std = 1.96;

cm = cptcmap('CM_cool-warm');
export_figures = 0;
if export_figures == 1
    close all
end

for timetrim = [0]
    obs_counter = 0;
    
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = obs_counter +1;
        %         obs_counter=1;      %for testing
        
        data_subset = [];
        data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
        data_subset = squeeze(data_subset);
        nworms = size(data_subset,2);
        
        % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
        
        timeshift = 0;%-time(1); %this is necessary to avoid negative times
        %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
        %
        position = 1:size(positional_data,1);
        dataset = data_subset;
        
        basis_range = [min(position) max(position)];
        norder = 6;
        bspline_nbreaks = 96;
        
        breaks = linspace(min(position),max(position),bspline_nbreaks);
        nbasis = length(breaks) + norder - 2;
        bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);
        
        % plot bspline object
        if diagnostic_plots == 0
            figure('Name','detail of bspline object')
            plot(bspline_obj)
            xlim(basis_range)
            xlabel(['position + ' num2str(timeshift) ])
        end
        %
        
        % Use a differential operator to smooth data
        Lfd2 = int2Lfd(2);
        lambda2 = 10^(-1.5);
        pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
        [pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
        df,sum(gcv)
        
        %determine wether to transform data to derivative form
        if take_derivative ~= 0
            pos_fd = deriv_fd(pos_fd,take_derivative)
        end
        
        %
        plot_style={'-k','-b','-r','-k','-b','-r','-k','-b','-r'};
       
%         color_list = cptcmap('GMT_wysiwyg','ncol',ngroups);
        color_list = cptcmap('CM_Paired_08','ncol',ngroups,'flip',false);%ngroups
        %yaxis_limits = [0.2 0.8; -280 -250;-2.5 12.5];
        %yaxis_limits = [0.2 0.8; -280 -250;-5 20];
        %         yaxis_limits = [0.2 0.8; -277.5 -257.5;-2.5 20];
        %         yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -8 8];
        yaxis_limits = [0.3 0.5; -275 -265; -3 3; -1 5; -3 3; -5 1];
        
        pos = linspace(min(position),max(position),201);
        
        %plot fd
        if diagnostic_plots == 4
            legend_names= [];
            figure('Name',['Mean Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0.2 0 0.5 1]);
            
            axis square
            for gr = 1:ngroups
                
                set(gca,'TickDir','Out','Fontsize',10);
                hold on
                gr1 = group_index{counter2unique_group(gr)};
                plot(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),'Color', color_list(gr,:),'linewidth',2);
                 legend_names{gr} = unique_group_nice{counter2unique_group(gr)};
            end
              legend(legend_names,'location','Eastoutside');
               for gr = 1:ngroups
                   gr1 = group_index{counter2unique_group(gr)};
               % errorbar(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),num_std.*std(eval_fd(pos,pos_fd(gr1)),0,2)./sqrt(gr_size(counter2unique_group(gr))),...
               %     'Color', color_list(gr,:),'linewidth',0.25);
               
                [hl,hp] = boundedline(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2), num_std.*std(eval_fd(pos,pos_fd(gr1)),0,2)./sqrt(gr_size(gr)),...
                    'alpha','cmap',color_list(gr,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1) ./sqrt(length(worm_subset))
                %outlinebounds(hl,hp);
                
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel(['mean +/- ' num2str(num_std) ' s.e.m. ' data_col_labels{observation_subset(obs_counter)}])
                title([' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)])
               
            end
            y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            hold off
        end
        
         if diagnostic_plots == 4
            figure('Name',['Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
            
                    yaxis_limits = [0.1 0.8; -280 -230; -15 15];
                    yaxis_limits = [0.1 0.8; -280 -260; -15 15; -15 15; -15 15; -15 15];
            for gr = 1:ngroups
                 gr1 = group_index{counter2unique_group(gr)};
                [~,sorted_trace_index]= sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend');
               % color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,quantile(positional_data(1,gr1,5)-positional_data(1,gr1,6),[0.05 0.95]));
                color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,[-260 -280]);
                subplot(2,2,gr)
                set(gca,'TickDir','Out','Fontsize',10);
                 axis square
                hold on
                for worm = 1:length(sorted_trace_index);
                    %plot sorted by a specific criterion
                    % for s = 1:size(gr1,1)
                % plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index))),plot_style{gr},'linewidth',0.25);
                plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index(worm)))),'Color',color_selection(worm,:),'linewidth',0.15);
                end
                % legend(unique_regions{region_subset(region_counter)},'location','SouthEast');
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel([data_col_labels{observation_subset(obs_counter)} ])
                title(unique_group_nice{counter2unique_group(gr)});
                  y1 = get(gca,'YLim');
                for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                end
            end
           
            hold off
        end
        
        if diagnostic_plots == 6
            figure('Name','Evaluate each fit');
            % plotfit_fd_ja_withbasis(dataset,position,pos_fd)
            plotfit_fd(dataset,position,pos_fd)
        end
    end
end

if export_figures == 8
    figurecount = length(findobj('Type','figure'));
    figure_basename = 'hd233 2do64w GCV optimized smooth d';
    fig_name = [];
    for fig=[1:figurecount]
        set(gcf,'PaperPositionMode','auto','PaperOrientation','portrait','PaperUnits','normalized')
        fig_name{fig} = strcat([figure_basename ' ' num2str(fig) ' ' get(gcf,'Name') '.pdf']);
        
        export_fig(figure(fig),'-r300',fig_name{fig},'-pdf','-transparent','-q100','-append','-bookmark');
    end
    append_pdfs([figure_basename '.pdf'],fig_name{:})
    %
    % close all
    
end



%% ------------------------------------------------------------------------
%    Step 4: Evaluate smooth of data
% ------------------------------------------------------------------------
diagnostic_plots = 1
export_figures = 0;
if export_figures == 1
    close all
end

for timetrim = [0]
    m=[];
    idx=[];
    mm=[];
    midx=[];
    df_screen = [];
    gcv_screen = [];
    obs_counter = 0;
    
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = obs_counter +1;
        
        %         obs_counter=1;      %for testing
        
        data_subset = [];
        data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
        data_subset = squeeze(data_subset);
        nworms = size(data_subset,2);
        
        % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
        
        %         timeshift = 0;%-time(1); %this is necessary to avoid negative times
        %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
        %
        position = 1:size(positional_data,1);
        dataset = data_subset;
        
        
        bspline_nbreaks_set = 96;%45:9:99;%81:99;70%66:1:74;%70;%(55:5:85)-timetrim;%%10:2:38;70%70;%
        Lfd_pca_set = 2;%1:4;
        
        
        
        bspline_counter = 0;
        pos = linspace(min(position),max(position),201);
        
        
        gcvtmp_screen= [];
        
        for bspline_nbreaks = bspline_nbreaks_set
            bspline_counter =  bspline_counter +1;
            %  Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
            basis_range = [min(position) max(position)];
            norder = 6;
            
            breaks = linspace(min(position),max(position),bspline_nbreaks);
            nbasis = length(breaks) + norder - 2;
            bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);
            
            % plot bspline object
            if diagnostic_plots == 2 && (obs_counter) == 2
                figure('Name','detail of bespline object')
                plot(bspline_obj)
                xlim(basis_range)
            end
            
            %  finding best lambda for the smooth based on GCV minimization criteria
            
            
            count = 0;
            i = -4:0.5:4;%-1:0.10:2;
            for j = 1:length(i)
                count=count+1;
                lambda_screen = 10^i(j);
                Lfd2_screen = int2Lfd(2);
                pos_Par_screen = fdPar(bspline_obj,Lfd2_screen,lambda_screen);
                
                [pos_fd_screen,dftmp,gcvtmp_screen] = smooth_basis(position,dataset,pos_Par_screen);
                gcv_screen(obs_counter,bspline_counter,count) = sum(gcvtmp_screen,2);
                df_screen(obs_counter,bspline_counter,count) = dftmp;
                pos_vals_screen = eval_fd(position,pos_fd_screen);
                
                if diagnostic_plots == 2
                    
                    figure('Name',['Smooth of data, lambda=' num2str(10^i(j))] )
                    %set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
                    plot(position-timeshift,pos_vals_screen(:,:),'linewidth',0.15)
                    hold on
                    %  plot(position-timeshift,dataset(:,:),'r.')
                    hold off
                    title(strcat('log_1_0(\lambda) = ',num2str(i(j)),' gcv=',num2str(gcv_screen(obs_counter,bspline_counter,count))),'fontsize',10);
                    xlabel(['position + ' num2str(timeshift) ])
                    ylabel([data_col_labels{observation_subset(obs_counter)}  ])
                end
                
            end
            
            %
            
            [mtmp,idxtmp] = min(squeeze(gcv_screen(obs_counter,bspline_counter,:)));
            m(obs_counter,bspline_counter)= mtmp;
            idx(obs_counter,bspline_counter) = idxtmp;
            
            
            if diagnostic_plots == 1
                figure('Name','GCV vs log lambda');
                set(gcf,'Units','Normalized','OuterPosition',[0.25 0.25 0.6 0.6]);
                
                axis square
                hold on
                plot(i,squeeze(gcv_screen(obs_counter,bspline_counter,:)),'r');
                title(strcat(' breaks=',num2str(bspline_nbreaks),'. At min GCV=',num2str(m(obs_counter,bspline_counter)),...
                    ',log_1_0(\lambda)=', num2str(i(idx(obs_counter,bspline_counter))),...
                    ', df=',num2str(df_screen(obs_counter,bspline_counter,idx(obs_counter,bspline_counter)))));
                xlabel( 'log_1_0(\lambda)' );
                ylabel( ['GCV(\lambda) ' data_col_labels{observation_subset(obs_counter)} ] );
                hold off
            end
            
            
        end
        
        [mm_tmp,midx_tmp]= min(m(obs_counter,:));
        mm(obs_counter) = mm_tmp;
        midx(obs_counter) = midx_tmp;
        
    end
end
%
if diagnostic_plots == 1
    figure('Name',['plot of minGCV(breaks) vs breaks' ' timetrim=' num2str(timetrim)]);
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    obs_counter = 0;
    
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = obs_counter +1;
        
        
        subplot(nobs,1,obs_counter)
        plot(bspline_nbreaks_set,squeeze(m(obs_counter,:)),'-r');
        title([data_col_labels{observation_subset(obs_counter)}  ' min(min(GCV))=' num2str(mm(obs_counter)) ...
            ' at breaks='  num2str(bspline_nbreaks_set(midx(obs_counter)))   ]);
        xlabel( 'breaks' );
        ylabel( 'minGCV(breaks)' );
        
        
        
        
    end
    
    
end


%
if diagnostic_plots == 1
    cm2 = cptcmap('CM_001-fire','flip',true);
    figure('Name',['contour of GCV(breaks) vs breaks' ' timetrim=' num2str(timetrim)]);
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    obs_counter = 0;
    
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = obs_counter +1;
        
        subplot(nobs,1,obs_counter)
        hold on
        contourf(repmat(bspline_nbreaks_set',1,length(i)),repmat(i,length(bspline_nbreaks_set),1),squeeze(gcv_screen(obs_counter,:,:)),500,'LineColor','none');
        title([{[data_col_labels{observation_subset(obs_counter)}  ' timetrim=' num2str(timetrim)]},...
            {['min(min(GCV))=' num2str(mm(obs_counter)) ...
            ' at breaks='  num2str(bspline_nbreaks_set(midx(obs_counter)))   ]}]);
        xlabel( 'breaks' );
        ylabel( 'log_{10}(\lambda)' );
        colormap(cm2)
        %colorbar('location','southoutside');
        hold off
    end
    
    
end



%
if export_figures == 1
    figurecount = length(findobj('Type','figure'));
    figure_basename = 'position hd233 2do 394w lambda(smooth) optimization';
    fig_name = [];
    for fig=[1:figurecount]
        set(gcf,'PaperPositionMode','auto','PaperOrientation','portrait','PaperUnits','normalized')
        fig_name{fig} = strcat([figure_basename ' ' num2str(fig) ' ' get(gcf,'Name') '.pdf']);
        
        export_fig(figure(fig),'-r300',fig_name{fig},'-pdf','-transparent','-q100','-append','-bookmark');
    end
    append_pdfs([figure_basename '.pdf'],fig_name{:})
    %
    close all
    
end


%% 2
% ------------------------------------------------------------------------
% --------------------------------------------
%
%       Evaluating PCA goodness of fit
%        'effect of bspline_nbreaks'
%
% --------------------------------------------


bspline_nbreaks_set = 69:10:99;%81:99;%90%;55:1:85;%30:10:100;30:10:100;68;99;%
deltaSSE=[];
SSE_pos_pca_residuals=[];
SSE_resres=[];
SSE=[];
SST=[];
Rsq=[];
SSEtrim =[];
SSTtrim =[];
Rsqtrim=[];

timetrim_set =  [0 1 2 ];%[0:10:50]

dataset=[]
diagnostic_plots = 1;
timetrim_counter=0;
for timetrim =timetrim_set;
    obs_counter = 0;
    timetrim_counter = timetrim_counter+1;
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = obs_counter +1;
        
        %         obs_counter=1;      %for testing
        
        % yaxis_limits = [0.2 0.8; -280 -250;-5 20];
        yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -8 8];%-5-ja_E(0.2)+ja_E(0.8)];
        
        data_subset = [];
        data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
        data_subset = squeeze(data_subset);
        nworms = size(data_subset,2);
        
        % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
        
        %         timeshift = 0;%-time(1); %this is necessary to avoid negative times
        %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
        %
        position = 1:size(positional_data,1);
        dataset = data_subset;
        
        
        %         %try changing data amplitude
        %         dataset = dataset * 100;
        %
        %         %try reversing data
        %         dataset=flipud(dataset);
        %         position=max(position)-position(end:-1:1);
        
        bspline_counter =0;
        for bspline_nbreaks = bspline_nbreaks_set
            bspline_counter = bspline_counter+1;
            %  Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
            basis_range = [min(position) max(position)];
            norder = 6;
            
            breaks = [linspace(min(position),max(position),bspline_nbreaks)];
            nbasis = length(breaks) + norder - 2;
            bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);
            
            % plot bspline object
            if diagnostic_plots == 2
                figure('Name','detail of bespline object')
                plot(bspline_obj)
                xlim(basis_range)
            end
            
            % Smooth data
            Lfd2 = int2Lfd(2);
            lambda2 = 10^(-1.5); %light smoothing
            pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
            [pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
            df,sum(gcv)
            
            %determine wether to transform data to derivative form
            if take_derivative ~= 0
                pos_fd = deriv_fd(pos_fd,take_derivative)
            end
            
            % PCA
            
            Lfd_pca = int2Lfd(2);
            lambda_pca = 10^(-0.3);
            pos_pcaPar =  fdPar(bspline_obj,Lfd_pca,lambda_pca);
            
            nharm  = 12;4;%
            pos_pcastr = pca_fd(pos_fd, nharm, pos_pcaPar);
            
            if diagnostic_plots == 0
                figure('Name','Functional PCA');
                subplot(1,1,1)
                set(gcf,'Units','Normalized','OuterPosition',[0 0 0.5 1]);
                savename=['PCA ' data_col_labels{observation_subset(obs_counter)}]
                %plot_pca_fd(pos_pcastr, 1,1:4,0,0,1)
                % plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,1) % saves figures
                plot_pca_fd_ja(pos_pcastr, 1,1:4,0,0,1,0,savefigures,savename)
            end
            
            if diagnostic_plots == 0
                figure('Name','Functional PCA: Residuals');
                subplot(1,1,1)
                set(gcf,'Units','Normalized','OuterPosition',[0 0 0.5 1]);
                savename=['PCA residuals ' data_col_labels{observation_subset(obs_counter)}]
                % plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,1) % saves figures
                plot_pca_fd_ja2(pos_pcastr, 1,1:4,0,0,1,0,savefigures,savename)
            end
            
            if diagnostic_plots == 2
                figure('Name','Functional PCA: harmonics with basis');
                set(gcf,'Units','Normalized','OuterPosition',[0.25 0.25 0.5 0.5]);
                plotfd_withbasis_ja(pos_pcastr.harmfd(1))
            end
            
            %  Plot log eigenvalues and proportion of variance
            
            if diagnostic_plots == 2
                figure;
                pos_harmeigval = pos_pcastr.values;
                subplot(1,3,1)
                plot(1:15,log10(pos_harmeigval(1:15)),'-o')
                xlabel('Eigenvalue Number')
                ylabel('Log10 Eigenvalue')
                
                pos_varprop=pos_pcastr.varprop;
                subplot(1,3,2)
                plot(1:nharm,pos_varprop,'-o')
                xlim([1 nharm]);
                ylim([0 1]);
                xlabel('Harmonic')
                ylabel('Proportion of Variance explained by Harmonic')
                title('Scree plot');
                
                subplot(1,3,3)
                for harm=1:nharm
                    pos_cum_var(harm)= sum(pos_varprop(1:harm));
                end
                plot(1:nharm,pos_cum_var(1:nharm),'-o')
                xlim([1 nharm]);
                ylim([0 1]);
                xlabel('Harmonic')
                ylabel('Cumulative proportion of the variance explained')
            end
            
            % Calculate SSE as a measure  of how good is the fit of the PCA to the dataset\
            % and compare this to
            % A) the SSE of the bspline fit of each time series used for the PCA
            % (implemented).
            % B) The SSE of a GCV minimized (or near) bspline fit of each time series
            % (not implemented yet).
            
            %data residuals
            data_residuals = dataset - mean(dataset,2) * ones(1,nworms);
            
            
            % Values of the residuals of smooths of each region minus their mean functions
            pos_mean_fd = mean(pos_fd);
            pos_mean_mat = squeeze(eval_fd(position,pos_mean_fd));
            
            pos_eval = eval_fd(position,pos_fd);
            pos_residuals_mat = [];
            
            pos_residuals_mat(:,:) = squeeze(pos_eval(:,:)) - pos_mean_mat*ones(1,nworms);
            
            
            % SSE of the residuals of the smooths relative to their means
            SSE_pos_residuals = sum(sum(pos_residuals_mat.^2));
            
            % PCA harmonic scores associated with each worm and region
            harm_scores = pos_pcastr.harmscr;
            
            % Values of the harmonics
            harmfd = pos_pcastr.harmfd;
            harm_eval = eval_fd(position,harmfd);
            
            % Values of the mean functions from PCA
            meanfd = pos_pcastr.meanfd;
            pos_pca_mean_mat = squeeze(eval_fd(position,meanfd));
            
            % % SSE between PCA and smooth derived mean functions
            % residual_mean_methods = pos_mean_mat - pos_pca_mean_mat;
            % SSE_mean_methods = sum(sum(residual_mean_methods.^2))
            % % sanity check comment: this is zero as expected
            
            % SSE of the residual between the pca fits and the PCA mean
            fdhatfd = pos_pcastr.fdhatfd;
            pos_pca_residuals = eval_fd(position,fdhatfd);
            SSE_pos_pca_residuals = sum(sum(pos_pca_residuals.^2));
            
            deltaSSE(bspline_counter,obs_counter) = SSE_pos_pca_residuals-SSE_pos_residuals;
            
            SSE = sum(sum((pos_pca_residuals-data_residuals).^2));
            SST = sum(sum(data_residuals.^2));
            Rsq(obs_counter,bspline_counter) = squeeze(1-SSE./SST);
            
            SSEtrim = sum(sum((pos_pca_residuals(1+timetrim:end-timetrim,:)-data_residuals(1+timetrim:end-timetrim,:)).^2));
            SSTtrim = sum(sum(data_residuals(1+timetrim:end-timetrim,:).^2));
            Rsqtrim(obs_counter,bspline_counter,timetrim_counter) = squeeze(1-SSEtrim./SSTtrim);
            
        end
    end
end

%Rsq = squeeze(1-SSE./SST);
%Rsq_trim = squeeze(1-SSE(:,:,4:end-4)./SST(:,:,4:end-4));
%% 2
% Plot results of bspline_nbreaks screen

obs_counter = 0;

color_list = cptcmap('GMT_wysiwyg','ncol',length(timetrim_set));

figure('Name','Optimization of the number of bspline breaks for PCA');
set(gcf,'Units','Normalized','OuterPosition',[0.2 0 0.5 1]);
%loop around all selected regions and observations
for obs = 1:length(observation_subset)
    obs_counter = obs_counter +1;
    
    subplot(nobs,1, obs_counter)
    
    m=[];
    idx=[];
    
    
    
    
    
    hold on
    grid on
    title([{'Optimization of the number of bspline breaks for PCA'}...
        {[ '\lambda_{smooth}=' num2str(lambda2) ', \lambda_{PCA}=' num2str(lambda_pca) ]}]);%, maxR^2_{trim' num2str(timetrim) '} @ nbreaks =' num2str(bspline_nbreaks_set(idx))]}])
    plot(bspline_nbreaks_set,squeeze(Rsq(obs_counter,:)),'-ko')
    
    legends=[];
    for trim_counter = 1:length(timetrim_set)
        [m,idx] = max(Rsqtrim(obs_counter,:,trim_counter));
        
        disp(['Best number of breaks ' data_col_labels{observation_subset(obs_counter)} ...
            ': ' num2str(bspline_nbreaks_set(idx)) ' for trim=' num2str(timetrim_set(trim_counter))]);
        
        plot(bspline_nbreaks_set,squeeze(Rsqtrim(obs_counter,:,trim_counter)),'-o','Color', color_list(trim_counter,:))
        legends{trim_counter}= strcat('R^2trim', num2str(timetrim_set(trim_counter)));
    end
    legend(cat(2,{'R^2'},legends),'location','SouthEast')
    xlabel('Number of bspline breaks')
    ylabel(['R^2 ' data_col_labels{observation_subset(obs_counter)}])
    hold off
    
    
end


%% 2
%
% -------------------------------------------------------
%
%     Visual inspection of fits with best parameters
%
% -------------------------------------------------------
bspline_nbreaks = 99;

obs_counter = 3;

data_subset = [];
data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
data_subset = squeeze(data_subset);
nworms = size(data_subset,2);

% Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve

%         timeshift = 0;%-time(1); %this is necessary to avoid negative times
%         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
%
position = 1:size(positional_data,1);
dataset = data_subset;



basis_range = [min(position) max(position)];
norder = 6;

breaks = linspace(min(position),max(position),bspline_nbreaks);
nbasis = length(breaks) + norder - 2;
bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);

% plot bspline object
if diagnostic_plots == 3
    figure('Name','detail of bespline object')
    plot(bspline_obj)
    xlim(basis_range)
end

% Smooth data
Lfd2 = int2Lfd(2);
lambda2 = 10^(-1.5); %light smoothing
pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
[pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
df,sum(gcv)

%determine wether to transform data to derivative form
if take_derivative ~= 0
    pos_fd = deriv_fd(pos_fd,take_derivative)
end

% PCA
Lfd_pca = int2Lfd(2);
lambda_pca = 10^(-0.1)  ;
pos_pcaPar =  fdPar(bspline_obj,Lfd_pca,lambda_pca);

nharm  = 12;
pos_pcastr = pca_fd(pos_fd, nharm, pos_pcaPar);


%diagnotic plot to look at residuals and goodness of fit
if diagnostic_plots == 1
    line_styles = 'rkcbggggggggggggggggggggg';
    wormidnice = num2str(position);%;strrep(metadata_txt(worm_subset,2),'_',' ');
    t = linspace(min(position),max(position),201);
    
    pos_eval = eval_fd(t,pos_fd);
    
    harmfd = pos_pcastr.harmfd;
    harm_eval = eval_fd(t,harmfd);
    
    meanfd = pos_pcastr.meanfd;
    pos_pca_mean_mat = squeeze(eval_fd(t,meanfd));
    
    fdhatfd = pos_pcastr.fdhatfd;
    pos_pca_residuals = eval_fd(t,fdhatfd);
    
    harm_scores = pos_pcastr.harmscr;
    figure;
    for subsx = 1:nworms
        sharm_scores = squeeze(harm_scores(subsx,:))'; %transpose if only one region
        mean_mat = [];
        
        mean_mat =  pos_pca_mean_mat(:);
        for h= 1:nharm
            subplot(1,2,1)
            mean_mat = mean_mat + harm_eval(:,h) * sharm_scores(h);
            plot(t,pos_pca_mean_mat+ harm_eval(:,h) * sharm_scores(h),line_styles(h));
            hold on
            title([num2str(subsx) ' ' wormidnice(subsx)]);
        end
        grid on; set(gca,'XGrid','off')
        
        %plot(t,pos_pca_mean_mat+harm_eval * harm_scores,'-k','linewidth',3); %sanity check comp to next line
        plot(t, pos_pca_mean_mat+pos_pca_residuals(:,subsx),'--g','linewidth',3);
        
        plot(t, pos_pca_mean_mat,'-r','linewidth',2);
        plot(position,dataset(:,subsx),'o');
        plot(t,pos_eval(:,subsx),'.');
        ylim([yaxis_limits(observation_subset(obs_counter)-3,1) yaxis_limits(observation_subset(obs_counter)-3,2)]);
        %ylim([0 1]);
        xlim([min(position) max(position)]);
        xlabel(['position + ' num2str(timeshift) ])
        ylabel([data_col_labels{observation_subset(obs_counter)} ])
        
        y1 = get(gca,'YLim');
        for rr = 2:size(region_boundaries2,1);
            line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle','-');
            line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle','-');
        end
        line([3,3],[y1],'color','g','LineStyle','-');
        line([98,98],[y1],'color','g','LineStyle','-');
        hold off
        
        subplot(1,2,2)
        plot(position,+eval_fd(position,fdhatfd(subsx)),'-g','linewidth',3);
        
        hold on
        grid on; set(gca,'XGrid','off')
        plot(position,-squeeze(eval_fd(position,meanfd))+eval_fd(position,pos_fd(subsx)),'-b','linewidth',2);
        plot(position,+eval_fd(position,fdhatfd(subsx))+squeeze(eval_fd(position,meanfd))-eval_fd(position,pos_fd(subsx)),'-k','linewidth',2);
        %     plot(t,trace{r},'-k','linewidth',2);
        %     plot(t, mean_mat(:,r),'-r','linewidth',2);
        %     plot(t, mean_mat(:,r)+iguess(:,subsx,r),'--g','linewidth',3);
        %     plot(position,dataset(:,subsx,r),'o');
        %     plot(t,spos_eval(:,subsx,r),'.');
        ylim([yaxis_limits(observation_subset(obs_counter)-3,1) yaxis_limits(observation_subset(obs_counter)-3,2)]);
        % ylim([-0.2 0.2]);
        xlim([min(position) max(position)]);
        xlabel(['position + ' num2str(timeshift) ])
        ylabel(['Residuals of ' data_col_labels{observation_subset(obs_counter)} ])
        y1 = get(gca,'YLim');
        for rr = 2:size(region_boundaries2,1);
            line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle','-');
            line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle','-');
        end
        line([3,3],[y1],'color','g','LineStyle','-');
        line([98,98],[y1],'color','g','LineStyle','-');
        hold off
        
        % disp(subsx)
        pause
    end
    
end

%% 3
% --------------------------------------------
%
%        Evaluating PCA goodness of fit
%             'effect of lambda'
%
% --------------------------------------------

diagnostic_plots =0;

bspline_nbreaks_set = [96 99];%66:1:74;%55:5:85%;55:1:85;%30:10:100;30:10:100;68;
loglambda_pca_set = -1:0.1:0;%-1.5:0.5:1;%-0.1;%%-5:5%-2:0.2:2;%
Lfd_pca_set = 2%1:4;

deltaSSE=[];
SSE_pos_pca_residuals=[];
SSE_resres=[];
SSE=[];
SST=[];
Rsq=[];
Rsqtrim=[];
dataset=[];


for timetrim = 2;%[0:10:50]
    obs_counter = 0;
    
    
    %loop around all selected regions and observations
    for obs = 1:length(observation_subset)
        obs_counter = obs_counter +1;
        
        %         obs_counter=1;      %for testing
        
        % yaxis_limits = [0.2 0.8; -280 -250;-5 20];
        yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -8 8];%-5-ja_E(0.2)+ja_E(0.8)];
        
        data_subset = [];
        data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
        data_subset = squeeze(data_subset);
        nworms = size(data_subset,2);
        
        % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
        
        %         timeshift = 0;%-time(1); %this is necessary to avoid negative times
        %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
        %
        
        bspline_counter = 0;
        for bspline_nbreaks = bspline_nbreaks_set
            bspline_counter =  bspline_counter +1
            
            
            position = 1:size(positional_data,1);
            dataset = data_subset;
            
            
            basis_range = [min(position) max(position)];
            norder = 6;
            
            breaks = linspace(min(position),max(position),bspline_nbreaks);
            nbasis = length(breaks) + norder - 2;
            bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);
            
            % plot bspline object
            if diagnostic_plots == 1
                figure('Name','detail of bespline object')
                plot(bspline_obj)
                xlim(basis_range)
            end
            
            % Smooth data
            Lfd2 = int2Lfd(2);
            lambda2 = 10^(-1.5); %light smoothing
            pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
            [pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
            df,sum(gcv)
            
            % PCA
            loglambda_pca_counter = 0;
            for loglambda_pca = loglambda_pca_set
                loglambda_pca_counter = loglambda_pca_counter + 1;
                Lfd_pca = int2Lfd(2);
                pos_pcaPar =  fdPar(bspline_obj,Lfd_pca,10^loglambda_pca);
                
                nharm  = 12;
                pos_pcastr = pca_fd(pos_fd, nharm, pos_pcaPar);
                
                if diagnostic_plots == 1
                    figure('Name','Functional PCA');
                    subplot(1,1,1)
                    set(gcf,'Units','Normalized','OuterPosition',[0 0 0.5 1]);
                    savename=['PCA ' data_col_labels{observation_subset(obs_counter)}]
                    %plot_pca_fd(pos_pcastr, 1,1:4,0,0,1)
                    % plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,1) % saves figures
                    plot_pca_fd_ja(pos_pcastr, 1,1:4,0,0,1,0,savefigures,savename)
                    %  plot_pca_fd_ja(pos_pcastr, 1,5:8,0,0,1,0,savefigures,savename)
                end
                
                if diagnostic_plots == 1
                    figure('Name','Functional PCA: Residuals');
                    subplot(1,1,1)
                    set(gcf,'Units','Normalized','OuterPosition',[0 0 0.5 1]);
                    savename=['PCA residuals ' data_col_labels{observation_subset(obs_counter)}]
                    % plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,1) % saves figures
                    plot_pca_fd_ja2(pos_pcastr, 1,1:4,0,0,1,0,savefigures,savename)
                    % plot_pca_fd_ja2(pos_pcastr, 1,5:8,0,0,1,0,savefigures,savename)
                end
                
                if diagnostic_plots == 2
                    figure('Name','Functional PCA: harmonics with basis');
                    set(gcf,'Units','Normalized','OuterPosition',[0.25 0.25 0.5 0.5]);
                    plotfd_withbasis_ja(pos_pcastr.harmfd(1))
                end
                
                
                %  Plot log eigenvalues and proportion of variance
                
                if diagnostic_plots == 1
                    figure;
                    pos_harmeigval = pos_pcastr.values;
                    subplot(1,3,1)
                    plot(1:15,log10(pos_harmeigval(1:15)),'-o')
                    xlabel('Eigenvalue Number')
                    ylabel('Log10 Eigenvalue')
                    
                    pos_varprop=pos_pcastr.varprop;
                    subplot(1,3,2)
                    plot(1:nharm,pos_varprop,'-o')
                    xlim([1 nharm]);
                    ylim([0 1]);
                    xlabel('Harmonic')
                    ylabel('Proportion of Variance explained by Harmonic')
                    title('Scree plot');
                    
                    subplot(1,3,3)
                    for harm=1:nharm
                        pos_cum_var(harm)= sum(pos_varprop(1:harm));
                    end
                    plot(1:nharm,pos_cum_var(1:nharm),'-o')
                    xlim([1 nharm]);
                    ylim([0 1]);
                    xlabel('Harmonic')
                    ylabel('Cumulative proportion of the variance explained')
                end
                
                %data residuals
                data_residuals = dataset - mean(dataset,2) * ones(1,nworms);
                
                % Values of the residuals of smooths of each region minus their mean functions
                pos_mean_fd = mean(pos_fd);
                pos_mean_mat = squeeze(eval_fd(position,pos_mean_fd));
                
                pos_eval = eval_fd(position,pos_fd);
                pos_residuals_mat = [];
                
                pos_residuals_mat(:,:) = squeeze(pos_eval(:,:)) - pos_mean_mat*ones(1,nworms);
                
                
                % SSE of the residuals of the smooths relative to their means
                SSE_pos_residuals = sum(sum(pos_residuals_mat.^2));
                
                % PCA harmonic scores associated with each worm and region
                harm_scores = pos_pcastr.harmscr;
                
                % Values of the harmonics
                harmfd = pos_pcastr.harmfd;
                harm_eval = eval_fd(position,harmfd);
                
                % Values of the mean functions from PCA
                meanfd = pos_pcastr.meanfd;
                pos_pca_mean_mat = squeeze(eval_fd(position,meanfd));
                
                % % SSE between PCA and smooth derived mean functions
                % residual_mean_methods = pos_mean_mat - pos_pca_mean_mat;
                % SSE_mean_methods = sum(sum(residual_mean_methods.^2))
                % % sanity check comment: this is zero as expected
                
                % SSE of the residual between the pca fits and the PCA mean
                fdhatfd = pos_pcastr.fdhatfd;
                pos_pca_residuals = eval_fd(position,fdhatfd);
                SSE_pos_pca_residuals = sum(sum(pos_pca_residuals.^2));
                
                deltaSSE(bspline_counter,obs_counter) = SSE_pos_pca_residuals-SSE_pos_residuals;
                
                SSE = sum(sum((pos_pca_residuals-data_residuals).^2));
                SST = sum(sum(data_residuals.^2));
                Rsq(obs_counter,bspline_counter,loglambda_pca_counter) = squeeze(1-SSE./SST);
                
                SSEtrim = sum(sum((pos_pca_residuals(1+4:end-4,:)-data_residuals(1+4:end-4,:)).^2));
                SSTtrim = sum(sum(data_residuals(1+4:end-4,:).^2));
                Rsqtrim(obs_counter,bspline_counter,loglambda_pca_counter) = squeeze(1-SSEtrim./SSTtrim);
                
                
            end
        end
    end
end


%save workspace15May2013c.mat
%
%%
% Plot results of loglambda_pca screen

% color_list = cptcmap('CM_cool-warm','ncol',length(bspline_nbreaks_set));

color_list = cptcmap('GMT_wysiwyg','ncol',length(bspline_nbreaks_set));

obs_counter = 0;



%loop around all selected regions and observations
for obs = 1:length(observation_subset)
    obs_counter = obs_counter +1;
    
    
    % subplot(nobs,1,obs_counter)
    figure('Name','Optimization of the number of bspline breaks for PCA');
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    
    mm=[]; ; idxm=[];
    
    [mm,idxm] = max(max(squeeze(Rsqtrim(obs_counter,:,:))));
    [~,idxbr]= max(squeeze(Rsqtrim(obs_counter,:,idxm)));
    
    title([{'Optimization of lambdaPCA'},...
        {[ '\lambda_{smooth}=' num2str(lambda2) ', timetrim=' num2str(timetrim) ]},...
        {['best combination: \lambda_{PCA}=' num2str(loglambda_pca_set(idxm)) ', breaks=' num2str(bspline_nbreaks_set(idxbr))]} ]);
    hold on
    grid on
    loglambda_pca_counter = 0;
    for bspline_counter = 1:length(bspline_nbreaks_set)
        %         for loglambda_pca = loglambda_pca_set
        %             loglambda_pca_counter = loglambda_pca_counter + 1;
        
        m=[];  idx=[];
        
        [m,idx] = max(Rsqtrim(obs_counter,bspline_counter,:));
        
        
        disp(['Best loglambda_pca_set value for ' data_col_labels{observation_subset(obs_counter)}...
            ' breaks=' num2str(bspline_nbreaks_set(bspline_counter)) ': 10^(' num2str(loglambda_pca_set(idx)) ')']);
        
        
        
        % plot(loglambda_pca_set,squeeze(Rsq(obs_counter,region_counter,bspline_counter,:)),'-o','Color',color_list(bspline_counter,:))
        plot(loglambda_pca_set,squeeze(Rsqtrim(obs_counter,bspline_counter,:)),'-o','Color',color_list(bspline_counter,:))
        %         end
        legend_content{bspline_counter} =  sprintf('breaks =%3d, max@log_1_0(\\lambdaPCA) =%.1g',bspline_nbreaks_set(bspline_counter),loglambda_pca_set(idx));
    end
    legend(legend_content,'location','SouthEast')
    xlabel('log_{10}(\lambda_{PCA})')
    ylabel(['R^2 ' data_col_labels{observation_subset(obs_counter)} ])
    hold off
end



% %%
% m=[];
% idx=[];
%
% bspline_nbreaks_set'
% [m,idx] = min(squeeze(deltaSSE)'.^2)
%
% disp('Best loglambda_pca_set index')
% disp('pm3 pm5 pm7')
% disp(num2str(loglambda_pca_set(idx)))
% disp('Best loglambda_pca_set value')
% disp(num2str(10.^loglambda_pca_set(idx)))
%
% %%
%
% figure('Name','Optimization of lambda PCA');
% subplot(1,3,1)
% hold on
% grid on
%
%
% plot(loglambda_pca_set',squeeze(SSE_resres)')
% legend(data_col_labels{observation_subset},'location','northeast')
% xlabel('log_{10}\lambda_{PCA}')
% ylabel(['SSE (pca-smooth)'])
%
% subplot(1,3,2)
% plot(loglambda_pca_set',squeeze(deltaSSE)')
% hold on
% grid on
% legend(data_col_labels{observation_subset},'location','northeast')
% plot([min(loglambda_pca_set) max(loglambda_pca_set)],[0 0],'-b')
% xlabel('log_{10}\lambda_{PCA}')
% ylabel(['deltaSSE ' ])
% title([{'Optimization of lambda PCA'}...
%     {[ 'bspline nbreaks=' num2str(bspline_nbreaks)]}...
%     {['\lambda_{smooth}=' num2str(lambda2) ]} ]);
% hold off
%
% subplot(1,3,3)
% plot(loglambda_pca_set',squeeze(deltaSSE)'.^2)
% hold on
% grid on
% legend(data_col_labels{observation_subset},'location','northeast')
% xlabel('log_{10}\lambda_{PCA}')
% ylabel(['deltaSSE^2 ' ])
% hold off
%
%
% %%
%
% figure('Name','Optimization of lambda PCA');
% for obs =1:nobs
%     subplot(3,3,(obs-1)*3+1)
%     hold on
%     grid on
%
%
%     plot(loglambda_pca_set',squeeze(SSE_resres(:,obs,:))')
%     legend(data_col_labels{observation_subset(obs)},'location','northeast')
%     xlabel('log_{10}\lambda_{PCA}')
%     ylabel(['SSE (pca-smooth)'])
%
%     subplot(3,3,(obs-1)*3+2)
%     plot(loglambda_pca_set',squeeze(deltaSSE(:,obs,:))')
%     hold on
%     grid on
%     legend(data_col_labels{observation_subset(obs)},'location','northeast')
%     plot([min(loglambda_pca_set) max(loglambda_pca_set)],[0 0],'-b')
%     xlabel('log_{10}\lambda_{PCA}')
%     ylabel(['deltaSSE ' ])
%     title([{'Optimization of lambda PCA'}...
%         {[ 'bspline nbreaks=' num2str(bspline_nbreaks)]}...
%         {['\lambda_{smooth}=' num2str(lambda2) ]} ]);
%     hold off
%
%     subplot(3,3,(obs-1)*3+3)
%     plot(loglambda_pca_set',squeeze(deltaSSE(:,obs,:))'.^2)
%     hold on
%     grid on
%     legend(data_col_labels{observation_subset(obs)},'location','northeast')
%     xlabel('log_{10}\lambda_{PCA}')
%     ylabel(['deltaSSE^2 ' ])
%     hold off
%
% end
%
%
%
%
%
%

%
%% ------------------------------------------------------------------------
%    Step 5: Perform PCA
% ------------------------------------------------------------------------
varprop = [];
harmonics = [];
Rsq_pos_pca_t = [];
harmfd =[];
pos_residuals_mat_matrix = [];
pos_residuals_mat_matrix_fine = [];

scounter = 1;
savefigures = 0;
take_derivative= 0;
diagnostic_plots = 4;

obs_counter = 0;
color_list = cptcmap('CM_Paired_08','ncol',ngroups);
 color_list = cptcmap('CM_Paired_08','ncol',ngroups,'flip',false);%ngroups

%loop around all selected regions and observations
for obs = 1:length(observation_subset)
    obs_counter = obs_counter +1;
    
    
    
    data_subset = [];
    data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
    data_subset = squeeze(data_subset);
    nworms = size(data_subset,2);
    
    % Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
    timeshift = 0;%-time(1); %this is necessary to avoid negative times
    %         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
    
    position = 1:size(positional_data,1);
    
    
    
    dataset1=[];
    for worm=1:nworms;
        wposi=[];
        wposi=eval_fd(position,warpfdCR(worm));
        wposi(wposi<1)=1;
        wposi(wposi>100)=100;
        dataset1(:,worm)= eval_fd(wposi,pos_fd(worm)) ;
    end
    
    %dataset = data_subset; %unregistered
    dataset = dataset1; %CR registered
    
    
    
    
    
    bspline_nbreaks_set = 96;
    loglambda_pca_set = -0.3;%optimized
    Lfd_pca_set = 2;%1:4;
    
    deltaSSE=[];
    SSE_pos_pca_residuals=[];
    SSE_resres=[];
    
    bspline_counter = 0;
    t = linspace(min(position),max(position),201);
    %
    for bspline_nbreaks = bspline_nbreaks_set
        bspline_counter =  bspline_counter +1;
        %  Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve
        basis_range = [min(position) max(position)];
        norder = 6;
        
        breaks = linspace(min(position),max(position),bspline_nbreaks);
        nbasis = length(breaks) + norder - 2;
        bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);
        
        % plot bspline object
        if diagnostic_plots == 1
            figure('Name','detail of bespline object')
            plot(bspline_obj)
            xlim(basis_range)
            xlabel(['position + ' num2str(timeshift) ])
        end
        
        % Smooth data
        Lfd2 = int2Lfd(2);
        lambda2 = 10^(-1.5); %GCV optimized
        pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
        [pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
        %df,sum(gcv)
        
        %determine wether to transform data to derivative form
        if take_derivative ~= 0
            pos_fd = deriv_fd(pos_fd,take_derivative)
        end
        
        plot_style={'-r','-k','-c','-b'};
        
        %color_list = cptcmap('GMT_wysiwyg','ncol',ngroups);
        color_list = cptcmap('CM_Paired_08','ncol',ngroups);
    
        %yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -8 8];
        yaxis_limits = [0.3 0.5; -275 -265; -3 3];
        
        pos = linspace(min(position),max(position),201);
        
        %plot fd
        if diagnostic_plots == 3
            legend_names= [];
            figure('Name',['Mean Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0.2 0 0.5 1]);
            
            
            for gr = 1:ngroups
                 gr1 = group_index{counter2unique_group(gr)};
                set(gca,'TickDir','Out','Fontsize',10);
                hold on
                plot(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),'Color', color_list(gr,:),'linewidth',2);
                legend_names{gr} = unique_group_nice{counter2unique_group(gr)};
            end
            legend(legend_names,'location','Southeast');
            for gr = 1:ngroups
                 gr1 = group_index{counter2unique_group(gr)};
                errorbar(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),std(eval_fd(pos,pos_fd(gr1)),0,2)./sqrt(gr_size(counter2unique_group(gr))),...
                    'Color', color_list(gr,:),'linewidth',0.25);
                
                %[hl,hp] = boundedline(pos-timeshift,mean(eval_fd(pos,pos_fd(gr1)),2),std(eval_fd(pos,pos_fd(gr1)),0,2)./sqrt(gr_size(gr)),...
                %    'alpha','cmap',color_list(gr,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1) ./sqrt(length(worm_subset))
                %outlinebounds(hl,hp);
                
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel(['mean +/- 1 s.e.m. ' data_col_labels{observation_subset(obs_counter)}])
                title([' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)])
               
            end
            y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            hold off
            
            figure('Name',['Smooth of ' data_col_labels{observation_subset(obs_counter)} ...
                ' breaks=' num2str(bspline_nbreaks) ' lambda=' num2str(lambda2) ' timetrim=' num2str(timetrim)]);
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
            
                    yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
            for gr = 1:ngroups
                 gr1 = group_index{counter2unique_group(gr)};
                [~,sorted_trace_index]= sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend');
                color_selection = cmapping(sort(positional_data(1,gr1,5)-positional_data(1,gr1,6),'descend'),cm,quantile(positional_data(1,gr1,5)-positional_data(1,gr1,6),[0.05 0.95]));

                subplot(2,3,gr)
                set(gca,'TickDir','Out','Fontsize',10);
                hold on
                for worm = 1:length(sorted_trace_index);
                    %plot sorted by a specific criterion
                    % for s = 1:size(gr1,1)
                % plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index))),plot_style{gr},'linewidth',0.25);
                plot(pos-timeshift,eval_fd(pos,pos_fd(gr1(sorted_trace_index(worm)))),'Color',color_selection(worm,:),'linewidth',0.15);
                end
                % legend(unique_regions{region_subset(region_counter)},'location','SouthEast');
                xlim([min(pos)-timeshift, max(pos)-timeshift])
                if take_derivative == 0
                    ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
                end
                xlabel(['A-P position along pharynx' ])
                ylabel([data_col_labels{observation_subset(obs_counter)} ])
                title(unique_group_nice{counter2unique_group(gr)});
                  y1 = get(gca,'YLim');
                for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
                end
            end
           
            hold off
        end
 


% PCA
loglambda_pca_counter = 0;
for loglambda_pca = loglambda_pca_set
    loglambda_pca_counter = loglambda_pca_counter + 1;
    Lfd_pca = int2Lfd(2);
    pos_pcaPar =  fdPar(bspline_obj,Lfd_pca,10^loglambda_pca);
    
    nharm  = 4;
    pos_pcastr = pca_fd(pos_fd, nharm, pos_pcaPar);
    
    if diagnostic_plots == 4
        figure('Name','Functional PCA Mean + Residuals');
        subplot(1,1,1)
        set(gcf,'Units','Normalized','OuterPosition',[0 0 0.5 1]);
        savename=['PCA ' data_col_labels{observation_subset(obs_counter)} ];
        % plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,1) % saves figures
        plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,savefigures,savename)
        if savefigures ~= 0
            for i = 1:nharm
                 fig_name = [];
                fig_name{i} = strcat(savename,'-',num2str(i),'.pdf'); 
            end
             append_pdfs([savename ' .pdf'],fig_name{:})
        end
    end
    
    if diagnostic_plots == 4
        figure('Name','Functional PCA Residuals');
        subplot(1,1,1)
        set(gcf,'Units','Normalized','OuterPosition',[0 0 0.5 1]);
        savename=['PCA residuals ' data_col_labels{observation_subset(obs_counter)}];
        % plot_pca_fd_ja(pos_pcastr, 1,0,0,0,1,0,1) % saves figures
        plot_pca_fd_ja2(pos_pcastr, 1,0,0,0,1,0,savefigures,savename)
        if savefigures ~= 0
            fig_name = [];
            for i = 1:nharm
                fig_name{i} = strcat(savename,'-',num2str(i),'.pdf'); 
            end
             append_pdfs([savename '.pdf'],fig_name{:})
        end
    end
    
    %  Plot log eigenvalues and proportion of variance
    
    if diagnostic_plots == 5
        figure;
        pos_harmeigval = pos_pcastr.values;
        subplot(1,3,1)
        plot(1:15,log10(pos_harmeigval(1:15)),'-o')
        xlabel('Eigenvalue Number')
        ylabel('Log10 Eigenvalue')
        
        pos_varprop=pos_pcastr.varprop;
        subplot(1,3,2)
        plot(1:nharm,pos_varprop,'-o')
        xlim([1 nharm]);
        ylim([0 1]);
        xlabel('Harmonic')
        ylabel('Proportion of Variance explained by Harmonic')
        title('Scree plot');
        
        subplot(1,3,3)
        for harm=1:nharm
            pos_cum_var(harm)= sum(pos_varprop(1:harm));
        end
        plot(1:nharm,pos_cum_var(1:nharm),'-o')
        xlim([1 nharm]);
        ylim([0 1]);
        xlabel('Harmonic')
        ylabel('Cumulative proportion of the variance explained')
    end
    
    
    
    % Calculate SSE as a measure  of how good is the fit of the PCA to the dataset\
    % and compare this to
    % A) the SSE of the bspline fit of each time series used for the PCA
    % (implemented).
    % B) The SSE of a GCV minimized (or near) bspline fit of each time series
    % (not implemented yet).
    
    % Values of the residuals of smooths of each region minus their mean functions
    pos_mean_fd = mean(pos_fd);
    pos_mean_mat = squeeze(eval_fd(position,pos_mean_fd));
    
    pos_eval = eval_fd(position,pos_fd);
    pos_residuals_mat = [];
    
    pos_residuals_mat = squeeze(pos_eval(:,:)) - pos_mean_mat*ones(1,nworms);
    % SSE of the residuals of the smooths relative to their means
    SSE_pos_residuals = sum(sum(pos_residuals_mat.^2));
    
    
    % PCA harmonic scores associated with each worm and region
    harm_scores = pos_pcastr.harmscr;
    
    % Values of the mean functions from PCA
    meanfd = pos_pcastr.meanfd;
    pos_pca_mean_mat = squeeze(eval_fd(position,meanfd));
    
    % % SSE between PCA and smooth derived mean functions
    % residual_mean_methods = pos_mean_mat - pos_pca_mean_mat;
    % SSE_mean_methods = sum(sum(residual_mean_methods.^2))
    % % sanity check comment: this is zero as expected
    
    % SSE of the residual between the pca fits and the PCA mean
    fdhatfd = pos_pcastr.fdhatfd;
    pos_pca_residuals = eval_fd(position,fdhatfd);
    SSE_pos_pca_residuals(bspline_counter,loglambda_pca_counter) = sum(sum(pos_pca_residuals.^2));
    
    deltaSSE(bspline_counter,loglambda_pca_counter) = SSE_pos_pca_residuals(bspline_counter,loglambda_pca_counter)-SSE_pos_residuals;
    SSE_resres(bspline_counter,loglambda_pca_counter) = sum(sum( (pos_pca_residuals-pos_residuals_mat).^2 ));
    
    SStotal_pos_residuals_t = sum(pos_residuals_mat.^2,2);
    SSerr_pos_pca_t = sum((pos_pca_residuals-pos_residuals_mat).^2,2);
    Rsq_pos_pca_t(obs_counter,:) = 1-(SSerr_pos_pca_t./SStotal_pos_residuals_t);
    
    if diagnostic_plots == 2
        if obs_counter == 1 
            figure;
        end
        % subplot(3,3,scounter);plot(position,sum(pos_residuals_mat.^2,2),'-bo'); hold on
        % subplot(3,3,scounter);plot(position,sum(pos_pca_residuals.^2,2),'-ro');
        subplot(nobs,1,scounter);plot(position,squeeze(Rsq_pos_pca_t(obs_counter,:)),'-bo'); hold on
        title([data_col_labels{observation_subset(obs_counter)} ])
        xlabel(['time + ' num2str(timeshift) ' min'])
        ylabel('R^2_{PCA}(t)');
        xlim([min(position), max(position)-2]);
        ylim([0 1]);
        scounter=scounter+1
        hold off
    end
end

end

harmonics(:,obs_counter,:) = harm_scores; %worm region obs harm#
varprop(obs_counter,:) = pos_pcastr.varprop;

% Values of the harmonics
harmfd{obs_counter} = pos_pcastr.harmfd;
pos_residuals_mat_matrix(obs_counter,:,:) = pos_residuals_mat;

figuretime = min(position):0.5:max(position);
pos_residuals_mat_matrix_fine(obs_counter,:,:) = squeeze(eval_fd(figuretime,pos_fd)) - squeeze(eval_fd(figuretime,pos_mean_fd))*ones(1,nworms);

% %%
% m=[];
% idx=[];
% disp('Best number of breaks')
%
% %bspline_nbreaks_set'
% [mtmp,idxtmp] = min(squeeze(deltaSSE)'.^2);
% m=mtmp;
% idx=idxtmp;
%
% disp(['loglambda_pca: ' num2str(loglambda_pca_set(idx))])
% disp(['lambda_pca: ' num2str(10.^loglambda_pca_set(idx))])
% disp('                ');
%
% %%
% if diagnostic_plots == 0
% figure('Name','Optimization of lambda PCA');
%
% subplot(1,3,1)
% title(['Optimization of lambda PCA ' data_col_labels{observation_subset(obs_counter)}]);
% plot(loglambda_pca_set',squeeze(SSE_resres)')
% hold on
% grid on
% xlabel('lambda PCA')
% ylabel(['SSE (pca-smooth)' data_col_labels(observation_subset(obs_counter))])
% hold off
% legend(unique_regions{2:4},'location','northeast')
%
% subplot(1,3,2)
% plot(loglambda_pca_set',squeeze(deltaSSE)')
% hold on
% grid on
% plot([min(loglambda_pca_set) max(loglambda_pca_set)],[0 0],'-b')
% xlabel('lambda PCA')
% ylabel(['deltaSSE ' data_col_labels(observation_subset(obs_counter))])
% hold off
%
% subplot(1,3,3)
% plot(loglambda_pca_set',squeeze(deltaSSE)'.^2)
% hold on
% grid on
% xlabel('lambda PCA')
% ylabel(['deltaSSE^2 ' data_col_labels(observation_subset(obs_counter))])
% hold off
%
% end


%  Plot factor scores
harmscr = pos_pcastr.harmscr;
plotstyle = {'.r','.m','*c','*b','og','+k'};
legendinfo = [];
if diagnostic_plots == 5
    figure('Name','Factor scores: scatterplots');
      set(gca,'TickDir','Out','Fontsize',10);
    subplot(1,1,1)
    for counter= 1:ngroups
        
        hold on
        plot(harmscr(group_index{counter2unique_group(counter)},1),...
            harmscr(group_index{counter2unique_group(counter)},2), plotstyle{counter})
        disp('aa')
        xlabel('Harmonic I')
        ylabel('Harmonic II')
        legendinfo{counter} = unique_group_nice{counter2unique_group(counter)};
        % text(harmscr(:,1)+5, harmscr(:,2), ##worm id##)
        hold off
    end
    title([data_col_labels{observation_subset(obs_counter)} ])
end

if diagnostic_plots == 4
    % Plot cdfs for each harmonic stratified by strain_age
    x=[];
    f=[];
    
    c1 = 'rmcbgk';
    figure('Name','CDFs of harmonic scores');
    set(gcf,'Units','Normalized','OuterPosition',[0.5 0 0.5 1]);
      
    maxharm=4;%nharm;
    for harm = 1:maxharm
        subplot(2,2,harm);
        set(gca,'TickDir','Out','Fontsize',10);
        hold on
        axis square
        for gr = 1:ngroups
            [f,x] = ecdf(harmscr(group_index{counter2unique_group(gr)},harm));
            stairs(x,f,'Color',color_list(gr,:),'LineWidth',1.5);
        end
        set(gca,'fontsize',10);
        xlabel(['Harmonic ' num2str(harm) ' score']);
        ylabel('Cum. Prob.','fontsize',10);
        title([data_col_labels{observation_subset(obs_counter)}])
        
        hold off
        legend(unique_group_nice{counter2unique_group},'location','southeast');
        
    end
    
end



% Plot PCA functions
if diagnostic_plots == 1
    c1='kbrc';
    c2={'-k','-b','-r','-c'};
    cerr2={'--k','--b','--r','--c'};
    %yaxis_limits = [0.3 0.6; -275 -260;-2.5 12.5];
    %yaxis_limits = [0.2 0.8; -277.5 -257.5;-2.5 20];
    yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
     yaxis_limits = [0.2 0.6; -280 -260; -8 8];
     
    figure('Name','PCA functions for each group and worm');
    set(gcf,'Units','Normalized','OuterPosition',[00 0 1 1]);
    
    maxharm=nharm;5;%
    nstderr=1.96;1%
    for harm = 1:maxharm
        subplot(ngroups+1,maxharm,harm);
        hold on
        axis square
        set(gca,'TickDir','Out','Fontsize',10);
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
        if take_derivative == 0
            ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
        end
        xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
        xlabel(['A-P position along pharynx' ])
        ylabel([data_col_labels{observation_subset(obs_counter)} ' (mean +/- ' num2str(nstderr) ' sem)'])
        title(['Harmonic ' num2str(harm) ])
        
          y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
        
        hold off
        %h_legend=(unique_group_nice{counter2unique_group});
        %set(h_legend,'FontSize',7,'location','southeast');
        hold on
        for gr = 1:ngroups
            gr1=counter2unique_group(gr);
            group_score = mean(harm_scores(group_index{gr1},harm));
            group_score_sem = std(harm_scores(group_index{gr1},harm))./sqrt(length(harm_scores(group_index{gr1},harm)));
            group_harm_values = pos_mean_t + harm_eval_t(:,harm) * group_score;
            group_errorbar =  harm_eval_t(:,harm) * group_score_sem * nstderr; %
            
            [hl,hp] = boundedline(figuretime-timeshift,group_harm_values, group_errorbar,...);
                'cmap',rgb('Indigo'),'alpha','transparency',0.4);%,cerr2{j-1},'linewidth',1)
            %outlinebounds(hl,hp);
        end
        hold off
    end
    
    
    % Plot PCA functions for all worms of each region
    for harm = 1:maxharm
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
        for gr = 1:ngroups
            %subplot(maxharm,ngroups+1,(harm-1)*(ngroups+1)+gr+1);
            subplot(ngroups+1,maxharm,harm+gr*maxharm);
            set(gca,'TickDir','Out','Fontsize',10);
            axis square
            hold on
            gr1=counter2unique_group(gr);
            [~,sorted_trace_index]= sort(harm_scores(group_index{gr1},harm),'descend');
            color_selection = cmapping(sort(harm_scores(group_index{gr1},harm),'descend'),cm,quantile(harm_scores(group_index{gr1},harm),[0.05 0.95]));
            for worm = 1:length(sorted_trace_index);
                worm_score = harm_scores(group_index{gr1}(sorted_trace_index(worm)),harm);
                
                worm_harm_values = pos_mean_t + harm_eval_t(:,harm) * worm_score;
                
                plot(figuretime-timeshift,worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
            end
            %cmlines(cm)
            h_legend=legend(unique_group_nice{counter2unique_group(gr)});
            set(h_legend,'FontSize',7,'location','southeast');
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
               ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
            
              y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
             xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([data_col_labels{observation_subset(obs_counter)} ' Harmonic ' num2str(harm) ])
            hold off
        end
    end
end




% Effect of removing each PCA
% Plot All PCAs - harmonic X
if diagnostic_plots == 5
    % yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
    yaxis_limits = [0.2 0.6; -280 -260; -8 8];
    yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
    
    for gr = 1:ngroups
        figure('Name',['Effect of removing each PCA functions for ' unique_group_nice{counter2unique_group(gr)}] );
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
        
        maxharm=5;%nharm;%5;
        nstderr=1.96;1%
       
        % Plot All PCA functions sorted by harm X score, for all worms of each region
        for harm = 1:maxharm
            harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
            subplot(2,maxharm,harm);
            set(gca,'TickDir','Out','Fontsize',10);
            axis square
            hold on
            gr1=counter2unique_group(gr);
            [~,sorted_trace_index]= sort(harm_scores(group_index{gr1},harm),'descend');
            color_selection = cmapping(sort(harm_scores(group_index{gr1},harm),'descend'),cm,quantile(harm_scores(group_index{gr1},harm),[0.05 0.95]));
            harm_select = 1:maxharm;
            for worm = 1:length(sorted_trace_index);
                plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(group_index{counter2unique_group(gr)}(sorted_trace_index(worm)))),'Color',color_selection(worm,:),'linewidth',0.15);hold on;
            end
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
                ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
            xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([unique_group_nice{counter2unique_group(gr)} '  splined data'])
            hold off
        
      
        % Plot All but one PCA functions sorted by harm X score, for all worms of each region
        subplot(2,maxharm,harm+maxharm);
        set(gca,'TickDir','Out','Fontsize',10);
        axis square
        hold on
        gr1=counter2unique_group(gr);
        [~,sorted_trace_index]= sort(harm_scores(group_index{gr1},harm),'descend');
        color_selection = cmapping(sort(harm_scores(group_index{gr1},harm),'descend'),cm,quantile(harm_scores(group_index{gr1},harm),[0.05 0.95]));
        harm_select =  harm;
        for worm = 1:length(sorted_trace_index);
            worm_score = harm_scores(group_index{gr1}(sorted_trace_index(worm)),harm_select);
            worm_harm_values = harm_eval_t(:,harm_select) * worm_score';
            plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(group_index{counter2unique_group(gr)}(sorted_trace_index(worm))))-worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
        end
        xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
        if take_derivative == 0
            ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
        end
        xlabel(['A-P position along pharynx' ])
        ylabel([data_col_labels{observation_subset(obs_counter)}])
        title([ unique_group_nice{counter2unique_group(gr)} ' splined data - harmonic ' num2str(harm)])
        hold off
        end
    end
end

% Effect of sequentially adding each PCA 
if diagnostic_plots == 5
      % yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
   % yaxis_limits = [0.2 0.6; -280 -260; -8 8];
    yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
    figure('Name','Sequential addition of PCA functions');
    set(gcf,'Units','Normalized','OuterPosition',[00 0 1 1]);
    
    maxharm=6;nharm;5;%
    nstderr=1.96;%1%
    
    for harm = 1:maxharm
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
        for gr = 1:ngroups
            subplot(1,maxharm,harm);
            set(gca,'TickDir','Out','Fontsize',10);
            %axis square
            hold on
            [~,sorted_trace_index]= sort(harm_scores(:,harm),'descend');
            color_selection = cmapping(sort(harm_scores(:,harm),'descend'),cm,quantile(harm_scores(:,harm),[0.05 0.95]));
            for worm = 1:length(sorted_trace_index);
                worm_score = harm_scores(sorted_trace_index(worm),1:harm);
                worm_harm_values = pos_mean_t + harm_eval_t(:,1:harm) * worm_score';
                plot(figuretime-timeshift,worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
            end
%             h_legend=legend(unique_group_nice{counter2unique_group(gr)});
%             set(h_legend,'FontSize',7,'location','southeast');
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
                ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
              y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([data_col_labels{observation_subset(obs_counter)} ' Sum of harmonics <=' num2str(harm) ])
            hold off
        end
    end
end






% Effect of sequentially adding each PCA
if diagnostic_plots == 5
    % yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
   % yaxis_limits = [0.2 0.6; -280 -260; -8 8];
   yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
   
   for gr = 1:ngroups
       figure('Name','Sequential addition of PCA functions');
       set(gcf,'Units','Normalized','OuterPosition',[00 0 1 1]);
       
    maxharm=6;nharm;5;%
    nstderr=1.96;%1%
    
    for harm = 1:maxharm
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
     
            subplot(1,maxharm,harm);
            set(gca,'TickDir','Out','Fontsize',10);
            %axis square
            hold on
            gr1=counter2unique_group(gr);
            [~,sorted_trace_index]= sort(harm_scores(group_index{gr1},harm),'descend');
            color_selection = cmapping(sort(harm_scores(group_index{gr1},harm),'descend'),cm,quantile(harm_scores(group_index{gr1},harm),[0.05 0.95]));
            for worm = 1:length(sorted_trace_index);
                worm_score = harm_scores(group_index{gr1}(sorted_trace_index(worm)),1:harm);
                worm_harm_values = pos_mean_t + harm_eval_t(:,1:harm) * worm_score';
                plot(figuretime-timeshift,worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
            end
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
                ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
              y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([{[unique_group_nice{counter2unique_group(gr)} ' ' data_col_labels{observation_subset(obs_counter)}]},...
                {[' Sum of harmonics <=' num2str(harm)]} ])
            hold off
        end
    end
end




% Effect of sequentially removing each PCA
if diagnostic_plots == 5
    % yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
    % yaxis_limits = [0.2 0.6; -280 -260; -8 8];
    yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
    figure('Name','Sequential removal of PCA functions');
    set(gcf,'Units','Normalized','OuterPosition',[00 0 1 1]);
    
    maxharm=6;nharm;5;%
    nstderr=1.96;%1%
    
    for harm = 1:maxharm
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
       
            %subplot(maxharm,ngroups+1,(harm-1)*(ngroups+1)+gr+1);
            % subplot(ngroups,maxharm,harm);
           % subplot(2,ceil(maxharm/2),harm);
               subplot(1,maxharm,harm);
            set(gca,'TickDir','Out','Fontsize',10);
            %axis square
            hold on
            
            [~,sorted_trace_index]= sort(harm_scores(:,harm),'descend');
            color_selection = cmapping(sort(harm_scores(:,harm),'descend'),cm,quantile(harm_scores(:,harm),[0.05 0.95]));
            for worm = 1:length(sorted_trace_index);
                if harm == 1
                    plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(sorted_trace_index(worm))),'Color',color_selection(worm,:),'linewidth',0.15);hold on;
                else
                    worm_score = harm_scores(sorted_trace_index(worm),1:harm-1);
                    worm_harm_values = harm_eval_t(:,1:harm-1) * worm_score';
                    plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(sorted_trace_index(worm)))-worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
                end
            end
            %cmlines(cm)
%             h_legend=legend(unique_group_nice{counter2unique_group(gr)});
%             set(h_legend,'FontSize',7,'location','southeast');
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
                ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
              y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([{['All stages ' data_col_labels{observation_subset(obs_counter)}]},{[  'splined data - sum of harmonics <' num2str(harm) ]}])
            hold off
        
    end
end


% Effect of sequentially removing each PCA from each group
if diagnostic_plots == 5
   
%     yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
        yaxis_limits = [0.2 0.6; -280 -260; -8 8];
        yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
    
      for gr = 1:ngroups  
        figure('Name',['Sequential removal of PCA functions for ' unique_group_nice{counter2unique_group(gr)}]);
    set(gcf,'Units','Normalized','OuterPosition',[00 0 1 1]);
    
    maxharm=6;nharm;5;%
    nstderr=1.96;%1%
    
    for harm = 1:maxharm
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
       
            %subplot(maxharm,ngroups+1,(harm-1)*(ngroups+1)+gr+1);
            % subplot(ngroups,maxharm,harm);
            %subplot(2,ceil(maxharm/2),harm);
             subplot(1,maxharm,harm);
            set(gca,'TickDir','Out','Fontsize',10);
            %axis square
            hold on
            gr1=counter2unique_group(gr);
            [~,sorted_trace_index]= sort(harm_scores(group_index{gr1},harm),'descend');
            color_selection = cmapping(sort(harm_scores(group_index{gr1},harm),'descend'),cm,quantile(harm_scores(group_index{gr1},harm),[0.05 0.95]));
            for worm = 1:length(sorted_trace_index);
                if harm == 1
                    plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(group_index{counter2unique_group(gr)}(sorted_trace_index(worm)))),'Color',color_selection(worm,:),'linewidth',0.15);hold on;
                else
                    
                    worm_score = harm_scores(group_index{gr1}(sorted_trace_index(worm)),1:harm-1);
                    
                    worm_harm_values = harm_eval_t(:,1:harm-1) * worm_score';
                    
                    plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(group_index{counter2unique_group(gr)}(sorted_trace_index(worm))))-worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
                end
            end
            %cmlines(cm)
%             h_legend=legend(unique_group_nice{counter2unique_group(gr)});
%             set(h_legend,'FontSize',7,'location','southeast');
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
                ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
              y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([{[unique_group_nice{counter2unique_group(gr)} ' ' data_col_labels{observation_subset(obs_counter)}]},...
                {[  'splined data - sum of harmonics <' num2str(harm) ]}])
            hold off
        
    end
      end
end




% Effect of sequentially removing each PCA from each group (figures display
% all stages) one figure per harmonic removal

if diagnostic_plots == 5
  %     yaxis_limits = [0.2 0.8; ja_E(0.2) ja_E(0.8); -5 -5-ja_E(0.2)+ja_E(0.8)];
        yaxis_limits = [0.2 0.6; -280 -260; -8 8];
        yaxis_limits = [0.2 0.8; -280 -240; -10 12.5];
     maxharm=6;nharm;5;%
    nstderr=1.96;%1%
       for harm = 1:maxharm
        figure('Name',['Sequential removal of PCA functions' ]);
    set(gcf,'Units','Normalized','OuterPosition',[00 0 1 1]);
    
   
    for gr = 1:ngroups  
   
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter});
       
            %subplot(maxharm,ngroups+1,(harm-1)*(ngroups+1)+gr+1);
            % subplot(ngroups,maxharm,harm);
            %subplot(2,ceil(ngroups/2),gr);
               subplot(1,ngroups,gr);
            set(gca,'TickDir','Out','Fontsize',10);
            %axis square
            hold on
            gr1=counter2unique_group(gr);
            [~,sorted_trace_index]= sort(harm_scores(group_index{gr1},harm),'descend');
            color_selection = cmapping(sort(harm_scores(group_index{gr1},harm),'descend'),cm,quantile(harm_scores(group_index{gr1},harm),[0.05 0.95]));
            for worm = 1:length(sorted_trace_index);
                if harm == 1
                    plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(group_index{counter2unique_group(gr)}(sorted_trace_index(worm)))),'Color',color_selection(worm,:),'linewidth',0.15);hold on;
                else
                    worm_score = harm_scores(group_index{gr1}(sorted_trace_index(worm)),1:harm-1);
                    worm_harm_values = harm_eval_t(:,1:harm-1) * worm_score';
                    plot(figuretime-timeshift,eval_fd(figuretime,pos_fd(group_index{counter2unique_group(gr)}(sorted_trace_index(worm))))-worm_harm_values,'Color',color_selection(worm,:),'linewidth',0.15);hold on;
                end
            end
            %cmlines(cm)
%             h_legend=legend(unique_group_nice{counter2unique_group(gr)});
%             set(h_legend,'FontSize',7,'location','southeast');
            xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
            if take_derivative == 0
                ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
            end
              y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
            xlabel(['A-P position along pharynx' ])
            ylabel([data_col_labels{observation_subset(obs_counter)}])
            title([{[unique_group_nice{counter2unique_group(gr)} ' ' data_col_labels{observation_subset(obs_counter)}]},...
                {[  'splined data - sum of harmonics <' num2str(harm)]} ])
            hold off
        
    end
      end
end

% Plot PCA with SE for each region
if diagnostic_plots == 5
    %yaxis_limits = [0.3 0.6; -275 -260;-2.5 12.5];
    %     yaxis_limits = [0.2 0.6; -282.5 -260;-1 15];
        yaxis_limits = [0.2 0.6; -280 -260; -8 8];
   
        figure('Name','PCA functions for each group');
    set(gcf,'Units','Normalized','OuterPosition',[0  0 1 1]);
    
    maxharm=4;%nharm;
    nstderr=1;%1.96;%1%1.96;
    for harm = 1:maxharm
        subplot(1,maxharm,harm);
        hold on
        axis square
        set(gca,'TickDir','Out','Fontsize',10);
        pos_mean_t = squeeze(eval_fd(figuretime,pos_mean_fd));
        harm_eval_t = eval_fd(figuretime,harmfd{obs_counter})
        for gr = 1:ngroups
            gr1=counter2unique_group(gr);
            group_score = mean(harm_scores(group_index{gr1},harm));
            group_score_sem = std(harm_scores(group_index{gr1},harm))./sqrt(length(harm_scores(group_index{gr1},harm)));
            group_harm_values = pos_mean_t + harm_eval_t(:,harm) * group_score;
            group_errorbar =  harm_eval_t(:,harm) * group_score_sem * nstderr; %
            
            plot(figuretime, group_harm_values, 'Color', color_list(gr,:),'linewidth',2)
        end
         xlim([min(figuretime)-timeshift, max(figuretime)-timeshift-2])
        if take_derivative == 0
             %ylim(yaxis_limits(observation_subset(obs_counter)-3,:))
        end
        
        xlabel(['A-P position along pharynx' ])
        
        ylabel(['\fontsize{10}' data_col_labels{observation_subset(obs_counter)} ' (mean +/- ' num2str(nstderr) ' sem)'])
        title(['Harmonic ' num2str(harm) ],'fontsize',10)
        hold off
        h_legend=legend(unique_group_nice{counter2unique_group});
        set(h_legend,'FontSize',8,'location','Northoutside');
        for gr = 1:ngroups
            hold on
            gr1=counter2unique_group(gr);
            group_score = mean(harm_scores(group_index{gr1},harm));
            group_score_sem = std(harm_scores(group_index{gr1},harm))./sqrt(length(harm_scores(group_index{gr1},harm)));
            group_harm_values = pos_mean_t + harm_eval_t(:,harm) * group_score;
            group_errorbar =  harm_eval_t(:,harm) * group_score_sem * nstderr; %
            
            plot(figuretime,group_harm_values+group_errorbar,'LineStyle','--','Color', color_list(gr,:),'linewidth',0.25);
            plot(figuretime,group_harm_values-group_errorbar,'LineStyle','--','Color', color_list(gr,:),'linewidth',0.25);
            for i=1:length(figuretime)-7; % ~4 min to synch with xlim
                line([figuretime(i),figuretime(i)],[group_harm_values(i)+group_errorbar(i),group_harm_values(i)-group_errorbar(i)],...
                    'linewidth',0.1,'Color', color_list(gr,:));
            end
            hold off
        end
        
        
    end
end


end






%% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
%    Step 6: functional regression
% ------------------------------------------------------------------------
varprop = [];
harmonics = [];
Rsq_pos_pca_t = [];
harmfd =[];

scounter = 1;

cm = cptcmap('CM_cool-warm');
export_figures = 0;
if export_figures == 1
    close all
end
% figure('Name','Functional regression');
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 0.5]);
%for obs_counter=1:nobs;
timetrim = 0;
obs_counter =1;


data_subset = [];
data_subset = positional_data(end:-1:1,worm_subset,observation_subset(obs_counter));
data_subset = squeeze(data_subset);
nworms = size(data_subset,2);

% Set up a b-spline basis object: exclude timepoints if there are NaNs in any curve

timeshift = 0;%-time(1); %this is necessary to avoid negative times
%         timetokeepindex = [1:tbaselineends_index,tstart_index:141-timetrim];%(avoid times between 22-28 (0 6 min) and >141 (62 min) indeces to avoid NaNs
%
position = 1:size(positional_data,1);

dataset1=[];
for worm=1:nworms;
     wposi=[];
     wposi=eval_fd(position,warpfdCR(worm));
     wposi(wposi<1)=1;
     wposi(wposi>100)=100;
     dataset1(:,worm)= eval_fd(wposi,pos_fd(worm)) ;
end

%dataset = data_subset; %unregistered
dataset = dataset1; %CR registered

basis_range = [min(position) max(position)];
norder = 6;
bspline_nbreaks = 96;%40;%

breaks = linspace(min(position),max(position),bspline_nbreaks);
nbasis = length(breaks) + norder - 2;
bspline_obj = create_bspline_basis(basis_range,nbasis,norder,breaks);

% plot bspline object
if diagnostic_plots == 0
    figure('Name','detail of bspline object')
    plot(bspline_obj)
    xlim(basis_range)
    xlabel(['position + ' num2str(timeshift) ])
end
%

% Use a differential operator to smooth data
Lfd2 = int2Lfd(2);
lambda2 = 10^(-1.5);
pos_Par2 = fdPar(bspline_obj,Lfd2,lambda2);
[pos_fd,df,gcv] = smooth_basis(position,dataset,pos_Par2);
df,sum(gcv)

%%
% Set up  basis for regression

reg_basis_range = [min(position) max(position)];
reg_norder = 6;
reg_bspline_nbreaks=35;%12
reg_breaks = linspace(min(position),max(position),reg_bspline_nbreaks); %winning combo so far
reg_nbasis = length(reg_breaks) + reg_norder - 2;
reg_bspline_obj = create_bspline_basis(reg_basis_range,reg_nbasis,reg_norder,reg_breaks);

reg_Lfd = int2Lfd(2);
reg_lambda = 10^(-0.3);
reg_Par1 = fdPar(reg_bspline_obj,reg_Lfd,reg_lambda);
[pos_fd_r,df,gcv] = smooth_basis(position,dataset,reg_Par1);
df,sum(gcv)

% plot bspline object
if diagnostic_plots == 2
    figure('Name','detail of bespline basis for Regression')
    plot(reg_bspline_obj)
    xlim(basis_range)
end

% 
% group_names = [];
% group_names = ['All  '; ...
%     'HD233'; ...
%     'HD236'; ...
%     'HD240'; ...
%     'HD244'];
% 
% 
% % Set up a design matrix having a column for the grand mean, and
% % a column for each genotype_age. Add a dummy contraint observation
% zmat=[];
% zmat = zeros(nworms,5);
% zmat(:,1) = 1;
% zmat(group_index{1},2) = 1;
% zmat(group_index{2},3) = 1;
% zmat(group_index{3},4) = 1;
% zmat(group_index{4},5) = 1;
% 
% % attach a row of 0, 1, 1, 1, 1 to force region
% % effects to sum to zero, and define first regression
% % function as grand mean for all stations
% z_extra    = ones(1,5);
% z_extra(1) = 0;
% zmat   = [zmat; z_extra];


group_names = [];
group_names = ['wt   '; ...
               'd2   '; ...
               'd16  '; ...
               'd16d2'];


% Set up a design matrix having a column for the grand mean, and
% a column for each genotype_age. Add a dummy contraint observation
zmat=[];
zmat = zeros(nworms,4);
zmat(:,1) = 1;
zmat(group_index{3},2) = 1;
zmat(group_index{4},3) = 1;
zmat(group_index{2},2) = 1;
zmat(group_index{2},3) = 1;
zmat(group_index{2},4) = 1;

%%

% revise YFDOBJ by adding a zero function
% coef   = getcoef(pos_fd_r);
% coef_extra = [coef,zeros(reg_nbasis,1)];
% pos_fd_r = putcoef(pos_fd_r, coef_extra);


if diagnostic_plots == 4
    figure;
    plot(pos_fd_r(1:nworms));
    xlabel(['position + ' num2str(timeshift) ' min'])
    ylabel([data_col_labels{observation_subset(obs_counter)}])
    y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
end
%%
p = 4;
xfdcell = cell(1,p);
for j=1:p
    xfdcell{j} = zmat(:,j);
end


% set up the basis for the regression functions
betabasis_range = [min(position) max(position)];
betabasis_norder = 6;
betabasis_bspline_nbreaks=35;%12
betabasis_breaks = linspace(min(position),max(position),betabasis_bspline_nbreaks); %winning combo so far
betabasis_nbasis = length(betabasis_breaks) + betabasis_norder - 2;
betabasis = create_bspline_basis(betabasis_range,betabasis_nbasis,betabasis_norder,betabasis_breaks);

% plot bspline object
if diagnostic_plots == 2
    figure('Name','detail of betabasis object')
    plot(betabasis)
    xlim(betabasis_range)
end
%
% **** Note: Play with the size of the betabasis object

% set up the functional parameter object for the regression fns.
reg_betafd    = fd(zeros(betabasis_nbasis,p), betabasis);
estimate  = 1;
lambda    = 10^(-1.5);
reg_betafdPar = fdPar(reg_betafd, int2Lfd(2), lambda, estimate);
reg_betacell = cell(1,p);
for j=1:p
    reg_betacell{j} = reg_betafdPar;
end

% compute regression coefficient functions and predicted functions
fRegressStruct = fRegress(pos_fd_r, xfdcell, reg_betacell);
betaestcell = fRegressStruct.betahat;
yhatfdobj   = fRegressStruct.yhat;
%
 t = linspace(min(position),max(position),201);
% ----Plot regression functions
if diagnostic_plots == 4
    figure('Name','Preliminary regression functions');
    hold on
    for j=1:p
        subplot(2,3,j)
        plot(t,eval_fd(t,getfd(betaestcell{j})));
        xlabel(['position + ' num2str(timeshift) ' min'])
        ylabel([data_col_labels{observation_subset(obs_counter)}])
        title([group_names(j,:)])
        y1 = get(gca,'YLim');
        for rr = 2:size(region_boundaries2,1);
            line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
            line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
        end
    end
%     subplot(3,3,7)% ----Plot predicted functions
%     plot(t,eval_fd(t,yhatfdobj(nworms+1)))
%     xlabel(['A-P position along pharynx' ])
%     ylabel([data_col_labels{observation_subset(obs_counter)}])
%     title('Predicted values')
%     y1 = get(gca,'YLim');
%     for rr = 2:size(region_boundaries2,1);
%         line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
%         line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
%     end
    %ylim([-285 -260]);
    subplot(2,3,6)% ----Plot predicted functions
    plot(t,eval_fd(t,yhatfdobj(1:nworms)))
    xlabel(['A-P position along pharynx' ])
    ylabel([data_col_labels{observation_subset(obs_counter)}])
    title('Predicted values')
    %ylim([-285 -260]);
    y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
    hold off
end


%% -Choose the level of smoothing by minimizing cross-validated
% -error sums of squares.
% -Only the first 136 observations are used (specified in
% -vector CV_obs), since deleting the 137th observation results in
% -a singularity in the matrix of covariate values.  These are
% -"dummy" observations added to constrain effects to sum to 0.

loglam = -2:0.20:3.2;
SSE_CV = zeros(length(loglam),1);
reg_betafdPari = reg_betafdPar;
CV_obs = 1:nworms;
%wt     = ones(nworms+1,1);
wt     = ones(nworms,1);
for i = 1:length(loglam)
    disp(loglam(i))
    reg_betafdPari = putlambda(reg_betafdPari, 10^loglam(i));
    reg_betacelli = reg_betacell;
    for j = 1:p
        reg_betacelli{j} = reg_betafdPari;
    end
    CVi = fRegress_CV(pos_fd_r, xfdcell, reg_betacelli, wt, CV_obs);
    SSE_CV(i) = CVi;
end
save('Regression position CV optimization OxD');
%%
disp('Log lambda    SSE_CV')

[loglam'  SSE_CV]
[m,idx] = min(SSE_CV)
figure('Name','Choosing lambda for regression based on CV minimization');
subplot(1,1,1)
plot(loglam, SSE_CV, 'bo-','LineWidth', 2)
xlabel('\fontsize{12} log smoothing parameter')
ylabel('\fontsize{12} cross validated sum of squares')
title(strcat('\fontsize{12}',data_col_labels(observation_subset(obs_counter)),'. At min SSE-CV=',num2str(m),...
    ',log_1_0(\lambda_{\betafdPar})=', num2str(loglam(idx))));
loglam'
SSE_CV

%% Recompute regression coefficient functions and predicted functions with new lambda

reg_betafdPar = putlambda(reg_betafdPar, 10^(2.6));% need to find SSE_CV optimized lambdareg
for j = 1:p
    reg_betacell{j} = reg_betafdPar;
end

fRegressStruct = fRegress(pos_fd_r, xfdcell, reg_betacell);

betaestcell = fRegressStruct.betahat;
yhatfdobj   = fRegressStruct.yhat;
%%
% Re-Plot regression functions
if diagnostic_plots == 4
    figure('Name','Final regression functions');
    hold on
    for j=1:p
        subplot(2,3,j)
        plot(t,eval_fd(t,getfd(betaestcell{j})));
        xlabel(['position + ' num2str(timeshift) ' min'])
        ylabel([data_col_labels{observation_subset(obs_counter)}])
        title([group_names(j,:)])
        y1 = get(gca,'YLim');
        for rr = 2:size(region_boundaries2,1);
            line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
            line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
        end
    end
%     subplot(3,3,7)% ----Plot predicted functions
%     plot(t,eval_fd(t,yhatfdobj(nworms+1)))
%     xlabel(['A-P position along pharynx' ])
%     ylabel([data_col_labels{observation_subset(obs_counter)}])
%     title('Predicted values')
%     y1 = get(gca,'YLim');
%     for rr = 2:size(region_boundaries2,1);
%         line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
%         line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
%     end
    %ylim([-285 -260]);
    subplot(2,3,6)% ----Plot predicted functions
    plot(t,eval_fd(t,yhatfdobj(1:nworms)))
    xlabel(['A-P position along pharynx' ])
    ylabel([data_col_labels{observation_subset(obs_counter)}])
    title('Predicted values')
    %ylim([-285 -260]);
    y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
    hold off
end
%
%%
% compute mapping from data y to coefficients in c
reg_basismat = eval_basis(t, reg_bspline_obj);
y2cMap = (reg_basismat'*reg_basismat)\reg_basismat';

% compute residual matrix and get covariance of residuals
yhatmat  = eval_fd(t, yhatfdobj);
ymat     = eval_fd(t, pos_fd_r);
pos_residualmat = ymat(:,1:nworms) - yhatmat(:,1:nworms);
SigmaE   = cov(pos_residualmat');

if diagnostic_plots == 4
    % ----Plot covariance surface for errors
    figure;
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 0.5]);
    subplot(1,2,1)
    contourf(t,t,SigmaE)
    hold on
    axis square
    plot(reg_basis_range,reg_basis_range,'--')
    xlim(reg_basis_range)
    ylim(reg_basis_range)
      xlabel(['A-P position along pharynx' ])
      ylabel(['A-P position along pharynx' ])
    title('Covariance')
      y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
         x1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line(x1,[region_boundaries2(rr,1),region_boundaries2(rr,1)],'color',plot_color{rr-1},'LineStyle',':');
        line(x1,[region_boundaries2(rr,2),region_boundaries2(rr,2)],'color',plot_color{rr-1},'LineStyle',':');
    end
    hold off
    colorbar;
    
    subplot(1,2,2)
    contourf(t,t,(SigmaE./(sqrt(diag(SigmaE))*sqrt(diag(SigmaE))')).^2)
    hold on
    axis square
    plot(reg_basis_range,reg_basis_range,'--')
    xlim(reg_basis_range)
    ylim(reg_basis_range)
      xlabel(['A-P position along pharynx' ])
      ylabel(['A-P position along pharynx' ])
    title('R^2')
      y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
       x1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line(x1,[region_boundaries2(rr,1),region_boundaries2(rr,1)],'color',plot_color{rr-1},'LineStyle',':');
        line(x1,[region_boundaries2(rr,2),region_boundaries2(rr,2)],'color',plot_color{rr-1},'LineStyle',':');
    end
    hold off
    colorbar;
    
    figure;
    subplot(1,2,1);
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 0.5]);
    surf(t,t,SigmaE,'edgecolor','none');
    zlabel('Covariance');
     xlabel(['A-P position along pharynx' ])
      ylabel(['A-P position along pharynx' ])
    xlim(reg_basis_range)
    ylim(reg_basis_range)
    
    subplot(1,2,2)
    surf(t,t,(SigmaE./(sqrt(diag(SigmaE))*sqrt(diag(SigmaE))')).^2,'edgecolor','none');
      xlabel(['A-P position along pharynx' ])
      ylabel(['A-P position along pharynx' ])
    zlabel('R^2')
    xlim(reg_basis_range)
    ylim(reg_basis_range)
    
    %%% ----Plot standard deviation of errors
    figure;
    stddevE = sqrt(diag(SigmaE));
    plot(t, stddevE, '-')
    xlim(reg_basis_range)
     xlabel(['A-P position along pharynx' ])
    ylabel('stddevE')
     y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
end
%%
%
% Repeat regression, this time outputting results for confidence intervals

stderrStruct = fRegress_stderr(fRegressStruct, y2cMap, SigmaE);

betastderrcell = stderrStruct.betastderr;
%%
% ----Plot regression functions standard errors
if diagnostic_plots == 4
    figure;
    hold on
    for j=1:p
        subplot(1,ngroups+1,j)
        set(gca,'fontsize',10);
        plot(t, eval_fd(t, betastderrcell{j}))
        title([{'beta standard error'} {group_names(j,:)}])
        xlabel(['position + ' num2str(timeshift) ' min'])
        ylabel([data_col_labels{observation_subset(obs_counter)}])
        xlim([min(t), max(t)-4])
        y1 = get(gca,'YLim');
        for rr = 2:size(region_boundaries2,1);
            line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
            line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
        end
    end
    hold off
end
%
% if diagnostic_plots == 4
%     ----Plot regression functions with confidence limits
%     figure;
%     hold on
%     for j=1:p
%         subplot(1,ngroups+1,j)
%         set(gca,'fontsize',10);
%         if j ==0
%             plotbeta(betaestcell{j}(1:nworms), betastderrcell{j}(1:nworms), t)
%         else
%             plotbeta(betaestcell{j}, betastderrcell{j}, t)
%         end
%         
%          xlabel(['A-P position along pharynx' ])
%         ylabel([data_col_labels{observation_subset(obs_counter)}])
%         title([group_names(j,:)])
%         axis([0,70,-15,11])
%         pause
%     end
%     hold off
% end
%
%yaxis_limits = [0.3 0.5; -275 -265; -3 3];

%%
if diagnostic_plots == 4
    % ----Plot regression functions with confidence limits
    figure;
    nstderr = 1.96;
    for j=1:p
        subplot(1,ngroups,j)
        %baseline = eval_fd(t, getfd(betaestcell{1}));
        %group = baseline + eval_fd(t, getfd(betaestcell{j}));
          group =  eval_fd(t, getfd(betaestcell{j}));
        groupstderr = nstderr.*eval_fd(t,betastderrcell{j});
        plot(t, group,'-k')
        hold on
        plot(t,group+groupstderr,':g','linewidth',0.25);
        plot(t,group-groupstderr ,':r','linewidth',0.25);
        for i=floor(linspace(1,length(t),100))
            line([t(i),t(i)],[group(i)+groupstderr(i),group(i)-groupstderr(i)],'linewidth',0.1);
        end
         xlabel(['A-P position along pharynx' ])
        ylabel([data_col_labels{observation_subset(obs_counter)} ...
            ' mean +/- ' num2str(nstderr) ' sem'])
        title([group_names(j,:)])
        %axis([min(position), max(position),-2.5,17.5])
        xlim([min(t), max(t)-4])
        if take_derivative == 0
           % ylim(yaxis_limits(obs_counter,:))
        end
        % axis([min(position), max(position),-275,-255])
        hold off
    end
end
%%
 color_list = cptcmap('CM_Paired_08','ncol',ngroups,'flip',false);%ngroups
c1='kbrc';
c2={'-k','-b','-r','-c'};
cerr2={'--k','--b','--r','--c'};
%yaxis_limits = [0.3 0.65; -280 -250;-5 20];
yaxis_limits = [0.3 0.5; -275 -265; -3 3];
if diagnostic_plots == 4
    % ----Plot regression functions with confidence limits
    nstderr=1.96;%1;%1%
    figuretime=min(position):0.25:max(position);
    %figuretime = position;
    figure;
     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    %subplot(1,nobs,obs_counter)
    set(gca,'fontsize',10, 'TickDir','Out');
    axis square
    hold on
    for j=1:p
        baseline =[];
        group =[];
        switch j
            case 1
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline;
                
            case 4
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline + eval_fd(figuretime, getfd(betaestcell{2}))...
                    + eval_fd(figuretime, getfd(betaestcell{3})) + eval_fd(figuretime, getfd(betaestcell{4}));
            otherwise
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline + eval_fd(figuretime, getfd(betaestcell{j}));
        end
        
        plot(figuretime, group,'Color',color_list(j,:),'linewidth',2)
    end
    
    xlabel(['A-P position along pharynx' ])
    ylabel([data_col_labels{observation_subset(obs_counter)} ' (mean +/- ' num2str(nstderr) ' sem)'])
    %axis([min(figuretime), max(figuretime),-1,16])
    if take_derivative == 0
        % ylim(yaxis_limits(obs_counter,:))
    end
    xlim([min(figuretime), max(figuretime)])
    legend(group_names(1:p,:),'location','Eastoutside');
    
    title(['Regression of ' data_col_labels{observation_subset(obs_counter)}])
  %  line([min(figuretime), max(figuretime)],[0 0],'color','r','LineStyle',':');
    for j=1:p
        baseline =[];
        group =[];
        switch j
            case 1
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline;
                
            case 4
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline + eval_fd(figuretime, getfd(betaestcell{2}))...
                    + eval_fd(figuretime, getfd(betaestcell{3})) + eval_fd(figuretime, getfd(betaestcell{4}));
            otherwise
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline + eval_fd(figuretime, getfd(betaestcell{j}));
        end
        groupstderr = nstderr.*eval_fd(figuretime,betastderrcell{j});
        
        
        plot(figuretime,group+groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
        plot(figuretime,group-groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
        
    
    
    for i=1:length(figuretime)
        line([figuretime(i),figuretime(i)],[group(i)+groupstderr(i),group(i)-groupstderr(i)],...
            'linewidth',0.1,'Color',color_list(j,:));
    end
    
    end
      ylim([-275 -265]);
    y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
    hold off
end

%% ----Plot regression functions with confidence limits
c1='kbrc';
c2={'-k','-b','-r','-c'};
cerr2={'--k','--b','--r','--c'};
%cm =[51/256 0 0; 0 0 102/256;1 102/256 102/256; 1 0 1];
% cm = [0.5 0.5 0.5;
%     0 0 205/256;
%     1 0 0;
%     186/256 85/256 211/256];
% [1 1 0]  	yellow
% [1 0 1] 	magenta
% [0 1 1] 	cyan
% [1 0 0] 	red
% [0 1 0] 	green
% [0 0 1] 	blue
% [1 1 1] 	white
% [0 0 0] 	black


if diagnostic_plots == 4
    
    nstderr = 1.96;1;%1;%1;1;
    figuretime=min(position):0.25:max(position);
    %figuretime = position;
    figure;
     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    %subplot(1,nobs,obs_counter)
    set(gca,'fontsize',10, 'TickDir','Out');
    
    axis square
    hold on
    p = 4;
    baseline=[];
    group = [];
    groupstderr =[];
    
    for j=1:p
        baseline =[];
        group =[];
        switch j
            case 1
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline;
                
            case 4
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline + eval_fd(figuretime, getfd(betaestcell{2}))...
                    + eval_fd(figuretime, getfd(betaestcell{3})) + eval_fd(figuretime, getfd(betaestcell{4}));
            otherwise
                baseline = eval_fd(figuretime, getfd(betaestcell{1}));
                group = baseline + eval_fd(figuretime, getfd(betaestcell{j}));
        end
        groupstderr = nstderr.*eval_fd(figuretime,betastderrcell{j});
         [hl,hp] = boundedline(figuretime,group,groupstderr,...
        'alpha','cmap',color_list(j,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1)
   % outlinebounds(hl,hp);
    end
    
    
     xlabel(['A-P position along pharynx' ])
    ylabel([data_col_labels{observation_subset(obs_counter)} ' (mean +/- ' num2str(nstderr) ' sem)'])
    %axis([min(figuretime), max(figuretime),-1,16])
    xlim([min(figuretime), max(figuretime)])
    if take_derivative == 0
        % ylim(yaxis_limits(obs_counter,:))
    end
    title(['Regression of ' data_col_labels{observation_subset(obs_counter)}])
    legend(group_names(1:p,:),'location','Eastoutside');
    %line([min(figuretime), max(figuretime)],[0 0],'color','r','LineStyle',':');
    ylim([-274 -266]);
    y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
    
    hold off
end

%% ---Plot regression functions
c1='kbrc';
c2={'-k','-b','-r','-c'};
cerr2={'--k','--b','--r','--c'};
%cm =[51/256 0 0; 0 0 102/256;1 102/256 102/256; 1 0 1];
% cm = [0.5 0.5 0.5;
%     0 0 205/256;
%     1 0 0;
%     186/256 85/256 211/256];
% [1 1 0]  	yellow
% [1 0 1] 	magenta
% [0 1 1] 	cyan
% [1 0 0] 	red
% [0 1 0] 	green
% [0 0 1] 	blue
% [1 1 1] 	white
% [0 0 0] 	black

bounded = 1; %0=no 1=yes

if diagnostic_plots == 4
    
    nstderr = 1.96;%1;%1;
    figuretime=min(position):0.25:max(position);
    %figuretime = position;
    figure;
     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    %subplot(1,nobs,obs_counter)
    set(gca,'fontsize',10, 'TickDir','Out');
    
    axis square
    hold on
    p = 4;
    baseline=[];
    group = [];
    groupstderr =[];
    for j=2:p
        group =[];
        group = eval_fd(figuretime, getfd(betaestcell{j}));
        plot(figuretime,group,'LineStyle','-','Color',color_list(j,:),'linewidth',2);
    end
    
     legend(group_names(2:p,:),'location','Eastoutside');
    
    for j=2:p
        group =[];
        group = eval_fd(figuretime, getfd(betaestcell{j}));
        groupstderr = nstderr.*eval_fd(figuretime,betastderrcell{j});
        if bounded == 0
            
            plot(figuretime,group+groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
            plot(figuretime,group-groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
            for i=1:length(figuretime)
                line([figuretime(i),figuretime(i)],[group(i)+groupstderr(i),group(i)-groupstderr(i)],...
                    'linewidth',0.1,'Color',color_list(j,:));
            end
        else
            
            [hl,hp] = boundedline(figuretime,group,groupstderr,...
                'alpha','cmap',color_list(j,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1)
   % outlinebounds(hl,hp);
        end
    end
    
    
     xlabel(['A-P position along pharynx' ])
    ylabel([data_col_labels{observation_subset(obs_counter)} ' (mean +/- ' num2str(nstderr) ' sem)'])
    %axis([min(figuretime), max(figuretime),-1,16])
    xlim([min(figuretime), max(figuretime)])
    if take_derivative == 0
        % ylim(yaxis_limits(obs_counter,:))
    end
    title(['Regression of ' data_col_labels{observation_subset(obs_counter)}])
   
   line([min(figuretime), max(figuretime)],[0 0],'color','r','LineStyle',':');
   % ylim([-275 -265]);
    y1 = get(gca,'YLim');
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
    
    hold off
end

%% ---Plot daf-16 contribution
c1='kbrc';
c2={'-k','-b','-r','-c'};
cerr2={'--k','--b','--r','--c'};
%cm =[51/256 0 0; 0 0 102/256;1 102/256 102/256; 1 0 1];
% cm = [0.5 0.5 0.5;
%     0 0 205/256;
%     1 0 0;
%     186/256 85/256 211/256];
% [1 1 0]  	yellow
% [1 0 1] 	magenta
% [0 1 1] 	cyan
% [1 0 0] 	red
% [0 1 0] 	green
% [0 0 1] 	blue
% [1 1 1] 	white
% [0 0 0] 	black

bounded = 0; %0=no 1=yes

if diagnostic_plots == 4
    
    nstderr = 1.96;%1;%1;1;%
    figuretime=linspace(min(position),max(position),201);linspace(3,97,201);%  min(position):0.25:max(position);
    %figuretime = position;
    figure;
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
    %subplot(1,nobs,obs_counter)
    set(gca,'fontsize',10, 'TickDir','Out');
    
    axis square
    hold on
    p = 4;
    
    term_d16 = eval_fd(figuretime, getfd(betaestcell{3}));
    term_d16d2 = eval_fd(figuretime, getfd(betaestcell{4}));
    faction_active = term_d16 ./ (term_d16 +term_d16d2);
    
    term_d16_error = eval_fd(figuretime, betastderrcell{3});
    term_d16d2_error = eval_fd(figuretime, betastderrcell{4});
    
    err1 = term_d16_error./term_d16;
    err2 = sqrt(term_d16_error.^2 + term_d16d2_error.^2)./ (term_d16 +term_d16d2);
    
    faction_active_error = nstderr * faction_active .* (sqrt( err1.^2 + err2.^2 ));
    
    
    
    group = faction_active;
    groupstderr = faction_active_error;
    j=1;
    plot(figuretime,faction_active,'LineStyle','-','Color',color_list(j,:),'linewidth',2);
    if bounded == 0
        
        plot(figuretime,group+groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
        plot(figuretime,group-groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
        for i=1:length(figuretime)
            line([figuretime(i),figuretime(i)],[group(i)+groupstderr(i),group(i)-groupstderr(i)],...
                'linewidth',0.1,'Color',color_list(j,:));
        end
    else
        
        [hl,hp] = boundedline(figuretime,group,groupstderr,...
            'alpha','cmap',color_list(j,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1)
        % outlinebounds(hl,hp);
    end
    
    if bounded == 0
        
        plot(figuretime,group+groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
        plot(figuretime,group-groupstderr,'LineStyle','--','Color',color_list(j,:),'linewidth',0.25);
        for i=1:length(figuretime)
            line([figuretime(i),figuretime(i)],[group(i)+groupstderr(i),group(i)-groupstderr(i)],...
                'linewidth',0.1,'Color',color_list(j,:));
        end
    else
        
        [hl,hp] = boundedline(figuretime,group,groupstderr,...
            'alpha','cmap',color_list(j,:),'transparency',0.4);%,cerr2{j-1},'linewidth',1)
        % outlinebounds(hl,hp);
    end
    
    
    
    
    xlabel(['A-P position along pharynx' ])
    ylabel(['fraction of possible daf-16 activity in wildtype (mean +/- ' num2str(nstderr) ' sem)'])
    %axis([min(figuretime), max(figuretime),-1,16])
    xlim([min(figuretime), max(figuretime)])
    if take_derivative == 0
        % ylim(yaxis_limits(obs_counter,:))
    end
    %title(['Regression of ' data_col_labels{observation_subset(obs_counter)}])
    
    %line([min(figuretime), max(figuretime)],[0 0],'color','r','LineStyle',':');
    ylim([0 1]);
    y1 = get(gca,'YLim');
    for rr = 2:size(region_boundaries2,1);
        line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
        line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
    end
    
    hold off
end







%%
% % permutation F-test and permutation t-tests
%  figure;
%  F_res1 = Fperm_fd(pos_fd_r, xfdcell, reg_betacell,[],20,[],0.05);
% %%
% 
% region_pair = [1 2; 1 3; 2 3];
% for i =1:length(region_pair)
%     figure;
%     tresStr = tperm_fd(pos_fd(group_index{region_pair(i,1)}), pos_fd(group_index{region_pair(i,2)}),...
%         500,0.05,figuretime);
% end
% 
% 
%%
alpha_vect = [0.05 0.01  0.005 0.001]
region_pair = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
number_permutations =1000;
%%
    for i =1:length(region_pair)
        figure('Name',['tperm' num2str(number_permutations) ' test for region pair ' group_names(region_pair(i,1)+1,:)...
            ' ' group_names(region_pair(i,2)+1,:) ]);
        
       
        tresStr = tperm_fd_ja(pos_fd(group_index{region_pair(i,1)}), pos_fd(group_index{region_pair(i,2)}),...
            number_permutations,0.05,figuretime,1,alpha_vect);
            y1 = get(gca,'YLim');
            if y1(2)<max(tresStr.qval2)
                y1(2)= max(tresStr.qval2) * 1.5;
            end
            y1=[0 y1(2)];
            ylim(y1);
            
            for rr = 2:size(region_boundaries2,1);
                line([region_boundaries2(rr,1),region_boundaries2(rr,1)],y1,'color',plot_color{rr-1},'LineStyle',':');
                line([region_boundaries2(rr,2),region_boundaries2(rr,2)],y1,'color',plot_color{rr-1},'LineStyle',':');
            end
             axis square
        
        set(gca,'TickDir','Out','Fontsize',10);
    end


%%
figure('Name',['perm F-test' num2str(number_permutations)]);
F_res = Fperm_fd_ja(pos_fd_r, xfdcell, reg_betacell,[],number_permutations,[],0.05,1,alpha_vect);
%

% end



