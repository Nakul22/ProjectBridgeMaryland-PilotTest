function setup_simulated_data_collection()

    % fileparts(which('conferenceroom.stl'))

    close all; clear all; clc;


    homepath = "/Volumes/GoogleDrive/My Drive/RFOwlet/AoA/Solving_Multipath/Exported_HFSS_Antenna_Pattern/";
    filename = "pattern_2_2400Mhz.csv";

    % [d2] = create_antenna_from_HFSS_data(homepath+filename);

    % figure; pattern(d2, 2.4e9, 'Type', 'powerdb');


    if(1)
        % TR = stlread("conferenceroom.stl");
        TR = stlread("office.stl");
        % size_room = 3meters x 3meters x 2.5meters
        scale = 2;
        scaledPts = TR.Points * scale;
        TR_scaled = triangulation(TR.ConnectivityList,scaledPts);
        viewer = siteviewer('SceneModel',TR_scaled);

        tx = txsite("cartesian", ...
            "AntennaPosition", [4; 1; 2.5], ...
            "TransmitterFrequency",2.8e9);
        show(tx);

        rx = rxsite("cartesian", ...
            "AntennaPosition", [8; 4; 2.5]);
        show(rx);
        los(tx, rx);
        return
    end

    % viewer = siteviewer("Buildings", "map.osm");
    % clearMap(viewer)
    d1 = dipole('Length', 0.059, 'Width', 0.01, 'Tilt', 0);
    % figure; pattern(d1, 2.4e9);
    % d2 = dipole('Length', 0.059, 'Width', 0.01, 'Tilt', 0);
    % figure; pattern(d2, 2.4e9);


    % Making antenna element with custom pattern
    % fc = 2.4e9;
    % azang = -180:180;
    % elang = -90:90;
    % magpattern = mag2db(repmat(cosd(elang)',1,numel(azang)));
    % phasepattern = zeros(size(magpattern));
    % antenna = phased.CustomAntennaElement('AzimuthAngles',azang, ...
    %     'ElevationAngles',elang,'MagnitudePattern',magpattern, ...
    %     'PhasePattern',phasepattern);
    % % resp = antenna(fc,[20;30])


    % % d2 = antenna;
    % pattern(d3, 2.4e9, 20, -90:90);

    % return
    % Making antenna element with custom pattern

    Tx_latitudes = [38.989262, 38.988037, 38.989238];
    Tx_longitudes = [-76.936151, -76.936761, -76.935519];
    Rx_latitudes = [38.989267, 38.987946, 38.989336];
    Rx_longitudes = [-76.935913, -76.936748, -76.935467];
    location_number = 3;
    
    tx = txsite("Name","Small cell transmitter", ...
        "Latitude", Tx_latitudes(location_number), ...
        "Longitude", Tx_longitudes(location_number), ...
        "AntennaHeight", 1, ...
        "Antenna", 'isotropic', ...
        "AntennaAngle", 0, ...
        "TransmitterPower", 34, ...
        "TransmitterFrequency", 2.4e9);
        % "TransmitterFrequency", 2.68e9);
    rx{1} = rxsite("Name","RxPattern1", ...
        "Latitude", Rx_latitudes(location_number), ...
        "Longitude", Rx_longitudes(location_number), ...
        "AntennaHeight", 1, ...
        "Antenna", 'isotropic', ...
        "AntennaAngle", 0);
    rx{2} = rxsite("Name","RxPattern1", ...
        "Latitude", Rx_latitudes(location_number), ...
        "Longitude", Rx_longitudes(location_number), ...
        "AntennaHeight", 1, ...
        "Antenna", d1, ...
        "AntennaAngle", 0);
    rx{3} = rxsite("Name","RxPattern1", ...
        "Latitude", Rx_latitudes(location_number), ...
        "Longitude", Rx_longitudes(location_number), ...
        "AntennaHeight", 1, ...
        "Antenna", d2, ...
        "AntennaAngle", 90);
    
    pm = propagationModel('raytracing');
    pm.Method = "image";
    pm.MaxNumReflections = 2;

    % pattern(tx);
    for antenna_pattern_idx = 3
        rx{antenna_pattern_idx};
        % los(tx,rx{antenna_pattern_idx});
        rays = raytrace(tx, rx{antenna_pattern_idx}, pm);
        received_signal_strength = sigstrength(rx{antenna_pattern_idx}, tx, pm);
        % plot(rays{1});

        number_of_paths = length(rays{1});

        for kk = 1:number_of_paths
            disp("Path "+ kk);
            disp("AngleOfArrival = " + rays{1}(kk).AngleOfArrival(1) + ", " + rays{1}(kk).AngleOfArrival(2) + " deg");
            disp("PropagationDelay = " + rays{1}(kk).PathLoss + " sec");
            disp("PhaseShift = " + rays{1}(kk).PhaseShift + " rad");
            disp("PathLoss = " + rays{1}(kk).PathLoss + " db");
            disp(" ");
        end
        disp("Received signal strength = " + received_signal_strength + " db");

        phase_diff_paths = abs(rays{1}(1).PhaseShift - rays{1}(2).PhaseShift)/(2*pi);
    end


    % viewer = siteviewer("Buildings","chicago.osm");

    % tx = txsite("Latitude",41.8800, ...
    %     "Longitude",-87.6295, ...
    %     "TransmitterFrequency",2.5e9);
    % show(tx)
    % rx = rxsite("Latitude",41.8813452, ...
    %     "Longitude",-87.629771, ...
    %     "AntennaHeight",30);
    % show(rx)

    % pm = propagationModel("raytracing","Method","image", ...
    %     "MaxNumReflections",1);
    % raytrace(tx,rx,pm)

    % pm.Method = "sbr";
    % pm.MaxNumReflections = 2;
    % clearMap(viewer)
    % raytrace(tx,rx,pm)

end