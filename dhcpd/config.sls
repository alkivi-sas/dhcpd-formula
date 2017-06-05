{% from "dhcpd/map.jinja" import dhcpd with context %}

include:
  - dhcpd

dhcpd-config:
  file.managed:
    - name: {{ dhcpd.config_file }}
    - source: salt://dhcpd/templates/dhcpd.conf.jinja
    - template: jinja
    - user: root
{% if 'BSD' in salt['grains.get']('os') %}
    - group: wheel
{% else %}
    - group: root
{% endif %}
    - mode: 644
    - context:
      dhcpd_config: {{ dhcpd.config }}
    - watch_in:
      - service: dhcpd


{% if dhcpd.service_config is defined %}

service-config:
  file.managed:
    - name: {{ dhcpd.service_config }}
    - source: {{ 'salt://dhcpd/templates/service_config.' ~ salt['grains.get']('os_family') }}.jinja
    - makedirs: True
    - template: jinja
    - user: root
{% if 'BSD' in salt['grains.get']('os') %}
    - group: wheel
{% else %}
    - group: root
{% endif %}
    - mode: 644
    - context:
      config: {{ dhcpd.config }}
    - watch_in:
      - service: dhcpd

{% endif %}
