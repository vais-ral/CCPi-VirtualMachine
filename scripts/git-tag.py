import subprocess
from subprocess import PIPE

task = subprocess.run(['git', 'tag'],stdin=PIPE, stdout=PIPE, stderr=PIPE)

tmp = str(task.stdout)
res = task.stdout.decode('ascii').split('\n')
tag_date = []
tag = []
for i,el in enumerate(res):
    #print (i, el)
    if el is not '':
        task2 = subprocess.run(['git', 'log' ,'--format=format:%at' , '-1', el], 
                               stdin=PIPE, stdout=PIPE, stderr=PIPE)
        tag_date.append(task2.stdout.decode('ascii'))
        tag.append(el)
        
#print (tag)
#print (tag_date)

# get the tag with the latest date
order = range(len(tag_date))
list_3 = [el for el in zip(tag_date, order)]
list_3.sort()
#print (list_3[-1][1] , tag[list_3[-1][1]])
last_tag = tag[list_3[-1][1]]
# commits

# get the 
task = subprocess.run(['git', 'rev-list' , '{}..HEAD'.format(last_tag), '--count'], 
          stdin=PIPE, stdout=PIPE, stderr=PIPE)

res = task.stdout.decode('ascii').split('\n')
if len(res) == 2:
    ncommits = res[0]
else:
    raise ValueError('current output', res)

CIL_VERSION=last_tag+"_"+ncommits
print (CIL_VERSION[1:])