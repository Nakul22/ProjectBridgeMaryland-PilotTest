function simulate_multipath_check()
    close all; clear all; clc;

    % run_simulation("indoor", 1);
    % return

    for environment_type = ["outdoor", "indoor"]
        for location_number = 1
            location_number
            run_simulation(environment_type, location_number);
            % show_results(environment_type, location_number);
        end
    end
end

function show_results(environment_type, location_number)
    % load("./temp.mat");
    load("./Processed_Patterns/Office_received_radiation_patterns_"+environment_type+"_location"+num2str(location_number)+".mat");
    % size(received_radiation_patterns_with_multipath)
    % size(received_radiation_patterns_without_multipath)

    switch_patterns = [1, 2, 3, 4];
    colorlist = linspecer(length(switch_patterns), 'qua');
    config_details = ["[Off, Off]", "[On, Off]", "[Off, On]", "[On, On]"];

    polar_graph = true;

    figure;
    FontSize = 22;
    if(polar_graph)
        pax = polaraxes;
    end
    hold on;
    for switch_pattern_idx = 1:length(switch_patterns)
        new_feature_beam_pattern = [];
        for angles_k = 1:length(angles)
            new_feature_beam_pattern(angles_k) = received_radiation_patterns_with_multipath(angles_k, switch_pattern_idx);
            % db to linear
            % new_feature_beam_pattern(angles_k) = 10.^(received_radiation_patterns_with_multipath(angles_k, switch_pattern_idx)./10);
        end
        
        if(polar_graph)
            polarplot(deg2rad(angles), new_feature_beam_pattern, 'LineWidth', 4, 'color', colorlist(switch_pattern_idx,:));
        else
            plot(angles, new_feature_beam_pattern, 'LineWidth', 4, 'color', colorlist(switch_pattern_idx,:));
        end
        legendstring{switch_pattern_idx} = config_details(switch_patterns(switch_pattern_idx));
    end
    title(environment_type+"_location"+num2str(location_number)+"With Multipath");
    legend(legendstring, 'location', 'northwest');
    set(gca, 'FontSize', FontSize);
    if(~polar_graph)
        xlabel("Angle (degrees)");
        ylabel("Amplitude");
    end

    figure;
    FontSize = 24;
    if(polar_graph)
        pax = polaraxes;
    end
    hold on;
    for switch_pattern_idx = 1:length(switch_patterns)
        new_feature_beam_pattern = [];
        for angles_k = 1:length(angles)
            
            new_feature_beam_pattern(angles_k) = received_radiation_patterns_without_multipath(angles_k, switch_pattern_idx);
            % db to linear
            % new_feature_beam_pattern(angles_k) = 10.^(received_radiation_patterns_without_multipath(angles_k, switch_pattern_idx)./10);
        end
        
        if(polar_graph)
            polarplot(deg2rad(angles), new_feature_beam_pattern, 'LineWidth', 4, 'color', colorlist(switch_pattern_idx,:));
        else
            plot(angles, new_feature_beam_pattern, 'LineWidth', 4, 'color', colorlist(switch_pattern_idx,:));
        end
        % legendstring{switch_pattern_idx} = config_details(switch_patterns(switch_pattern_idx));
    end
    title(environment_type+"_location"+num2str(location_number)+"Without Multipath");
    legend(legendstring, 'location', 'northwest');
    set(gca, 'FontSize', FontSize);
    if(~polar_graph)
        xlabel("Angle (degrees)");
        ylabel("Amplitude");
    end
end

