function distance_vs_throughput()
    close all; clear all; clc;
    tab = readtable('./data.csv');

    plot_data(tab.distance, tab.average_throughput, "Throughput (Mbps)");
    plot_data(tab.distance, tab.max_throughput, "Max throughput (Mbps)");
    plot_data(tab.distance, tab.min_throughput, "Min throughput (Mbps)");
    plot_data(tab.distance, tab.stdev_throughput, "Deviation in throughput (Mbps)");

    length(tab.distance)

    FontSize = 24;
    figure; hold on;
    errorbar(tab.distance, smoothdata(tab.average_throughput, 'Gaussian', 5), tab.stdev_throughput, '--', 'LineWidth', 3);
    set(gca, 'FontSize', FontSize);
    xlabel("Distance (feet)");
    ylabel("Throughput (Mbps)");
    ylim([0, 120]);
    grid on;
end

function plot_data(distance, y_field, ylabel_text)
    FontSize = 24;
    figure; plot(distance, smoothdata(y_field, 'Gaussian', 5), '--', 'LineWidth', 4);
    set(gca, 'FontSize', FontSize);
    xlabel("Distance (feet)");
    ylabel(ylabel_text);
    ylim([0, 100]);
    grid on;
end