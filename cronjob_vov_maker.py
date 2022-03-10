from crontab import CronTab

cron = CronTab(user='olli')

job = cron.new(command='python3 vov_backend.py')

job.every(1).days()

cron.write()