import csv
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.cm as cm
import itertools

published_results = []
experiment_results = []
# column index of various fields
FREQ = 0
VDD = 1
POWER = 2

def autolabel(axis, rects, decimals=2):
  # attach some text labels
  for rect in rects:
    height = rect.get_height()
    axis.text(rect.get_x() + rect.get_width() / 2.,
      0.5 * height,
      '%.*f' % (decimals, float(height)),
      fontdict={"color": "black", "size": 10},
      ha='center', va='bottom')

with open("publised-spe-results.csv") as csvfile:
  reader = csv.reader(csvfile, delimiter=',')
  for row in reader:
    published_results.append(row)

with open("mcpat_results.csv") as csvfile:
  reader = csv.reader(csvfile, delimiter=',')
  for row in reader:
    experiment_results.append(row)

def get_frequency(r):
  return float(r[FREQ]) / 1000

def get_power(r):
  return float(r[POWER])

def vdd_equals(vdd):
  def vdd_filter(r):
    return float(r[VDD]) == vdd
  return vdd_filter

# freq is the same for all vdd, just grab the first
x = map(get_frequency, filter(vdd_equals(1.1), published_results))
y1 = map(get_power, filter(vdd_equals(1.1), published_results))
y2 = map(get_power, filter(vdd_equals(1.2), published_results))
y3 = map(get_power, filter(vdd_equals(1.3), published_results))
ylims = [0, 20]

font_size = 10
matplotlib.rcParams.update({'font.size': 10})

fig, axarr = plt.subplots(3, sharex=True, sharey=True)
ax = axarr[0]
ax.set_title("Published vs. Modeled Cell Power Consumption by Frequency: Vdd = 1.1", fontsize=font_size)
ax.set_ylabel("Power (Watts)", fontsize=font_size)
legend = ax.legend(['published', 'modeled'], loc='upper left', fontsize=font_size)
ax.set_ylim(ylims)

ax.plot(x, y1)
ax.plot(x, map(get_power, filter(vdd_equals(1.1), experiment_results)))

legend = ax.legend(['published', 'modeled'], loc='upper left', fontsize=font_size)

ax = axarr[1]
ax.set_title("Published vs. Modeled Cell Power Consumption by Frequency: Vdd = 1.2", fontsize=font_size)
ax.set_ylabel("Power (Watts)", fontsize=font_size)
ax.plot(x, y2)
ax.plot(x, map(get_power, filter(vdd_equals(1.2), experiment_results)))
legend = ax.legend(['published', 'modeled'], loc='upper left', fontsize=font_size)
ax.set_ylim(ylims)

ax = axarr[2]
ax.set_title("Published vs. Modeled Cell Power Consumption by Frequency: Vdd = 1.3", fontsize=font_size)
ax.set_ylabel("Power (Watts)", fontsize=font_size)
ax.set_xlabel("Frequency (GHz)", fontsize=font_size)
ax.plot(x, y3)
ax.plot(x, map(get_power, filter(vdd_equals(1.3), experiment_results)))
legend = ax.legend(['published', 'modeled'], loc='upper left', fontsize=font_size)
ax.set_ylim(ylims)

fig.set_size_inches(7, 7)
plt.savefig("spe-voltage-freq.png",bbox_inches='tight')
plt.close(fig)
plt.show()
