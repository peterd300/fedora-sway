#!/usr/bin/env bash
#    ____
#   / __/    __  ___ __ __
#  _\ \ | |/|/ / _ `/ // /
# /___/ |__,__/\_,_/\_, /
#                  /___/
# Thanks for ML4F for this script
# https://gitlab.com/stephan-raabe/dotfiles

terminate_clients() {
  	TIMEOUT=5
	# Get a list of all client PIDs in the current Sway session
	client_pids=$(swaymsg -t get_tree | jq '.. | select(.pid? != null) | .pid')

	# Send SIGTERM (kill -15) to each client PID and wait for termination
	for pid in $client_pids; do
		echo ":: Sending SIGTERM to PID $pid"
		kill -15 "$pid" 2>/dev/null
	done

	start_time=$(date +%s)
	for pid in $client_pids; do
		# Wait for the process to terminate
		while kill -0 "$pid" 2>/dev/null; do
		current_time=$(date +%s)
		elapsed_time=$((current_time - start_time))

		if [ $elapsed_time -ge $TIMEOUT ]; then
			echo ":: Timeout reached."
			return 0
		fi

		echo ":: Waiting for PID $pid to terminate..."
		sleep 1
		done

		echo ":: PID $pid has terminated."
	done
	
#	# Stop eventuele actieve listeners (pad gecorrigeerd naar $HOME)
#	if [ -f "$HOME/.config/ml4w/listeners.sh" ]; then
#		bash "$HOME/.config/ml4w/listeners.sh" --stopall
#	fi
}

if [[ "$1" == "exit" ]]; then
	echo ":: Exit"
	terminate_clients
	sleep 0.5
	swaymsg exit
	sleep 2
fi

if [[ "$1" == "lock" ]]; then
	echo ":: Lock"
	sleep 0.5
	swaylock
fi

if [[ "$1" == "reboot" ]]; then
	echo ":: Reboot"
	terminate_clients
	sleep 0.5
	systemctl reboot
fi

if [[ "$1" == "shutdown" ]]; then
	echo ":: Shutdown"
	terminate_clients
	sleep 0.5
	systemctl poweroff
fi

if [[ "$1" == "suspend" ]]; then
	echo ":: Suspend"
	sleep 0.5
	systemctl suspend
fi

if [[ "$1" == "hibernate" ]]; then
	echo ":: Hibernate"
	sleep 1
	systemctl hibernate
fi
