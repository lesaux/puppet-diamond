import diamond.collector
import sys
import subprocess
import re
import string

class WeblogicCollector(diamond.collector.Collector):

    def get_default_config(self):
        """
        Returns the default collector settings
        """
        config = super(WeblogicCollector, self).get_default_config()
        config.update({
            'enabled':  False,
            'wlstscript': '/tmp/beans.py',
        })
        return config

    def generate_beans(self):
        f = open('/tmp/beans.py', 'w')
        for host in self.config['hosts']:
            c = self.config['hosts'][host]
            f.write('instance = "t3://' + c['wlhost'] + ':' + c['wlport'] + '"\r\n')
            f.write('connect("' + c['wluser'] + '","' + c['wlpass'] + '", instance)\r\n')
            f.write('serverRuntime()\r\n')
            f.write('metrics = [\r\n')
            for metric in self.config['hosts'][host]:
                 m = self.config['hosts'][host][metric]
                 if type(m) is not str:
                     f.write('("' + m['mbeanpath'] + '","' + c['wlhost'] + "." + m['graphitestat'] + '","' + m['mbeanname'] + '"),\r\n')
            f.write(']\r\n')
            f.write('for mbeanpath, graphitestat, mbeanname in metrics:\r\n')
            f.write('    cd(mbeanpath)\r\n')
            f.write('    print "%s:%s:%s:%i" % ("metric", graphitestat, mbeanname, get(mbeanname))\r\n')
        f.close()

    def collect(self):
        self.generate_beans()
        p = subprocess.Popen([self.config['wlstpath'], self.config['wlstscript']], env={'JAVA_HOME':self.config['java_home']}, stdout=subprocess.PIPE)
        for line in iter(p.stdout.readline,''):
            if re.match("^metric:", line) is not None:
                label, metric_name, shortname, metric_value = string.split(line.rstrip(),":")
                # Publish Metric
                self.publish(metric_name, metric_value)
