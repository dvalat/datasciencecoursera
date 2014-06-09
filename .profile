SSH_ENV="$HOME/.ssh"

# Start the ssh-agent
function start_agent {
	echo "Initializing new SSH agent..."
	# Spawn ssh-agent
	ssh-agent | sed 's/^echo/#echo/' > $SSH_ENV
	echo succeeded
	chmod 600 $SSH_ENV
	. $SSH_ENV > /dev/null
	ssh-add
}

# Test for identities
function test_identities {
	# Test whether standard identities have been added to the agent already
	ssh-add -l | grep "The agent has no identities" 1>/dev/null 2>/dev/null
	if [ $? -eq 0 ]; then
		ssh-add
		# $SSH_AUTH_SOCK broken so we start a new proper agent
		if [ $? -eq 2 ];then
			start_agent
		fi
	fi
}

# Check for running ssh-agent with proper $SSH_AGENT_PID
ps -ef | grep $SSH_AGENT_PID 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	ps -ef | grep ssh-agent 1>/dev/null 2>/dev/null
fi

if [ $? -eq 0 ]; then
	test_identities
else
	# If $SSH_AGENT_PID is not properly set, we might be able to load one from $SSH_ENV
	. $SSH_ENV > /dev/null

	ps -ef | grep $SSH_AGENT_PID 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ]; then
		ps -ef | grep ssh-agent 1>/dev/null 2>/dev/null
	fi

	if [ $? -eq 0 ]; then
		test_identities
	else
		start_agent
	fi
fi