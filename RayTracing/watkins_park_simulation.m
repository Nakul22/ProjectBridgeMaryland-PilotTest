function watkins_park_simulation()
    close all; clear all; clc;
    tx_location_number = 1;
    rx_location_number = 1;

    tx_location_names = ["school", "corousel", "church", "house", "tennis court"];
    rx_location_names = ["wizord of oz"];

    viewer = siteviewer("Buildings", "watkins_regional_park_map.osm");
    Tx_latitudes = [38.884125, 38.888781, 38.883437, 38.887299, 38.888138];
    Tx_longitudes = [-76.785668, -76.793924, -76.780165, -76.783168, -76.790692];
    Rx_latitudes = [38.887138];
    Rx_longitudes = [-76.794883];
    

    for tx_location_number = 1:length(tx_location_names)
        tx_location_number
        tx{tx_location_number} = txsite("Name", tx_location_names(tx_location_number), ...
                                "Latitude", Tx_latitudes(tx_location_number), ...
                                "Longitude", Tx_longitudes(tx_location_number), ...
                                "AntennaHeight", 10, ...
                                "Antenna", 'isotropic', ...
                                "AntennaAngle", 0, ...
                                "TransmitterPower", 34, ...
                                "TransmitterFrequency", 2.4e9);
    end
    rx = rxsite("Name", rx_location_names(rx_location_number), ...
        "Latitude", Rx_latitudes(rx_location_number), ...
        "Longitude", Rx_longitudes(rx_location_number), ...
        "AntennaHeight", 10, ...
        "Antenna", 'isotropic');

    pm = propagationModel('raytracing');
    pm.Method = "sbr";
    pm.MaxNumReflections = 4;

    for tx_location_number = 1:length(tx_location_names)
        tx_location_number
        pattern(tx{tx_location_number});
        los(tx{tx_location_number}, rx);

        rays = raytrace(tx{tx_location_number}, rx, pm);
        received_signal_strength = sigstrength(rx, tx{tx_location_number}, pm);
        plot(rays{1});

        coverage(tx{tx_location_number},pm, ...
            "SignalStrengths", -120:-5, ...
            "MaxRange", 1000, ...
            "Resolution", 50, ...
            "Transparency", 0.6)
    end

end