#
#    Copyright 2010-2019 the original author or authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

FROM tomcat
RUN mkdir /data
ADD jmx_prometheus_javaagent-0.12.0.jar /data/jmx_prometheus_javaagent-0.12.0.jar
ADD prometheus-jmx-config.yaml /data/prometheus-jmx-config.yaml
COPY target/jpetstore.war /usr/local/tomcat/webapps/