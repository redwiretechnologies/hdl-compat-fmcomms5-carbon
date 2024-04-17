# hdl-compat-fmcomms5-carbon

This repository is designed to be an OOT module to use in conjunction with [hdl-rwt](https://github.com/redwiretechnologies/hdl-rwt/tree/main).
It adds support for the Carbon SDR, as well as the Carbon SDR with a CARP (Carbon Accessory Rf Platform) backpack, to use the FMCOMMS5 project.   

For issues with this repository, its documentation, or additional questions, please reach out to our lead FPGA engineer, Jonathan Ambrose, at (jambrose@redwiretechnologies.us).

---

# Requirements

Along with the requirements listed in the [hdl-rwt](https://github.com/redwiretechnologies/hdl-rwt/tree/main) README, this repository additionally requires the OOT module [hdl-fmcomms5](https://github.com/redwiretechnologies/hdl-fmcomms5/tree/main), [hdl-carbon](https://github.com/redwiretechnologies/hdl-carbon/tree/main), and the addtional requirements listed in the README of [hdl-carbon](https://github.com/redwiretechnologies/hdl-carbon/tree/main).   

Additionally, if you would like to target the 9EG or 15EG SOMs that we offer for the Carbon, it will require the purchase of a Vivado license to target these larger FPGAs.

---

# Building

To use this repository in conjunction with [hdl-rwt](https://github.com/redwiretechnologies/hdl-rwt/tree/main), this repository must be checked out into the `oot` directory as shown below:
```
$ ls oot

hdl-carbon/  hdl-compat-fmcomms5-carbon/  hdl-fmcomms5/  hdl-te080x-board-files/
``` 

After having done this, you must run `scripts/link_oot.sh` from the [hdl-rwt](https://github.com/redwiretechnologies/hdl-rwt/tree/main) repository. This will create hard symlinks from the files in your OOT modules to the directory structure within [hdl-rwt](https://github.com/redwiretechnologies/hdl-rwt/tree/main).   

After linking your files, running `scripts/build_projects.py` from [hdl-rwt](https://github.com/redwiretechnologies/hdl-rwt/tree/main) will add the additional options to build for the Carbon and Carbon-CARP carrier boards, as can be seen below:
```
$ ./scripts/build_projects.py 

Select Carrier(s)
  0: oxygen
  1: carbon-carp
  2: carbon
  3: All

Selection(s): 2

Select Personality(s) for Revision rev4 of Carrier carbon
  0: fmcomms5
  1: blank
  2: default
  3: gr-iio
  4: All

Selection(s):  
```

# Utilization

The `utilization` directory stores information regarding the most recent set of builds using the projects in this repository. 
There are a set of Markdown files (starting with [utilization.md](utilization/utilization.md)) that organizes the information in an easy-to-navigate format. 
Additionally, full utilization reports can be viewed in the directory `utilization/utilization`. 

# Personalities

For clarification's sake on the nomenclature, a "personality" is a generic block diagram configuration that can/will be customized on a per board basis. A "project" is the single customized Vivado project for a combination of personality and board. 
 
## `fmcomms5`

For details about this personality, please refer to the README for the [hdl-fmcomms5](https://github.com/redwiretechnologies/hdl-fmcomms5/tree/main) repository.   

The current utilization numbers for this personality can be found [here](utilization/markdown/personalities/fmcomms5.md).
 
### GPIO Description Table (Carbon)

| Pin Number | Name                                | In/Out |
| ---------- | ----------------------------------- | ------ |
| 0-8        | GPIO Header                         | IO     |
| 9-21       | Reserved                            |        |
| 22-29      | AD9361     CTRL_OUT (gpio_status_0) | In     |
| 30-37      | AD9361 (2) CTRL_OUT (gpio_status_1) | In     |
| 38-41      | AD9361     CTRL_IN  (gpio_ctl_0)    | Out    |
| 42-45      | AD9361 (2) CTRL_IN  (gpio_ctl_1)    | Out    |
| 46-50      | Reserved                            |        |
| 51         | AD9361 Sync                         | Out    |
| 52         | AD9361 Resetb                       | Out    |
| 53         | AD9361 EN AGC                       | Out    |
| 54         | UP Enable                           | Out    |
| 55         | UP TXnRX                            | Out    |
| 56         | AD9361 (2) EN AGC                   | Out    |
| 57         | UP Enable (2)                       | Out    |
| 58         | UP TXnRX (2)                        | Out    |
| 59-64      | Reserved                            |        |
| 65         | AD9361 (2) Resetb                   | Out    |
| 66-94      | Reserved                            |        |
 
### GPIO Description Table (Carbon-CARP)

| Pin Number | Name                                | In/Out |
| ---------- | ----------------------------------- | ------ |
| 0          | Line Matrix Clock                   | In     |
| 1          | Line Matrix Reset                   | In     |
| 2-5        | Line Matrix Input Select            | In     |
| 6-9        | Line Matrix Output Select           | Out    |
| 9-21       | Reserved                            |        |
| 22-29      | AD9361     CTRL_OUT (gpio_status_0) | In     |
| 30-37      | AD9361 (2) CTRL_OUT (gpio_status_1) | In     |
| 38-41      | AD9361     CTRL_IN  (gpio_ctl_0)    | Out    |
| 42-45      | AD9361 (2) CTRL_IN  (gpio_ctl_1)    | Out    |
| 46-50      | Reserved                            |        |
| 51         | AD9361 Sync                         | Out    |
| 52         | AD9361 Resetb                       | Out    |
| 53         | AD9361 EN AGC                       | Out    |
| 54         | UP Enable                           | Out    |
| 55         | UP TXnRX                            | Out    |
| 56         | AD9361 (2) EN AGC                   | Out    |
| 57         | UP Enable (2)                       | Out    |
| 58         | UP TXnRX (2)                        | Out    |
| 59-64      | Reserved                            |        |
| 65         | AD9361 (2) Resetb                   | Out    |
| 66-94      | Reserved                            |        |
