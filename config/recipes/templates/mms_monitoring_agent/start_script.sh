nohup python /home/ec2-user/mms-agent/agent.py > /home/ec2-user/mms_agent.log 2>&1 &

sleep 1

echo "MMS Monitoring Agent Started"