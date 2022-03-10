from crontab import CronTab

cron = CronTab(user='admin12345')

job = cron.new(command='python3 vov_backend.py')

job.every(1).days()

cron.write()