function plot_map_location()
    close all; clear all; clc;

    lon = [-76.936581, -76.936582, -76.936363, -76.936364, -76.93596, -76.93608, -76.93639, -76.93614, -76.93625, -76.93683, -76.93634];
    lat = [38.988600, 38.988601, 38.987993, 38.987991, 38.98746, 38.98774, 38.98723, 38.98739, 38.98730, 38.98781, 38.98755];
    
    % geoscatter(lat, lon, 'o', 'filled', 'MarkerFaceColor', 'b');
    geoscatter(lat, lon, 'o', 'filled', 'MarkerFaceColor', 'b'); hold on;
    geoscatter(38.988732, -76.936603, 'o', 'filled', 'MarkerFaceColor', 'r');
end