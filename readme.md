# thesi2s

An AXI4-Lite configurable I²S peripheral implemented in Verilog for AMD Xilinx FPGAs. This repository contains the HDL sources, constraints, IP configuration, and project metadata required to recreate the Vivado project.

## HDL-on-Git (HoG)

This project uses **HDL-on-Git (HoG)** to manage the Vivado project. Rather than version-controlling generated Vivado files (`.xpr`, `.cache`, `.runs`, etc.), only the design sources and project definition are tracked in Git.

Benefits of this workflow include:

* Reproducible Vivado projects from version-controlled sources.
* Cleaner Git history by excluding generated files.
* Easier collaboration with fewer merge conflicts.
* Portable project setup across development machines.

## Requirements

* AMD Vivado **2025.2**
* Git
* Git Bash (Windows) or a compatible POSIX shell
* Git submodules

> **Windows users:** Use **Git Bash** when running HoG scripts with the Windows installation of Vivado. Running them under WSL requires a Linux installation of Vivado.

## Clone the Repository

Clone the repository together with the HoG submodule:

```bash
git clone --recurse-submodules https://github.com/adakhaddad/thesi2s.git
cd thesi2s
```

If the repository was cloned without submodules:

```bash
git submodule update --init --recursive
```

## Configure Vivado

Ensure Vivado is available from your terminal.

Example for Git Bash:

```bash
export PATH="/d/2025.2/Vivado/bin:$PATH"
```

# thesi2s

An AXI4-Lite configurable I²S peripheral implemented in Verilog for AMD Xilinx FPGAs. This repository contains the HDL sources, constraints, IP configuration, and project metadata required to recreate the Vivado project.

## HDL-on-Git (HoG)

This project uses **HDL-on-Git (HoG)** to manage the Vivado project. Rather than version-controlling generated Vivado files (`.xpr`, `.cache`, `.runs`, etc.), only the design sources and project definition are tracked in Git.

Benefits of this workflow include:

* Reproducible Vivado projects from version-controlled sources.
* Cleaner Git history by excluding generated files.
* Easier collaboration with fewer merge conflicts.
* Portable project setup across development machines.

## Requirements

* AMD Vivado **2025.2**
* Git
* Git Bash (Windows) or a compatible POSIX shell
* Git submodules

> **Windows users:** Use **Git Bash** when running HoG scripts with the Windows installation of Vivado. Running them under WSL requires a Linux installation of Vivado.

## Clone the Repository

Clone the repository together with the HoG submodule:

```bash
git clone --recurse-submodules https://github.com/adakhaddad/thesi2s.git
cd thesi2s
```

If the repository was cloned without submodules:

```bash
git submodule update --init --recursive
```

## Configure Vivado

Ensure Vivado is available from your terminal.

Example for Git Bash:

```bash
export PATH="/d/2025.2/Vivado/bin:$PATH"
```

Verify the installation:

```bash
vivado -version
```

## Create the Project

List the available HoG projects:

```bash
./Hog/Do LIST -all
```

Generate the Vivado project:

```bash
./Hog/CreateProject.sh
```

Once generated, open the resulting Vivado project (`.xpr`) or continue using the HoG scripts for synthesis and implementation.

## References

* HDL-on-Git (HoG): https://github.com/hog-cern/Hog
* HoG Documentation: https://hog.readthedocs.io/
