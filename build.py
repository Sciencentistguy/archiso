#!/bin/python3
import argparse
import subprocess


def runcommand(command: str):
    print(f" -> {command}")
    if args.safe_mode:
        if "y" not in input(f"Run the command '{command}'? (y/N): ").lower():
            print(f"Not running '{command}'")
            exit(1)
    subprocess.run(command.split())


def replace(flags: dict, filename: str):
    with open(filename, "r+") as file:
        text = file.read()
        for flag, value in flags.items():
            text = text.replace(flag, value)
            print(f" -> Replaced {flag} with {value} in {filename}")
        file.seek(0)
        file.write(text)
        file.truncate()


parser = argparse.ArgumentParser()
parser.add_argument("--quiet", help="Do not prompt for user input at any point", action="store_true", default=False)
parser.add_argument("--safe-mode", help="Prompt the user before running any commands", action="store_true", default=False)
args = parser.parse_args()

# Clean environment
print("\nCleaning the environment")
runcommand("sudo umount -f work/efiboot")
runcommand("sudo umount -f work/x86_64/airootfs/tmp")
runcommand("sudo rm -rf work")

# Create live files
print("\nCreating live files")
runcommand("cp _pacman.conf pacman.conf")

# Replace flags in config files
print("\nReplacing flags in config files")
pacman_conf_flags = {"$USER": "jamie"}
replace(pacman_conf_flags, "pacman.conf")

# Build the image
if "y" in input("Build the image? (y/N): ").lower():
    runcommand("sudo ./build.sh -v -L ARCH -V custom")