function run_simulation(environment_type, location_number)
    tic;
    homepath = "/Volumes/GoogleDrive/My Drive/RFOwlet/AoA/Solving_Multipath/Exported_HFSS_Antenna_Pattern/";

    % antenna_element{1} = phased.IsotropicAntennaElement('FrequencyRange',[2.35e9 2.45e9]);
    % antenna_element{2} = dipole('Length', 0.059, 'Width', 0.01, 'Tilt', 0);
    % antenna_element{3} = create_antenna_from_HFSS_data(homepath + "pattern_2_2400Mhz.csv");
    % antenna_element{4} = create_antenna_from_HFSS_data(homepath + "pattern_2_2400Mhz.csv");

    Tx_antenna_element = dipole('Length', 0.059, 'Width', 0.01, 'Tilt', 0);

    antenna_element{1} = create_antenna_from_HFSS_data(homepath + "pattern_1_2400Mhz.csv");
    antenna_element{2} = create_antenna_from_HFSS_data(homepath + "pattern_2_2400Mhz.csv");
    antenna_element{3} = create_antenna_from_HFSS_data(homepath + "pattern_3_2400Mhz.csv");
    antenna_element{4} = create_antenna_from_HFSS_data(homepath + "pattern_4_2400Mhz.csv");

    % isPolarizationCapable(antenna_element{1})
    % isPolarizationCapable(antenna_element{2})
    % isPolarizationCapable(antenna_element{3})
    % isPolarizationCapable(antenna_element{4})

    figure; pattern(antenna_element{1}, 2.4e9, 'Type', 'powerdb');
    figure; pattern(antenna_element{2}, 2.4e9, 'Type', 'powerdb');
    figure; pattern(antenna_element{3}, 2.4e9, 'Type', 'powerdb');
    figure; pattern(antenna_element{4}, 2.4e9, 'Type', 'powerdb');

    return
    if(environment_type == "indoor")
        % TR = stlread("conferenceroom.stl");
        % scale = 5;
        % scaledPts = TR.Points * scale;
        % TR_scaled = triangulation(TR.ConnectivityList, scaledPts);
        % viewer = siteviewer('SceneModel', TR_scaled);
        % Tx_antenna_position_indoor = scale.*[[0; -1.25; 2], [-1.25; -1.25; 2], [-1.4; 1; 1.5]];
        % Rx_antenna_position_indoor = scale.*[[0; 1.25; 2], [1.25; 1.25; 2], [1.4; -1; 1.5]];
        TR = stlread("office.stl");
        scale = 2;
        scaledPts = TR.Points * scale;
        TR_scaled = triangulation(TR.ConnectivityList, scaledPts);
        viewer = siteviewer('SceneModel', TR_scaled);
        Tx_antenna_position_indoor = [[1; 1; 2.0], [4; 1; 2.5], [2; 1; 3.0], [2; 10; 2.5], [8; 6; 2.0]];
        Rx_antenna_position_indoor = [[2; 4; 2.0], [8; 4; 2.5], [1.5; 11; 3.0], [8; 11; 2.5], [3; 12; 2.0]];
    else
        viewer = siteviewer("Buildings", "map.osm");
        Tx_latitudes = [38.989262, 38.988037, 38.989238];
        Tx_longitudes = [-76.936151, -76.936761, -76.935519];
        Rx_latitudes = [38.989267, 38.987946, 38.989336];
        Rx_longitudes = [-76.935913, -76.936748, -76.935467];
    end
    
    if(environment_type == "indoor")
        tx = txsite("Name","Small cell transmitter", ...
            "CoordinateSystem", "cartesian", ...
            "AntennaPosition", Tx_antenna_position_indoor(:,location_number), ...
            "Antenna", 'isotropic', ...
            "AntennaAngle", 0, ...
            "TransmitterPower", 20, ...
            "TransmitterFrequency", 2.4e9);
    else
        tx = txsite("Name","Small cell transmitter", ...
            "Latitude", Tx_latitudes(location_number), ...
            "Longitude", Tx_longitudes(location_number), ...
            "AntennaHeight", 1, ...
            "Antenna", 'isotropic', ...
            "AntennaAngle", 0, ...
            "TransmitterPower", 34, ...
            "TransmitterFrequency", 2.4e9);
    end



    % pattern(tx);
    angles = [0:5:360];
    for antenna_pattern_idx = 1:4
        antenna_pattern_idx
        for azimuth_angle = 1:length(angles)
            if(environment_type == "indoor")
                rx = rxsite("Name","RxPattern1", ...
                    "CoordinateSystem", "cartesian", ...
                    "AntennaPosition", Rx_antenna_position_indoor(:,location_number), ...
                    "Antenna", antenna_element{antenna_pattern_idx}, ...
                    "AntennaAngle", azimuth_angle);
            else
                rx = rxsite("Name","RxPattern1", ...
                    "Latitude", Rx_latitudes(location_number), ...
                    "Longitude", Rx_longitudes(location_number), ...
                    "AntennaHeight", 1, ...
                    "Antenna", antenna_element{antenna_pattern_idx}, ...
                    "AntennaAngle", azimuth_angle);
            end
            % los(tx, rx);

            pm = propagationModel('raytracing');
            if(environment_type == "indoor")
                pm.CoordinateSystem = 'cartesian';
            end
            pm.Method = "image";
            pm.MaxNumReflections = 2;
            rays_with_multipath = raytrace(tx, rx, pm);
            received_signal_strength = sigstrength(rx, tx, pm);
            received_radiation_patterns_with_multipath(azimuth_angle, antenna_pattern_idx) = received_signal_strength;

            pm = propagationModel('raytracing');
            if(environment_type == "indoor")
                pm.CoordinateSystem = 'cartesian';
            end
            pm.Method = "image";
            pm.MaxNumReflections = 0;
            rays_without_multipath = raytrace(tx, rx, pm);
            received_signal_strength = sigstrength(rx, tx, pm);
            received_radiation_patterns_without_multipath(azimuth_angle, antenna_pattern_idx) = received_signal_strength;

        end
        plot(rays_with_multipath{1});
    end
    % save("./temp.mat", "received_radiation_patterns_with_multipath", "received_radiation_patterns_without_multipath", "angles");
    save("./Processed_Patterns/Office_received_radiation_patterns_"+environment_type+"_location"+num2str(location_number)+".mat", "received_radiation_patterns_with_multipath", "received_radiation_patterns_without_multipath", "angles");
    toc
end